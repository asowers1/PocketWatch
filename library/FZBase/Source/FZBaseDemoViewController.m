//
//  FZBaseDemoViewController.m
//  FZModuleLibrary
//
//  Created by Christopher Luu on 3/20/12.
//  Copyright (c) 2012 Fuzz Productions. All rights reserved.
//

#import "FZBaseDemoViewController.h"
#import "UIView+Fuzz.h"

NSString *const FZBaseDemoViewControllerDictionaryKeyName = @"FZBaseDemoViewControllerDictionaryKeyName";
NSString *const FZBaseDemoViewControllerDictionaryKeyDescription = @"FZBaseDemoViewControllerDictionaryKeyDescription";
NSString *const FZBaseDemoViewControllerDictionaryKeyExecutionBlock = @"FZBaseDemoViewControllerDictionaryKeyExecutionBlock";
NSString *const FZBaseDemoViewControllerDictionaryKeyView = @"FZBaseDemoViewControllerDictionaryKeyView";

static float const FZBaseDemoViewControllerCellMargin = 5;

@implementation FZBaseDemoViewController

- (id)init
{
	if (self = [super init])
	{
		[self setupDemo];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[self setupDemo];
	}
	return self;
}

- (void)setupDemo
{
	_testRowArray = [[NSMutableArray alloc] init];
	self.hidesBottomBarWhenPushed = YES;
}

- (void)addTestRowWithName:(NSString *)inName description:(NSString *)inDescription executionBlock:(FZBaseDemoViewControllerTestExecutionBlockType)inExecutionBlock
{
	FZBaseDemoViewControllerTestExecutionBlockType tmpBlock = [inExecutionBlock copy];

	[_testRowArray addObject:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  inName, FZBaseDemoViewControllerDictionaryKeyName,
	  inDescription, FZBaseDemoViewControllerDictionaryKeyDescription,
	  tmpBlock, FZBaseDemoViewControllerDictionaryKeyExecutionBlock,
	  nil]];

	//[tmpBlock release];
}

- (void)addTestRowWithName:(NSString *)inName description:(NSString *)inDescription view:(UIView *)inView
{
	FZBaseDemoViewControllerTestExecutionBlockType tmpBlock = ^{};
	
	[_testRowArray addObject:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  inName, FZBaseDemoViewControllerDictionaryKeyName,
	  inDescription, FZBaseDemoViewControllerDictionaryKeyDescription,
	  inView, FZBaseDemoViewControllerDictionaryKeyView,
	  tmpBlock, FZBaseDemoViewControllerDictionaryKeyExecutionBlock,
	  nil]];
}

#pragma mark -
#pragma mark UITableView data source functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_testRowArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *const testCellIdentifier = @"testCellIdentifier";
	UITableViewCell *tmpCell = [tableView dequeueReusableCellWithIdentifier:testCellIdentifier];
	if (!tmpCell)
	{
		tmpCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:testCellIdentifier];
	}
	
	NSDictionary *tmpDictionary = [_testRowArray objectAtIndex:indexPath.row];
	[tmpCell.textLabel setText:[tmpDictionary objectForKey:FZBaseDemoViewControllerDictionaryKeyName]];
	[tmpCell.detailTextLabel setText:[tmpDictionary objectForKey:FZBaseDemoViewControllerDictionaryKeyDescription]];

	return tmpCell;
}

#pragma mark -
#pragma mark UITableView delegate functions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSDictionary *tmpDictionary = [_testRowArray objectAtIndex:indexPath.row];
	if ([tmpDictionary objectForKey:FZBaseDemoViewControllerDictionaryKeyExecutionBlock]) 
	{
		FZBaseDemoViewControllerTestExecutionBlockType tmpBlock = [tmpDictionary objectForKey:FZBaseDemoViewControllerDictionaryKeyExecutionBlock];
		tmpBlock();
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *tmpDictionary = [_testRowArray objectAtIndex:indexPath.row];
	if ([tmpDictionary objectForKey:FZBaseDemoViewControllerDictionaryKeyView]) 
	{
		UIView *tmpView = [tmpDictionary objectForKey:FZBaseDemoViewControllerDictionaryKeyView];
		return tableView.rowHeight + tmpView.bounds.size.height + FZBaseDemoViewControllerCellMargin * 2;
	}
	return tableView.rowHeight;
}

#pragma mark -
- (void)dealloc
{
}

@end




static CGFloat const FZBaseDemoTableViewCellMargin = 5.0f;

@implementation FZBaseDemoTableViewCell
@synthesize customView = _customView;

- (id)initWithReuseIdentifier:(NSString *)inReuseIdentifier
{
	if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:inReuseIdentifier])
	{
		[self setSelectionStyle:UITableViewCellSelectionStyleBlue];
	}
	return self;
}

- (void)setName:(NSString *)inName description:(NSString *)inDescription view:(UIView *)inView
{
	[self.textLabel setText:inName];
	[self.detailTextLabel setText:inDescription];
	_customView = inView;
	[self.contentView addSubview:_customView];
	
	[self setNeedsLayout];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.textLabel setOrigin:CGPointMake(self.textLabel.frame.origin.x, FZBaseDemoTableViewCellMargin)];
	[self.detailTextLabel setOrigin:CGPointMake(self.detailTextLabel.frame.origin.x, self.textLabel.frame.origin.y + self.textLabel.bounds.size.height)];
	[_customView setOrigin:CGPointMake(self.textLabel.frame.origin.x, CGRectGetMaxY(self.detailTextLabel.frame) + FZBaseDemoTableViewCellMargin)];
}

@end
