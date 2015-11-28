//
//  FZBaseDemoViewController.h
//  FZModuleLibrary
//
//  Created by Christopher Luu on 3/20/12.
//  Copyright (c) 2012 Fuzz Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const FZBaseDemoViewControllerDictionaryKeyName;
UIKIT_EXTERN NSString *const FZBaseDemoViewControllerDictionaryKeyDescription;
UIKIT_EXTERN NSString *const FZBaseDemoViewControllerDictionaryKeyExecutionBlock;
UIKIT_EXTERN NSString *const FZBaseDemoViewControllerDictionaryKeyView;

typedef void (^FZBaseDemoViewControllerTestExecutionBlockType)();

@interface FZBaseDemoViewController : UITableViewController
{
	NSMutableArray *_testRowArray;
}

- (void)addTestRowWithName:(NSString *)inName description:(NSString *)inDescription executionBlock:(FZBaseDemoViewControllerTestExecutionBlockType)inExecutionBlock;
- (void)addTestRowWithName:(NSString *)inName description:(NSString *)inDescription view:(UIView *)inView;
- (void)setupDemo;

@end


@interface FZBaseDemoTableViewCell : UITableViewCell <UITextFieldDelegate>
{
	UIView *_customView;
}
@property (nonatomic, retain) UIView *customView;

- (id)initWithReuseIdentifier:(NSString *)inReuseIdentifier;
- (void)setName:(NSString *)inName description:(NSString *)inDescription view:(UIView *)inView;
@end
