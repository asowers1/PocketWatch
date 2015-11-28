//
//  UIImageView+Fuzz.h
//  Pods
//
//  Created by Fuzz Productions on 12/9/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.

#import <UIKit/UIKit.h>
#import "Fuzz.h"

@interface UIImageView (Fuzz)

- (void)fadeInImage:(UIImage*)image;

- (void)fadeInImage:(UIImage*)image withDuration:(CGFloat)duration;

- (NSURLSessionDownloadTask*)setImageWithURLString:(NSString*)inURLString;

- (NSURLSessionDownloadTask*)setImageWithURLString:(NSString*)inURLString
								   fadeInDuration:(CGFloat)duration
										 progress:(FZBlockWithFloat)inProgress
										  failure:(FZBlockWithError)inFailure
										  success:(FZBlock)inSuccess;
@end
