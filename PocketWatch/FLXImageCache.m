//
//  FLXImageCache.m
//  Flux
//
//  Created by Sheng Dong on 4/20/15.
//  Copyright (c) 2015 Fuzz Productions. All rights reserved.
//

#import "FLXImageCache.h"
#import <FZCache/FZCache.h>
#import <FZCache/FZImageLoader.h>

@implementation FLXImageCache

+ (void)imageForUrlPath:(NSString *)urlPath onSuccess:(void (^)(UIImage *))success onFailure:(void (^)(NSError *))failure {
    UIImage *image = [FZCache cachedItemForKey:urlPath];
    if (image) {
        success(image);
    } else {
        // Fire a image loader to fetch the image
        FZImageLoader *loader = [[FZImageLoader alloc] init];
        [loader loadImageFromURL:urlPath onSuccess:^(UIImage *img) {
            [FZCache cacheItem:img forKey:urlPath];
            if (success) {
                success(img);
            }
        } onFailure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

@end


@implementation UIImageView (FLXImageCache)

- (void)setImageWithUrlPath:(NSString *)urlPath {
    [FLXImageCache imageForUrlPath:urlPath onSuccess:^(UIImage *img) {
        [self setImage:img];
    } onFailure:nil];
}

@end
