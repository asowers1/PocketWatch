//
//  UIImageView+Fuzz.m
//  Pods
//
//  Created by Fuzz Productions on 12/9/14.
//
//

#import "UIImageView+Fuzz.h"
#import "NSURLSession+Fuzz.h"
#import "NSFileManager+Fuzz.h"
#import "NSString+Fuzz.h"
#import "NSError+Fuzz.h"
#import "UIView+Fuzz.h"
#import "NSObject+Fuzz.h"
#import "Fuzz.h"


@implementation UIImageView (Fuzz)

-(void)fadeInImage:(UIImage*)image
{
	[self fadeInImage:image withDuration:0.25];
}
- (void)fadeInImage:(UIImage*)image withDuration:(CGFloat)inDuration
{
	if(image)
	{
		WeakSelf me =self;
		mainQueue(^
				  {
					  UIImageView *newImage = [[UIImageView alloc] initWithFrame:me.bounds];
					  newImage.backgroundColor = [UIColor clearColor];
					  [me addSubview:newImage];
					  [me sendSubviewToBack:newImage];
					  newImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
					  newImage.alpha = 0;
					  newImage.image = image;
					  [UIView animateWithDuration:inDuration animations:^
					   {
						   newImage.alpha = 1;
					   } completion:^(BOOL finished)
					   {
						   me.image = image;
						   [newImage removeFromSuperview];
					   }];
				  });
	}
}
-(NSURLSessionDownloadTask*)setImageWithURLString:(NSString*)inURLString
{
	if(exists(inURLString))
	return [self setImageWithURLString:inURLString fadeInDuration:0.25 progress:nil failure:nil success:nil];
	
	return nil;
}
#define FZ_IMAGE_DOWNLOAD_TASK @"FZ_IMAGE_DOWNLOAD_TASK"
/*
	Considering the ALAssets library may help too
 */
-(NSURLSessionDownloadTask*)setImageWithURLString:(NSString*)inURLString
								   fadeInDuration:(CGFloat)duration
										 progress:(FZBlockWithFloat)inProgress
										  failure:(FZBlockWithError)inFailure
										  success:(FZBlock)inSuccess
{
	
	
	static NSCache *imageCache = nil;
	Once(^{ imageCache = [[NSCache alloc] init]; });
	__block NSString *path = [[NSFileManager cachesDirectoryPath] stringByAppendingPathComponent:[inURLString md5]];
	
	//cache cache in memory
	UIImage *image = [imageCache objectForKey:path];
	if(image)
	{
		[self fadeInImage:image withDuration:duration];
		[self removeAssociatedObjectForKey:FZ_IMAGE_DOWNLOAD_TASK];
		return nil;
	}
	
	//check cached files
	if([NSFileManager fileExistsAtPath:path])
	{
		UIImage *I = [UIImage imageWithContentsOfFile:path];
		[imageCache setObject:I forKey:path];
		[self fadeInImage:I withDuration:duration];
	}
	
	WeakSelf me = self;
	//request from the network
	__block NSURLSessionDownloadTask *task =
	[NSURLSession download:inURLString filePath:path progressBlock:^
	 {
		 if([me getAssociatedObjectForKey:FZ_IMAGE_DOWNLOAD_TASK] == task)
		 {
			 if(inProgress)
				 inProgress(0);
		 }
		 
	 } success:^(NSURLResponse *response, NSURL *location)
	 {
		 
		 UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
		 [imageCache setObject:image forKey:path];
		 [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
		 
		 if([me getAssociatedObjectForKey:FZ_IMAGE_DOWNLOAD_TASK] == task)
		 {
			 [me removeAssociatedObjectForKey:FZ_IMAGE_DOWNLOAD_TASK];
			 [me fadeInImage:image withDuration:duration];
			 
			 if(inSuccess)
				 inSuccess();
		 }
		 
	 } failure:^(NSURLResponse *response, NSError *error)
	 {
		 if([me getAssociatedObjectForKey:FZ_IMAGE_DOWNLOAD_TASK] == task)
			 [me removeAssociatedObjectForKey:FZ_IMAGE_DOWNLOAD_TASK];
		 
		 if(inFailure)
			 inFailure(error);
		 else
			 ELog(error);
	 }];
	[self setAssociatedObject:task forKey:FZ_IMAGE_DOWNLOAD_TASK];
	return task;
}
@end
