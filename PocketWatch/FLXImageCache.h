//
//  FLXImageCache.h
//  Flux
//
//  Created by Sheng Dong on 4/20/15.
//  Copyright (c) 2015 Fuzz Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  FLXImageCache is reponsible for fetching as well as caching images. It will asynchronizly fetch image if image requested is not found.
 */
@interface FLXImageCache : NSObject

/**
 *  Fetch from cache, image it doens't exist, it will fetch the network
 */
+ (void)imageForUrlPath:(NSString *)urlPath onSuccess:(void(^)(UIImage* img))success onFailure:(void(^)(NSError* error))failure;

@end


@interface UIImageView (FLXImageCache)

- (void)setImageWithUrlPath:(NSString *)urlPath;

@end