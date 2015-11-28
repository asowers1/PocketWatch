//
//  FZCache.m
//  FZCache
//
//  Created by Anton Remizov on 1/31/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "FZCache.h"
#import <FZBase/NSFileManager+Fuzz.h>
#define DEFAULT_RAM_CACHE_SIZE 100000 // 100 MB
#define DEFAULT_LOCAL_CACHE_SIZE 200000000 // 200 MB
#define DEFAULT_LOCAL_CACHE_BARRIER 500000000 // 500 MB
#define kFZCachedDataDirectory @"FZCachedDataDirectory"

@interface FZRamCache : NSCache

- (NSData *)cachedItemForKey:(NSString*)key;
- (void)cacheItem:(NSData *)data
		   forKey:(NSString *)key;
@end

static inline NSString * FZDiskSafeCacheKeyForKey(NSString* key, NSString *cacheName)
{
	NSCharacterSet* set = [NSCharacterSet punctuationCharacterSet];
	NSMutableCharacterSet* mutableSet = [set mutableCopy];
	[mutableSet removeCharactersInString:@"."];
	NSArray *tmpArray = [key componentsSeparatedByCharactersInSet:mutableSet];
	NSString* safeKey = [tmpArray componentsJoinedByString:@"_"];
	NSString* safeExt = [safeKey pathExtension];
	NSString* safeName = [safeKey stringByDeletingPathExtension];
	
	if(cacheName.length)
		safeName = [safeName stringByAppendingFormat:@"_%@", cacheName];
	return [safeName stringByAppendingPathExtension:safeExt];
}

//static inline NSString * FZImageCacheKeyFromURLRequest(NSURLRequest *request) {
//    return [[request URL] absoluteString];
//}

@implementation FZRamCache

- (id)cachedItemForKey:(NSString*)key {
	return [self objectForKey:key];
}

- (void)cacheItem:(id)item
		   forKey:(NSString *)key
{
	float length = 0;
	id tmpCacheItem = item;
	if ([item isKindOfClass:[NSData class]])
		length = ((NSData *)item).length/1000;
	else if ([item isKindOfClass:[UIImage class]])
	{
		CGSize size = ((UIImage*)item).size;
		length = size.width*size.height*4/1000;
	}
	else if ([item respondsToSelector:@selector(encodeWithCoder:)])
	{
		tmpCacheItem = [NSKeyedArchiver archivedDataWithRootObject:item];
		length = ((NSData *)tmpCacheItem).length/1000;
	}
	else
	{
		[self setObject:item forKey:key];
	}
	
	if (tmpCacheItem && key)
		[self setObject:tmpCacheItem forKey:key cost:length /* size of data in kb */];
	else
		NSLog(@"Error Caching data for key : %@",key);
}

@end

static NSInteger localCacheBarrier = DEFAULT_LOCAL_CACHE_BARRIER;
static NSInteger localCacheSize = DEFAULT_LOCAL_CACHE_SIZE;

@implementation FZCache

+ (NSString *)cachePathForKey:(NSString*)key
{
	static NSString* basePath = nil;
	if (!basePath) {
		basePath = [NSFileManager documentDirectoryPath];
		basePath = [basePath stringByAppendingPathComponent:kFZCachedDataDirectory];
		[NSFileManager addSkipBackupAttributeToItemAtPath:basePath];
	}
	NSString* itemPath = basePath;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken,
				  ^{
					  BOOL tmpIsDirectory = NO;
					  __autoreleasing NSError* error = nil;
					  if (![[NSFileManager defaultManager] fileExistsAtPath:itemPath isDirectory:&tmpIsDirectory])
					  {
						  [[NSFileManager defaultManager]  createDirectoryAtPath:itemPath withIntermediateDirectories:NO attributes:nil error:&error];
						  if (error)
						  {
							  NSLog(@"FZCache error creating directory at path %@: %@",itemPath,error.description);
						  }
						  else
						  {
							  [NSFileManager addSkipBackupAttributeToItemAtPath:itemPath];
						  }
					  }
				  });
	
	return [itemPath stringByAppendingPathComponent:FZDiskSafeCacheKeyForKey(key, nil)];
}

+ (FZRamCache *)sharedDataCache
{
	static FZRamCache *_imageCache = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_imageCache = [[FZRamCache alloc] init];
		[_imageCache setTotalCostLimit:DEFAULT_RAM_CACHE_SIZE];
		[_imageCache setEvictsObjectsWithDiscardedContent:YES];
	});
	
	return _imageCache;
}

+ (NSData *)itemFromCacheForPath:(NSString *)path
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		NSData *data = [NSData dataWithContentsOfFile:path];
		if (data)
		{
			NSDictionary *tmpModifiedDateAttribute = @{NSFileModificationDate : [NSDate date]};
			__autoreleasing NSError* error = nil;
			[[NSFileManager defaultManager] setAttributes:tmpModifiedDateAttribute ofItemAtPath:path error:&error];
			if (error)
				NSLog(@"FZCache error setting attributes to item at path %@: %@",path,error.description);
			return data;
		}
	}
	return nil;
}
+ (id)cachedItemForKey:(NSString *)key;
{
	return [self cachedItemForKey:key inCache:kFZCacheAll];
}

+ (id)cachedItemForKey:(NSString*)key inCache:(FZCacheType)type
{
	//Check RAM cache.
	if(type&kFZCacheRAM)
	{
		id item = [[self sharedDataCache] cachedItemForKey:key];
		if (item)
		{
			if ([item isKindOfClass:[NSData class]])
				return [NSKeyedUnarchiver unarchiveObjectWithData:item];
			else
				return item;
		}
	}
	//Check local cache.
	if(type&kFZCacheLocal)
	{
		NSString *path = [[self class] cachePathForKey:key];
		NSData *data = [[self class] itemFromCacheForPath:path];
		if(data && [data isKindOfClass:[NSData class]])
		{
			id unarchivedObject = nil;
			// Determine if this NSData is an image by reading its first byte
			uint8_t firstByte;
			[data getBytes:&firstByte length:1];
			// png, jpeg, gif, tiff, tiff
			if (firstByte == 0x89 || firstByte == 0xFF || firstByte == 0x47 || firstByte == 0x49 || firstByte == 0x4D)
			{
				unarchivedObject = [UIImage imageWithData:data];
			}
			else
			{
				@try { unarchivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data]; }
				@catch (NSException *exception) { NSLog(@"(FZCache) Warning: Could not unarchive data for key %@", key);}
			}
			
			//Locally cached images goes to RAM cache as recently used
			[[self sharedDataCache] cacheItem:unarchivedObject forKey:key];
			return unarchivedObject;
		}
	}
	return nil;
}

+ (void)cachedItemForKey:(NSString*)key inCache:(FZCacheType)type withCompletionBlock:(FZCacheFetchCompletionBlock)inCompletionBlock
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
				   ^{
					   id rtnObject = [self cachedItemForKey:key inCache:type];
					   if (inCompletionBlock)
					   {
						   dispatch_async(dispatch_get_main_queue(), ^{
							   inCompletionBlock(rtnObject);
						   });
					   }
				   });
}

+ (void)writeData:(NSData*)data toCachePath:(NSString*)path
{
	[data writeToFile:path atomically:YES];
}

+ (void)cacheItem:(id)item forKey:(NSString *)key
{
	[self cacheItem:item forKey:key inCache:kFZCacheAll withCompletionBlock:nil];
}
+ (void)cacheItem:(id)item forKey:(NSString *)key inCache:(FZCacheType)type
{
	[self cacheItem:item forKey:key inCache:type withCompletionBlock:nil];
}

+ (void)cacheItem:(id)item forKey:(NSString *)key inCache:(FZCacheType)type withCompletionBlock:(FZCacheCompletionBlock)inCompletionBlock
{
	if (!key.length)
		return;
	if(type&kFZCacheRAM)
		[[self sharedDataCache] cacheItem:item forKey:key];
	if(type&kFZCacheLocal && ([item isKindOfClass:[NSData class]] || [item respondsToSelector:@selector(encodeWithCoder:)]))
	{
		NSString *itemPath =  [self cachePathForKey:key];
		if (inCompletionBlock)
		{
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
			^{
				[self writeItem:item toPath:itemPath withCompletionBlock:inCompletionBlock];
			});
		}
		else
		{
			[self writeItem:item toPath:itemPath withCompletionBlock:nil];
		}
	}
	else if (type&kFZCacheLocal)
	{
		[[self sharedDataCache] cacheItem:item forKey:key];
		NSLog(@"FZCache Warning: objects that do not adopt the NSCoding may not be cached to disk. %@ has been cached to RAM.", item);
	}
}

+ (void)writeItem:(id)inItem toPath:(NSString *)inPath withCompletionBlock:(FZCacheCompletionBlock)inCompletionBlock
{
	if ([inItem isKindOfClass:[NSData class]])
		[self writeData:inItem toCachePath:inPath];
	else
	{
		NSData *data = nil;
		if ([inItem isKindOfClass:[UIImage class]])
		{
			data = UIImagePNGRepresentation(inItem);
		}
		else
		{
			data = [NSKeyedArchiver archivedDataWithRootObject:inItem];
		}
		if (data)
			[self writeData:data toCachePath:inPath];
		else
		{
			NSLog(@"FZCache Warning: error converting object %@ to data. This object has not been cached to disk.", inItem);
		}
	}
	if (localCacheSize > 0)
		[self removeFilesToPreserveMaxCacheSize:localCacheSize];
	
	[inCompletionBlock invoke];
}

+ (void)setLocalCacheBarrier:(CGFloat)size
{
	localCacheBarrier = (int)(size*1000000);
}

+ (BOOL)cacheBarrierIsViolated
{
	__autoreleasing NSError *error = nil;
	NSArray *tmpPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSDictionary *tmpDictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[tmpPaths lastObject] error: &error];
	
	if (tmpDictionary)
	{
		NSNumber *tmpFreeFileSystemSizeInBytes = [tmpDictionary objectForKey:NSFileSystemFreeSize];
		uint64_t tmpTotalFreeSpace = [tmpFreeFileSystemSizeInBytes unsignedLongLongValue];
		
		return (tmpTotalFreeSpace < localCacheBarrier);
	}
	
	return NO;
}

+ (void) setCacheSize:(CGFloat)size forCacheType:(FZCacheType)type
{
	if(type&kFZCacheRAM)
	{
		[[self sharedDataCache] setTotalCostLimit:(int)(size*1000)];
	}
	if(type&kFZCacheLocal)
	{
		localCacheSize = (int)(size*1000000);
	}
}

+ (NSString *) localCachePathForKey:(NSString*)key
{
	NSString *itemPath = [self cachePathForKey:key];
	if ([[NSFileManager defaultManager] fileExistsAtPath:itemPath])
		return itemPath;
	
	return nil;
}

+ (FZCacheType) cacheTypeForKey:(NSString*)key
{
	FZCacheType cacheMask = kFZCacheNone;
	
	NSData* data = [[[self class] sharedDataCache] cachedItemForKey:key];
	if(data)
		cacheMask |= kFZCacheRAM;
	
	NSString *itemPath = [self cachePathForKey:key];
	if ([[NSFileManager defaultManager] fileExistsAtPath:itemPath])
		cacheMask |= kFZCacheLocal;
	
	return cacheMask;
}

+ (void)removeFilesToPreserveMaxCacheSize:(CGFloat)megabytes
{
	NSArray *tmpImageArray = [self arrayOfCachedFilesSortedByNSURLFileKey:NSURLCreationDateKey];
	NSInteger tmpBytesInCache = 0;
	
	for (NSURL *tmpFileURL in tmpImageArray)
	{
		NSNumber *tmpFileSize = nil;
		__autoreleasing NSError* error = nil;
		[tmpFileURL getResourceValue:&tmpFileSize forKey:NSURLFileSizeKey error:&error];
		if (error)
			NSLog(@"FZCache error getting resource value: %@",error.description);
		tmpBytesInCache += [tmpFileSize longValue];
		
		error = nil;
		if (tmpBytesInCache >= megabytes)
			[[NSFileManager defaultManager] removeItemAtURL:tmpFileURL error:&error];
		if (error)
			NSLog(@"FZCache error getting resource value: %@",error.description);
	}
}

+ (NSArray *)arrayOfCachedFilesSortedByNSURLFileKey:(NSString *)inNSURLFileKey
{
	__autoreleasing NSError* error = nil;
	NSArray *rtnImageArray =  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[self cacheStoragePath]] includingPropertiesForKeys:@[NSFileCreationDate,NSFileSize] options:0 error:&error];
	if (error)
		NSLog(@"FZCache error getting contents of dirrectory %@: %@",[self cacheStoragePath],error.description);
	
	rtnImageArray = [rtnImageArray sortedArrayUsingComparator:
					 ^NSComparisonResult(id obj1, id obj2)
					 {
						 __autoreleasing NSError* error = nil;
						 
						 NSDate *tmpFileDate1 = nil;
						 [obj1 getResourceValue:&tmpFileDate1 forKey:inNSURLFileKey error:&error];
						 if (error)
							 NSLog(@"FZCache error getting resource value: %@",error.description);
						 
						 error = nil;
						 NSDate *tmpFileDate2 = nil;
						 [obj2 getResourceValue:&tmpFileDate2 forKey:inNSURLFileKey error:&error];
						 if (error)
							 NSLog(@"FZCache error getting resource value: %@",error.description);
						 
						 return [tmpFileDate2 compare:tmpFileDate1];
					 }];
	
	return rtnImageArray;
}

+ (NSString*) cacheStoragePath
{
	NSString *cacheDirectory = [self cachePathForKey:nil];
	return cacheDirectory;
}

+ (NSString*) cacheStorageUniqueFilePath
{
	NSString* folder = [self cacheStoragePath];
	NSString* uniqueFileName = [NSString stringWithFormat:@"%f-%d",CACurrentMediaTime(),rand()];
	return [folder stringByAppendingPathComponent:uniqueFileName];
}

+ (NSString*) createLocalCachePathForKey:(NSString *)key
{
	return [self cachePathForKey:key];
}

+ (void) cleanCache:(FZCacheType)type
{
	if(type&kFZCacheRAM)
	{
		[[self sharedDataCache] removeAllObjects];
	}
	if(type&kFZCacheLocal)
	{
		[self removeFilesToPreserveMaxCacheSize:0.0];
	}
}

+ (void) removeCachedItemForKey:(NSString *)key fromCache:(FZCacheType)type
{
	if(type&kFZCacheRAM)
	{
		[[self sharedDataCache] removeObjectForKey:key];
	}
	if(type&kFZCacheLocal)
	{
		NSString* path = [self cachePathForKey:key];
		__autoreleasing NSError* error = nil;
		[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
		if (error)
			NSLog(@"FZCache error removing file at path %@: %@",path,error.description);
	}
}

@end
