//
//  UICollectionView+Fuzz.h
//  Demo
//
//  Created by Sean Orelli on 12/22/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSInteger (^FZNumberOfItemsBlock)(NSInteger section);
typedef NSInteger (^FZNumberOfSectionBlock)(void);
typedef UIEdgeInsets (^FZEdgeInsetsForSection)(NSInteger section);
typedef CGSize (^FZSizeForItemBlock)(NSIndexPath *indexPath);
typedef UICollectionReusableView* (^FZSupplementaryViewBlock)(NSString *kind, NSIndexPath *indexPath);
typedef UICollectionViewCell *(^FZCollectionCellAtIndexPath)(NSIndexPath *indexPath);
typedef void (^FZDidSelectCollectionCellBlock)(NSIndexPath *indexPath);


/*
	UI Collection View
*/

@interface UICollectionView (Fuzz)
-(void)numberOfItemsBlock:(FZNumberOfItemsBlock)inBlock;
-(void)numberOfSectionsBlock:(FZNumberOfSectionBlock)inBlock;
-(void)edgeInsetsForSectionBlock:(FZEdgeInsetsForSection)inBlock;
-(void)sizeForItemBlock:(FZSizeForItemBlock)inBlock;
-(void)supplementaryViewBlock:(FZSupplementaryViewBlock)inBlock;
-(void)cellForItemBlock:(FZCollectionCellAtIndexPath)inBlock;
-(void)didSelectCellBlock:(FZDidSelectCollectionCellBlock)inBlock;
@end
