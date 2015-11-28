//
//  NSFileManager+Fuzz.m
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//

#import "Fuzz.h"
#import "NSError+Fuzz.h"
#import "NSFileManager+Fuzz.h"


/*
 Thess could be stored in FZCacheHandler
 for better low memory handling
 */
static NSString *documentsDirectory = nil;
static NSString *cachesDirectory = nil;
static NSString *libraryDirectory = nil;
static NSString *bundleDirectory = nil;
static NSString *applicationSupportDirectory = nil;
static NSString *tmpDirectoryPath = nil;

//NSLibraryDirectory

@implementation NSFileManager (Fuzz)

+(NSString*)systemPathWithIdentifier:(NSInteger)inIdentifier
{
    return [NSSearchPathForDirectoriesInDomains(inIdentifier, NSUserDomainMask, YES) objectAtIndex:0];
}
+ (NSString *)documentDirectoryPath
{
    if(documentsDirectory == nil)
        documentsDirectory = [self systemPathWithIdentifier:NSDocumentDirectory];
    
    return documentsDirectory;
}
+ (NSString *)documentsDirectoryPath
{
	if(documentsDirectory == nil)
		documentsDirectory = [self systemPathWithIdentifier:NSDocumentDirectory];
	
	return documentsDirectory;
}

+ (NSString *)documentsDirectoryPathToFile:(NSString*)fileName
{
	return [[self documentsDirectoryPath] stringByAppendingPathComponent:fileName];
}
+ (NSString *)mailDirectoryPath
{
    return [[self documentDirectoryPath] stringByAppendingPathComponent:@"Inbox"];
}
+ (NSString *)mailDirectoryPathToFile:(NSString *)fileName
{
	return [[self mailDirectoryPath] stringByAppendingPathComponent:fileName];
}
+ (NSString *)libraryDirectoryPath
{
    if(libraryDirectory == nil)
        libraryDirectory = [self systemPathWithIdentifier:NSLibraryDirectory];
    
    return libraryDirectory;
}

+ (NSString *)libraryDirectoryPathToFile:(NSString *)fileName
{
	return [[self libraryDirectoryPath] stringByAppendingPathComponent:fileName];
}


+ (NSString *)cachesDirectoryPath
{
    if(cachesDirectory == nil)
        cachesDirectory = [self systemPathWithIdentifier:NSCachesDirectory];
    
    return cachesDirectory;
}

+ (NSString *)cachesDirectoryPathToFile:(NSString *)fileName
{
	return [[self cachesDirectoryPath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)applicationSupportDirectoryPath
{
    if(applicationSupportDirectory == nil)
        applicationSupportDirectory = [self systemPathWithIdentifier:NSApplicationSupportDirectory];
        
   return applicationSupportDirectory;
}

+(NSString *)applicationSupportDirectoryPathToFile:(NSString *)fileName
{
	return [[self applicationSupportDirectoryPath] stringByAppendingPathComponent:fileName];
}



+(NSString *)tmpDirectoryPath
{
    if(tmpDirectoryPath == nil)
        tmpDirectoryPath = NSTemporaryDirectory();
    
    return tmpDirectoryPath;
}

+(NSString *)tmpDirectoryPathToFile:(NSString *)fileName
{
	return [[self tmpDirectoryPath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)bundleDirectoryPath
{
    if(bundleDirectory == nil)
        bundleDirectory = [[NSBundle mainBundle] bundlePath];
    
    return bundleDirectory;
}

+ (NSString *)bundleDirectoryPathToFile:(NSString *)fileName
{
	return [[self bundleDirectoryPath] stringByAppendingPathComponent:fileName];
}


+(void)logContentsOfDirectoryAtPath:(NSString*)inPath
{
    
    NSError *error = nil;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:inPath error:&error];
    
    if(error)
		ELog(error);
    else
    {
        DLog(@"%@", inPath);
        for(NSString *item in contents)
        {
            BOOL isDirectory = NO;
            NSString *path = [inPath stringByAppendingPathComponent:item];
            if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory])
            {
                if(isDirectory)
                    DLog(@"Directory:   %@", item);
                else
                    DLog(@"File:        %@", item);
            }
        }
    }
    
}

+ (NSArray*)contentsOfDirectoryAtPath:(NSString*)inPath
{
	NSError *error = nil;
	NSArray *tmp = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:inPath error:&error];
	
	
	if(error)
	{
		ELog(error);
		return nil;
	}
	
	return tmp;
}


+ (void)addSkipBackupAttributeToItemAtPath:(NSString*)inPath
{
    NSURL *URL = [NSURL fileURLWithPath:inPath];
    if([[NSFileManager defaultManager] fileExistsAtPath:inPath])
	{
        NSError *error = nil;
        if(![URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error])
			ELog(error);
	}
    else
        DLog(@"file does not exist at path: %@",[URL path]);
}

+ (void)addSkipBackupAttributeToItemAtURL:(NSURL *)inURL
{
	NSError *error = nil;
	if(![inURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error])
	{
		ELog(error);
	}
}

+ (BOOL)fileExistsAtPath:(NSString*)inPath
{
	BOOL isDirectory = NO;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:inPath isDirectory:&isDirectory];
	
	//	if(exists)
	//	return !isDirectory;
	
	return exists;
	
	//return [[NSFileManager defaultManager] fileExistsAtPath:inPath];
}


+ (BOOL)directoryExistsAtPath:(NSString*)inPath
{
	BOOL isDirectory = NO;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:inPath isDirectory:&isDirectory];
	
	if(exists)
		return isDirectory;
	
	return NO;
}


+(BOOL)createDirectoryAtPath:(NSString*)inPath
{
	/*
	 Here we should first check if it exists, otherwise create it
	 */
	NSError *error = nil;
	BOOL tmp = [[NSFileManager defaultManager] createDirectoryAtPath:inPath withIntermediateDirectories:YES attributes:nil error:&error];	
	ELog(error);	
	return tmp;
}


+(BOOL)removeItemAtPath:(NSString*)inPath
{
	NSError *error = nil;
	BOOL tmp = [[NSFileManager defaultManager] removeItemAtPath:inPath error:&error];
	ELog(error);
	return tmp;
}

+(BOOL)moveItemAtPath:(NSString*)inPath toPath:(NSString *)inDestination
{
	NSError *error = nil;
	BOOL tmp = [[NSFileManager defaultManager] moveItemAtPath:inPath toPath:inDestination error:&error];
	ELog(error);
	return tmp;
}


+(BOOL)copyItemAtPath:(NSString*)inPath toPath:(NSString *)inDestination
{
	NSError *error = nil;
	BOOL tmp = [[NSFileManager defaultManager] copyItemAtPath:inPath toPath:inDestination error:&error];
	ELog(error);
	return tmp;
}



@end
