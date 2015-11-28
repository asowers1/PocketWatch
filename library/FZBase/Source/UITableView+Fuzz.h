//
//  UITableView+Fuzz.h
//  
//
//  Created by Fuzz Productions on 12/21/14.
//
//

#import <UIKit/UIKit.h>


typedef NSInteger (^FZNumberOfRowsBlock)(NSInteger section);
typedef NSInteger (^FZNumberOfSectionsBlock)(void);
typedef CGFloat (^FZTableViewRowHeightBlock)(NSIndexPath *indexPath);
typedef UITableViewCell* (^FZTableViewCellBlock)(NSIndexPath *indexPath);
typedef void (^FZTableViewDidSelectBlock)(NSIndexPath *indexPath);
typedef UIView* (^FZTableViewSectionViewBlock)(NSInteger section);


@interface UITableView (Fuzz)

- (void)numberOfRowsBlock:(FZNumberOfRowsBlock)inBlock;
- (void)numberOfSectionsBlock:(FZNumberOfSectionsBlock)inBlock;
- (void)heightForRowBlock:(FZTableViewRowHeightBlock)inBlock;
- (void)cellForRowBlock:(FZTableViewCellBlock)inBlock;
- (void)didSelectRowBlock:(FZTableViewDidSelectBlock)inBlock;
- (void)viewForHeaderInSectionBlock:(FZTableViewSectionViewBlock)inBlock;
- (void)viewForFooterInSectionBlock:(FZTableViewSectionViewBlock)inBlock;

@end
