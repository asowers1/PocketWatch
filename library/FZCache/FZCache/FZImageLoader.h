//
//  ImageLoader.h
//  FZModuleLibrary
//
//  Created by Anton Remizov on 10/2/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZImageLoader : NSObject

@property (retain) NSString* imgPath;

/*!
 @function setCocurrentCount:
 @abstract Sets the ammount of concurrent FZImageLoader.
 @param count
 the count of operations
 */
+ (void) setCocurrentCount:(NSInteger)count;

/*!
 @function loadImageFromURL:onSuccess:onFailure:
 @abstract Asynchronous image loader with a success and a failure block parameters .
 @param path
 path, where the image was stored. Used as a key, should be a valid path.
 @param type
 bitmask of cache types
 */
- (void) loadImageFromURL:(NSString*)path
                onSuccess:(void(^)(UIImage* img))success
                onFailure:(void(^)(NSError* error))failure;

@property (nonatomic, assign) BOOL canceled;

@end
