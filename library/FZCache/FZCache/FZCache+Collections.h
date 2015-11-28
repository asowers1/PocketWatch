//
//  FZImageCache+Collections.h
//  ZagatTopCities
//
//  Created by Anton Remizov on 11/11/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "UIImage+FZCache.h"

@protocol FZLazyImageLoading <NSObject>
- (void) setImage:(UIImage *)image fromCacheType:(FZCacheType)inType;
@end

/*!
 @class FZCache (Collections)
 
 @abstract A handler for image requests made on behalf table and collectionView cells.
 @discussion FZCache+Collections manages image fetching, image loading, and image caching. When fetching an image, the imageLoader checks memory, then disk, and failing to find an image at either, places a request. If a request is made on behalf of a cell that is subsequently scrolled off the screen, the retrieved image is cached, but not set.
 WARNING: At the moment, FZCache+Collections does not take cell insertion, deletion, or movement into account.
 */
@interface FZCache (Collections)

/*! Places an image request on behalf of a collectionViewCell.
 * @param imagePath The URLstring of the image.
 * @param collectionView The collectionView containing the cell requesting the image.
 * @param cell The cell requesting the image.
 * @param indexPath The indexPath of the cell.
 */
+ (void) setImageAtPath:(NSString *)imagePath
       toCollectionView:(UICollectionView *)collectionView
                   cell:(UICollectionViewCell<FZLazyImageLoading>*)cell
            atIndexPath:(NSIndexPath *)indexPath;

/*! Places an image request on behalf of a tableViewCell.
 * @param imagePath The URLstring of the image.
 * @param tableView The tableView containing the cell requesting the image.
 * @param cell The cell requesting the image.
 * @param indexPath The indexPath of the cell.
 */
+ (void) setImageAtPath:(NSString *)imagePath
            toTableView:(UITableView *)tableView
                   cell:(UITableViewCell<FZLazyImageLoading>*)cell
            atIndexPath:(NSIndexPath*)indexPath;


/*! Places an image request on behalf of a view within a table or collectionViewCell.
 * @param imagePath The URLstring of the image.
 * @param inCollection The table or collecitonView containing the view requesting the image.
 * @param cell The cell containing the view requesting the image.
 * @param indexPath The indexPath of the cell.
 * @param view The view requesting the image.
 */
+ (void) setImageAtPath:(NSString*)imagePath
           toCollection:(id) collectionView
                   cell:(id)cell
            atIndexPath:(NSIndexPath*)indexPath
			   withView:(id<FZLazyImageLoading>)view;

+ (void)cancelImageSetting;

@end
