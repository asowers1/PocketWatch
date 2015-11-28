//
//  UIImageView+FZCache.m
//  Pods
//
//  Created by Anton Remizov on 5/14/14.
//
//

#import "FZCachedImageView.h"
#import "UIImage+FZCache.h"
#import "FZImageLoader.h"
@import AssetsLibrary;

@interface FZCachedImageView()
{
    FZImageLoader* _imgLoader;
}
@end

@implementation FZCachedImageView

- (void) setImagePath:(NSString*) imagePath
{
    _imagePath = imagePath;
    
    UIImage* image = [UIImage cachedImageFromPath:imagePath ofType:kFZCacheRAM|kFZCacheLocal];
    if (image) {
        self.image = image;
        return;
    }
    image = [UIImage imageWithContentsOfFile:imagePath];
    if (image) {
        [image cacheToPath:imagePath];
        self.image = image;
        return;
    }
    
    if ([imagePath rangeOfString:@"assets-library://"].location != NSNotFound) {
        ALAssetsLibrary *lib = [ALAssetsLibrary new];
        [lib assetForURL:[NSURL URLWithString:imagePath]
             resultBlock:^(ALAsset *asset) {
                 ALAssetRepresentation *repr = [asset defaultRepresentation];
                 CGImageRef cgImg = [repr fullResolutionImage];
                 UIImage *img = [UIImage imageWithCGImage:cgImg];
                 [img cacheToPath:imagePath];
                 self.image = img;
             }
            failureBlock:^(NSError *error) {
                self.image = self.placeholderImage;
            }];
    }
    else
    {
        _imgLoader = [[FZImageLoader alloc] init];
        [_imgLoader loadImageFromURL:imagePath
						   onSuccess:^(UIImage *img) {
							   self.image = img;
							   [img cacheToPath:imagePath];
						   } onFailure:^(NSError *error) {
							   self.image = self.placeholderImage;
						   }];
    }
}


@end
