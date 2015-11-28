//
//  UIImage+FZCacher.h
//  FZCache
//
//  Created by Anton Remizov on 2/3/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZCache.h"

@interface UIImage (FZCacher)

/*!
 @function cachedImageFromPath:ofType:
 @abstract Returns a cached image or nil.
 @param path
 path, where the image was stored. Used as a key, should be a valid path.
 @param type
 bitmask of cache types
 */
+ (UIImage*) cachedImageFromPath:(NSString*)path ofType:(FZCacheType)type;

/*!
 @function cacheToPath:
 @abstract Add image to Ram and storage cache.
 @param image
 The image to add.
 @param path
 path, where the image was stored. Used as a key, should be a valid path.
 */
- (void)cacheToPath:(NSString *)path;

/*!
 @function cacheToPath:cacheType:
 @abstract Add to a cache of your choice.
 @param path
 path, where the image was stored. Used as a key, should be a valid path.
 @param cacheType
 The cache you'd like the image stored in.
 */
- (void)cacheToPath:(NSString *)path cacheType:(FZCacheType)cacheType;

/*!
 @function cacheToPath:cacheType:withMaximumSize
 @abstract Add to a cache of your choice.
 @param path
 path, where the image was stored. Used as a key, should be a valid path.
 @param cacheType
 The cache you'd like the image stored in.
 @param size
 The size to scale to, maintaining aspect fit.
 */
- (void)cacheToPath:(NSString *)path cacheType:(FZCacheType)cacheType sizeToAspectFit:(CGSize)size;

/*!
 @function cacheToPath:cacheType:withMaximumSize:completionBlock
 @abstract Add to a cache of your choice.
 @param path
 path, where the image was stored. Used as a key, should be a valid path.
 @param cacheType
 The cache you'd like the image stored in.
 @param size
 The size to scale to, maintaining aspect fit.
 @param completionBlock
 A block invoked when caching completes.
 */
- (void)cacheToPath:(NSString *)path cacheType:(FZCacheType)cacheType sizeToAspectFit:(CGSize)size completionBlock:(void (^)())completionBlock;

/*!
 @function cacheTypeForPath:
 @abstract Return cache types bitmask for provided image path. if ther is no image in the storage the return value is kFZImageCacheNone
 @param path
 path, wich was used to add image to the cache storage.
 */
+ (FZCacheType) cacheTypeForPath:(NSString*)path;

@end
