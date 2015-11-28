//
//  UIImage+FZCacher.m
//  FZCache
//
//  Created by Anton Remizov on 2/3/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "UIImage+FZCache.h"

#import "UIImage+Fuzz.h"

@implementation UIImage (FZCacher)

+ (UIImage *)cachedImageFromPath:(NSString*)path ofType:(FZCacheType)type
{
    id cachedImage = [FZCache cachedItemForKey:path inCache:type];
	
	if ([cachedImage isKindOfClass:[UIImage class]])
		return cachedImage;
	
    UIImage* tmpImage = [[UIImage alloc] initWithData:cachedImage];
	
    return tmpImage;
}

- (void)cacheToPath:(NSString *)path
{
	[self cacheToPath:path cacheType:kFZCacheAll];
}

- (void)cacheToPath:(NSString *)path cacheType:(FZCacheType)cacheType
{
	if (cacheType & kFZCacheRAM)
	{
		[FZCache cacheItem:self forKey:path inCache:kFZCacheRAM];
	}
	if (cacheType & kFZCacheLocal)
	{
		 [FZCache cacheItem:UIImagePNGRepresentation(self) forKey:path inCache:kFZCacheLocal];
	}
}

- (void)cacheToPath:(NSString *)path cacheType:(FZCacheType)cacheType sizeToAspectFit:(CGSize)size
{
	[self cacheToPath:path cacheType:cacheType sizeToAspectFit:size completionBlock:nil];
}

- (void)cacheToPath:(NSString *)path cacheType:(FZCacheType)cacheType sizeToAspectFit:(CGSize)size completionBlock:(void (^)())completionBlock
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
	^{
		float tmpScale = MIN(size.width / self.size.width, size.height / self.size.height);
		UIImage *tmpImage = [self resizedImage:CGSizeMake(self.size.width * tmpScale, self.size.height * tmpScale)];
		[tmpImage cacheToPath:path cacheType:cacheType];
		[completionBlock invoke];
	});
}

+ (FZCacheType) cacheTypeForPath:(NSString*)path
{
    return [FZCache cacheTypeForKey:path];
}

@end
