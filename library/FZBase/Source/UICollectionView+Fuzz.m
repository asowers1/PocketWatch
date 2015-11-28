//
//  UICollectionView+Fuzz.m
//  Demo
//
//  Created by Sean Orelli on 12/22/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import "UICollectionView+Fuzz.h"
#import "NSObject+Fuzz.h"

@interface FZAssociatedCollectionViewDelegate : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

@property (copy)FZNumberOfItemsBlock numberOfItemsBlock;
@property (copy)FZNumberOfSectionBlock numberOfSectionsBlock;
@property (copy)FZEdgeInsetsForSection edgeInsetsBlock;
@property (copy)FZSizeForItemBlock sizeForItemBlock;
@property (copy)FZSupplementaryViewBlock supplementaryViewBlock;
@property (copy)FZCollectionCellAtIndexPath cellBlock;
@property (copy)FZDidSelectCollectionCellBlock didSelectBlock;

@end

@implementation FZAssociatedCollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if(self.didSelectBlock) self.didSelectBlock(indexPath);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	if(self.numberOfItemsBlock) self.numberOfItemsBlock(section);
	return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	if(self.numberOfSectionsBlock) self.numberOfSectionsBlock();
	return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if(self.cellBlock) return self.cellBlock(indexPath);
	return [UICollectionViewCell new];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	if(self.supplementaryViewBlock) return self.supplementaryViewBlock(kind, indexPath);
	return [[UICollectionReusableView alloc] init];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if(self.sizeForItemBlock) return self.sizeForItemBlock(indexPath);
	return CGSizeZero;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	if(self.edgeInsetsBlock) return self.edgeInsetsBlock(section);
	return UIEdgeInsetsZero;
}

@end

@implementation UICollectionView (Fuzz)

- (FZAssociatedCollectionViewDelegate*)associatedCollectionViewDelegate
{
	NSString *key = NSStringFromClass([FZAssociatedCollectionViewDelegate class]);
	FZAssociatedCollectionViewDelegate *D= [self getAssociatedObjectForKey:key];
	if(D == nil)
	{
		D = [[FZAssociatedCollectionViewDelegate alloc] init];
		[self setAssociatedObject:D forKey:key];
		self.delegate = D;
		self.dataSource = D;

	}
	return D;
}
-(void)numberOfItemsBlock:(FZNumberOfItemsBlock)inBlock{[self associatedCollectionViewDelegate].numberOfItemsBlock = inBlock;}
-(void)numberOfSectionsBlock:(FZNumberOfSectionBlock)inBlock{[self associatedCollectionViewDelegate].numberOfSectionsBlock = inBlock;}
-(void)edgeInsetsForSectionBlock:(FZEdgeInsetsForSection)inBlock{[self associatedCollectionViewDelegate].edgeInsetsBlock = inBlock;}
-(void)sizeForItemBlock:(FZSizeForItemBlock)inBlock{[self associatedCollectionViewDelegate].sizeForItemBlock = inBlock;}
-(void)supplementaryViewBlock:(FZSupplementaryViewBlock)inBlock{[self associatedCollectionViewDelegate].supplementaryViewBlock = inBlock;}
-(void)cellForItemBlock:(FZCollectionCellAtIndexPath)inBlock{[self associatedCollectionViewDelegate].cellBlock = inBlock;}
-(void)didSelectCellBlock:(FZDidSelectCollectionCellBlock)inBlock{[self associatedCollectionViewDelegate].didSelectBlock = inBlock;}

@end
