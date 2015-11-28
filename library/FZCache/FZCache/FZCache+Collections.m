//
//  FZImageCache+Collections.m
//  ZagatTopCities
//
//  Created by Anton Remizov on 11/11/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "FZCache+Collections.h"
#import "FZImageLoader.h"

#define VisibleCells(collection) [collection isKindOfClass:[UITableView class]]?((UITableView*)collection).visibleCells:((UICollectionView*)collection).visibleCells
#define CellForIndexPath(indexPath) (id<FZLazyImageLoading>)([collection isKindOfClass:[UITableView class]]?[(UITableView*)collection cellForRowAtIndexPath:indexPath]:[(UICollectionView*)collection cellForItemAtIndexPath:indexPath])

static NSMutableDictionary* _loaders = nil;

@implementation FZCache (Collections)

+ (NSMutableDictionary*) loaders
{
    if(!_loaders) _loaders = [NSMutableDictionary dictionary];
    return _loaders;
}

+ (void) setImageAtPath:(NSString*)imagePath
       toCollectionView:(UICollectionView*) collectionView
                   cell:(UICollectionViewCell<FZLazyImageLoading>*)cell
            atIndexPath:(NSIndexPath*)indexPath
{
    [self setImageAtPath:imagePath
            toCollection:collectionView
                    cell:cell
             atIndexPath:indexPath];
}

+ (void) setImageAtPath:(NSString*)imagePath
			toTableView:(UITableView*) tableView
                   cell:(UITableViewCell<FZLazyImageLoading>*)cell
            atIndexPath:(NSIndexPath*)indexPath
{
    [self setImageAtPath:imagePath
            toCollection:tableView
                    cell:cell
             atIndexPath:indexPath];
}


+ (void) setImageAtPath:(NSString*)imagePath
           toCollection:(id) collectionView
                   cell:(id<FZLazyImageLoading>)cell
            atIndexPath:(NSIndexPath*)indexPath
{
	[self setImageAtPath:imagePath toCollection:collectionView cell:cell atIndexPath:indexPath withView:nil];
}

+ (void) setImageAtPath:(NSString*)imagePath
           toCollection:(id) collectionView
                   cell:(id)cell
            atIndexPath:(NSIndexPath*)indexPath
			   withView:(id<FZLazyImageLoading>)view
{
	__weak id collection = collectionView;
	
	FZCacheType type = [UIImage cacheTypeForPath:imagePath];;
    
	if (imagePath)
	{
		if (type & kFZCacheRAM)
		{
			UIImage* image = [UIImage cachedImageFromPath:imagePath ofType:kFZCacheRAM];
			if (image)
			{
				[self setImage:image fromCacheType:kFZCacheRAM forCell:cell orView:view];
			}
		}
		else if(type & kFZCacheLocal)
		{
			/*
			 * The block saves the current value of indexPath. On the invocation
			 * the indexPath is the same as on the time of block creation
			 */
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
				UIImage* image = [UIImage cachedImageFromPath:imagePath ofType:kFZCacheLocal];
				dispatch_async(dispatch_get_main_queue(), ^{
					
					id<FZLazyImageLoading> blockCell = CellForIndexPath(indexPath);
					if (blockCell && [VisibleCells(collection) containsObject:blockCell])
					{
						if (image)
							[self setImage:image fromCacheType:kFZCacheLocal forCell:cell orView:view];
					}
				});
			});
		}
		else
		{
			FZImageLoader* imgLoader = [[FZImageLoader alloc] init];
			[[self loaders] setObject:imgLoader forKey:[indexPath description]];
			
			/*
			 * The block saves the current value of indexPath. On the invocation
			 * the indexPath is the same as on the time of block creation
			 */
			[imgLoader loadImageFromURL:imagePath
							  onSuccess:
			^(UIImage *image)
			{
				id<FZLazyImageLoading> blockCell = CellForIndexPath(indexPath);
				[image cacheToPath:imagePath];
				FZImageLoader *tmpImageLoader = [[self loaders] objectForKey:[indexPath description]];
				if (!tmpImageLoader.canceled && blockCell && [VisibleCells(collection) containsObject:blockCell])
					[self setImage:image fromCacheType:kFZCacheNone forCell:cell orView:view];
				[self.loaders removeObjectForKey:[indexPath description]];
			}
							  onFailure:
			^(NSError* error)
			{
				NSLog(@"Error loading image at path: %@",imagePath);
				NSLog(@"Error: %@",[error description]);
			}];
		}
	}
	else
	{
		[self setImage:nil fromCacheType:kFZCacheNotFound forCell:cell orView:view];
	}
}

+ (void)setImage:(UIImage *)image fromCacheType:(FZCacheType)inCacheType forCell:(id)cell orView:(id)view
{
	if ([view respondsToSelector:@selector(setImage:fromCacheType:)])
		[view setImage:image fromCacheType:inCacheType];
	else if ([cell respondsToSelector:@selector(setImage:fromCacheType:)])
		[cell setImage:image fromCacheType:inCacheType];
}

+ (void)cancelImageSetting
{
	for (FZImageLoader *tmpLoader in self.loaders.allValues)
	{
		tmpLoader.canceled = YES;
	}
}
@end
