//
//  UIImageView+FZCache.h
//  Pods
//
//  Created by Anton Remizov on 5/14/14.
//
//

#import <UIKit/UIKit.h>

@interface FZCachedImageView : UIImageView

/*!
 @property setImagePath:
 @discussion sets image from a path, tries a cached image, than tries to use the string as local path, than tries to load it as a remote URL.
 path, where the image was stored should be passed. Will be used as a key, should be a valid path or url.
 */
@property (nonatomic, strong) NSString* imagePath;
@property (nonatomic, strong) UIImage *placeholderImage;
@end
