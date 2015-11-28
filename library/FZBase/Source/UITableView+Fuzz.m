//
//  UITableView+Fuzz.m
//  
//
//  Created by Fuzz Productions on 12/21/14.
//
//
#import "UITableView+Fuzz.h"
#import "NSObject+Fuzz.h"
#import "UIView+Fuzz.h"

@interface FZAssociatedTableViewDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

- (NSInteger)numberOfSectionsInTableView:(UITableView*)inTableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@property (copy)FZNumberOfRowsBlock numberOfRowsBlock;
@property (copy)FZNumberOfSectionsBlock numberOfSectionsBlock;
@property (copy)FZTableViewCellBlock cellForRowBlock;
@property (copy)FZTableViewDidSelectBlock didSelectCellBlock;
@property (copy)FZTableViewSectionViewBlock headerViewBlock;
@property (copy)FZTableViewSectionViewBlock footerViewBlock;
@property (copy)FZTableViewRowHeightBlock rowHeightBlock;

@end

@implementation FZAssociatedTableViewDelegate
#define defaultRowHeight 44
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.numberOfRowsBlock ? self.numberOfRowsBlock(section) : 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)inTableView
{
	return self.numberOfSectionsBlock ? self.numberOfSectionsBlock() : 1;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.cellForRowBlock ? self.cellForRowBlock(indexPath) : [[UITableViewCell alloc] init];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(self.didSelectCellBlock) self.didSelectCellBlock(indexPath);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return self.headerViewBlock ? self.headerViewBlock(section).height : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return self.footerViewBlock ? self.footerViewBlock(section).height : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.rowHeightBlock ? self.rowHeightBlock(indexPath) : defaultRowHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return self.headerViewBlock ? self.headerViewBlock(section) : [[UIView alloc] initWithFrame:CGRectZero];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return self.footerViewBlock ? self.headerViewBlock(section) : [[UIView alloc] initWithFrame:CGRectZero];
}
@end

@implementation UITableView (Fuzz)

- (FZAssociatedTableViewDelegate*)associatedTableViewDelegate
{
	NSString *key = NSStringFromClass([FZAssociatedTableViewDelegate class]);
	FZAssociatedTableViewDelegate *D= [self getAssociatedObjectForKey:key];
	if(D == nil)
	{
		D = [[FZAssociatedTableViewDelegate alloc] init];
		[self setAssociatedObject:D forKey:key];
	}
	self.delegate = D;
	self.dataSource = D;

	return D;
}
-(void)numberOfRowsBlock:(FZNumberOfRowsBlock)inBlock{[self associatedTableViewDelegate].numberOfRowsBlock=inBlock;}
-(void)numberOfSectionsBlock:(FZNumberOfSectionsBlock)inBlock{[self associatedTableViewDelegate].numberOfSectionsBlock=inBlock;}
-(void)cellForRowBlock:(FZTableViewCellBlock)inBlock{[self associatedTableViewDelegate].cellForRowBlock=inBlock;}
-(void)didSelectRowBlock:(FZTableViewDidSelectBlock)inBlock{[self associatedTableViewDelegate].didSelectCellBlock=inBlock;}
-(void)viewForHeaderInSectionBlock:(FZTableViewSectionViewBlock)inBlock{[self associatedTableViewDelegate].headerViewBlock=inBlock;}
-(void)viewForFooterInSectionBlock:(FZTableViewSectionViewBlock)inBlock{[self associatedTableViewDelegate].footerViewBlock=inBlock;}
-(void)heightForRowBlock:(FZTableViewRowHeightBlock)inBlock{[self associatedTableViewDelegate].rowHeightBlock=inBlock;}

@end
