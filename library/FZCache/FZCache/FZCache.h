//
//  FZCache.h
//  FZCache
//
//  Created by Anton Remizov on 1/31/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FZCacheFetchCompletionBlock)(id inReturnObject);
typedef void (^FZCacheCompletionBlock)();

// May be used as a bit mask;
typedef enum FZImageCacheType {
    kFZCacheNone = 0b0,
    kFZCacheRAM = 0b1,
    kFZCacheLocal = 0b10,
	kFZCacheAll = 0b11,
	kFZCacheNotFound = 0b100
} FZCacheType;


@interface FZCache : NSObject
+ (id)cachedItemForKey:(NSString *)key;
/*!
 @function cachedDataForKey:ofType:
 @abstract Returns a cached image or nil.
 @param key
 key, using which the data was stored.
 @param type
 bitmask of cache types
 */
+ (id)cachedItemForKey:(NSString *)key inCache:(FZCacheType)type;
+ (void)cachedItemForKey:(NSString *)key inCache:(FZCacheType)type withCompletionBlock:(FZCacheFetchCompletionBlock)inCompletionBlock;

/*!
 @function cacheData:forKey:
 @abstract Add data to RAM and local storage cache.
 @param data
 The data to store.
 @param key
 using this key, the data will be stored.
 */
//+ (void) cacheData:(NSData*)data forKey:(NSString*)key;

/*!
 @function cacheData:forKey:
 @abstract Add data to RAM and local storage cache.
 @param data
 The data to store.
 @param key
 using this key, the data will be stored.
 @param type
 bitmask of cache types
 */
//+ (void) cacheData:(NSData*)data forKey:(NSString*)key inCache:(FZCacheType)type;


+ (void)cacheItem:(id)item forKey:(NSString *)key;
+ (void)cacheItem:(id)item forKey:(NSString *)key inCache:(FZCacheType)type;
+ (void)cacheItem:(id)item forKey:(NSString *)key inCache:(FZCacheType)type withCompletionBlock:(FZCacheCompletionBlock)inCompletionBlock;
/*!
 @function setCacheSize:forCacheType
 @abstract Sets ammount of cached images in Megabytes for passed cache type.
 @discussion Default size is 100 MB for Ram and 200 MB for local cache.
 @param size
 Megabyte limit for cache size. Specifying 0 or less removes the limit.
 @param type
 bitmask of cache types
 */
+ (void) setCacheSize:(CGFloat)size forCacheType:(FZCacheType)type;

/**
 * @description A method to limit the amount of remaining disk space an app will consume.
 * @param size The amount in megabytes of disk space that will be preserved.
 *
 */
+ (void)setLocalCacheBarrier:(CGFloat)size;

/**
 * @description This method returns determines whether the localCacheBarrier has been exceeded.
 * @return YES indicates that a device's free disk space is less than the local cache barrier. NO indicates that a device's free space is greater than the local cache barrier.
 *
 */
+ (BOOL)cacheBarrierIsViolated;

/*!
 @function localCachePathForKey:
 @abstract Use this method to get the path for data stored in local cache.
 @param key
 using this key, the data will be stored.
 @return return a valid path or nil, if the data is not in the local cache.
 */
+ (NSString *) localCachePathForKey:(NSString*)key;

/*!
 @function cacheTypeForKey:
 @abstract Return cache types bitmask for provided key. if ther is no data in the storage the return value is kFZImageCacheNone
 @param key
 key, wich was used toadd data to the cache storage.
 */
+ (FZCacheType) cacheTypeForKey:(NSString*)key;

/*!
 @function cacheStoragePath:
 @abstract Return path for local cache storage
 */
+ (NSString*) cacheStoragePath;

/*!
 @function cacheStorageUniqueFilePath
 @abstract Return a unique file path for local cache storage without extension
 */
+ (NSString*) cacheStorageUniqueFilePath;

/*!
 @function createLocalCachePathForKey:
 @param key
 using this key, the data will be stored.
 @return return a valid path, that may be used for saving data in local cache.
 */
+ (NSString*) createLocalCachePathForKey:(NSString *)key;

/*!
 @function cleanCache:
 @abstract removes all items for passed cache type
 @param type
 bitmask of cache types
 */
+ (void) cleanCache:(FZCacheType)type;

/*!
 @function removeCachedItemForKey:fromCache:
 @abstract removes item from passed che types, if presented.
 @param key
 using this key, the data will be stored.
 @param type
 bitmask of cache types
 */
+ (void) removeCachedItemForKey:(NSString *)key fromCache:(FZCacheType)type;

@end
