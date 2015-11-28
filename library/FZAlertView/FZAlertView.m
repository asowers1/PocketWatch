//
//  FZAlertView.m
//  FZModuleLibrary
//
//  Created by Christopher Luu on 10/12/11.
//  Copyright (c) 2011 Fuzz Productions. All rights reserved.
//

#import "FZAlertView.h"

#if !__has_feature(objc_arc)
#error FZAlertView must be built with ARC.
// You can turn on ARC for only FZAlertView files by adding -fobjc-arc to the build phase for each of its files.
#endif

@implementation FZAlertViewActionObject
+ (instancetype)alertViewActionObjectWithName:(NSString *)inName block:(id)inBlock
{
	FZAlertViewActionObject *rtnActionObject = [FZAlertViewActionObject new];
	rtnActionObject.name = inName;
	rtnActionObject.block = inBlock;
	return rtnActionObject;
}
@end

@interface FZAlertView()
@property (nonatomic, strong) NSArray *actionObjectArray;
@end

@implementation FZAlertView

#pragma mark -
#pragma mark FZAlertView class methods
+ (instancetype)showAlertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage
{
	return [self showAlertViewWithStyle:UIAlertViewStyleDefault title:inTitle message:inMessage closeButtonTitle:@"Close" acceptButtonTitle:nil closeBlock:nil acceptBlock:nil];
}

+ (instancetype)showAlertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage closeButtonTitle:(NSString *)inCloseButtonTitle
{
	return [self showAlertViewWithStyle:UIAlertViewStyleDefault title:inTitle message:inMessage closeButtonTitle:inCloseButtonTitle acceptButtonTitle:nil closeBlock:nil acceptBlock:nil];
}

+ (instancetype)showAlertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage closeButtonTitle:(NSString *)inCloseButtonTitle closeBlock:(FZAlertViewButtonPressedBlockType)inCloseBlock
{
	return [self showAlertViewWithStyle:UIAlertViewStyleDefault title:inTitle message:inMessage closeButtonTitle:inCloseButtonTitle acceptButtonTitle:nil closeBlock:inCloseBlock acceptBlock:nil];
}

+ (instancetype)showAlertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonTitle:(NSString *)inCancelButtonTitle acceptButtonTitle:(NSString *)inAcceptButtonTitle cancelBlock:(FZAlertViewButtonPressedBlockType)inCancelBlock acceptBlock:(FZAlertViewButtonPressedBlockType)inAcceptBlock
{
	return [self showAlertViewWithStyle:UIAlertViewStyleDefault title:inTitle message:inMessage closeButtonTitle:nil acceptButtonTitle:inAcceptButtonTitle closeBlock:nil acceptBlock:inAcceptBlock];
}

+ (instancetype)showAlertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage closeButtonTitle:(NSString *)inCloseButtonTitle acceptButtonTitle:(NSString *)inAcceptButtonTitle closeBlock:(FZAlertViewButtonPressedBlockType)inCloseBlock acceptBlock:(FZAlertViewButtonPressedBlockType)inAcceptBlock
{
	return [self showAlertViewWithStyle:UIAlertViewStyleDefault title:inTitle message:inMessage closeButtonTitle:inCloseButtonTitle acceptButtonTitle:inAcceptButtonTitle closeBlock:inCloseBlock acceptBlock:inAcceptBlock];
}

+ (instancetype)showAlertViewWithStyle:(UIAlertViewStyle)inStyle title:(NSString *)inTitle message:(NSString *)inMessage closeButtonTitle:(NSString *)inCloseButtonTitle acceptButtonTitle:(NSString *)inAcceptButtonTitle closeBlock:(FZAlertViewButtonPressedBlockType)inCloseBlock acceptBlock:(FZAlertViewButtonPressedBlockWithTextType)inAcceptBlock
{
	NSMutableArray *tmpActionObjectArray = [NSMutableArray new];
	if (inAcceptButtonTitle)
	{
		[tmpActionObjectArray addObject:[FZAlertViewActionObject alertViewActionObjectWithName:inAcceptButtonTitle block:inAcceptBlock]];
	}
	if (inCloseButtonTitle)
	{
		[tmpActionObjectArray addObject:[FZAlertViewActionObject alertViewActionObjectWithName:inCloseButtonTitle block:inCloseBlock]];
	}
	
	return [self showAlertViewWithStyle:inStyle title:inTitle message:inMessage actionObjectArray:tmpActionObjectArray];
}

+ (instancetype)showAlertViewWithStyle:(UIAlertViewStyle)inStyle title:(NSString *)inTitle message:(NSString *)inMessage actionObjectArray:(NSArray *)inActionObjectArray
{
	FZAlertView *tmpAlertView = [self alertViewWithStyle:inStyle title:inTitle message:inMessage actionObjectArray:inActionObjectArray];
	[tmpAlertView show];
	return tmpAlertView;
}

+ (instancetype)alertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonTitle:(NSString *)inCancelButtonTitle acceptButtonTitle:(NSString *)inAcceptButtonTitle cancelBlock:(FZAlertViewButtonPressedBlockType)inCancelBlock acceptBlock:(FZAlertViewButtonPressedBlockType)inAcceptBlock
{
	return [self alertViewWithStyle:UIAlertViewStyleDefault title:inTitle message:inMessage actionObjectArray:@[[FZAlertViewActionObject alertViewActionObjectWithName:inCancelButtonTitle block:inCancelBlock], [FZAlertViewActionObject alertViewActionObjectWithName:inAcceptButtonTitle block:inAcceptBlock]]];
}

+ (instancetype)alertViewWithStyle:(UIAlertViewStyle)inStyle title:(NSString *)inTitle message:(NSString *)inMessage actionObjectArray:(NSArray *)inActionObjectArray
{
	FZAlertView *rtnAlertView = [FZAlertView new];
	rtnAlertView.alertViewStyle = inStyle;
	rtnAlertView.delegate = rtnAlertView;
	rtnAlertView.title = inTitle;
	rtnAlertView.message = inMessage;
	for (FZAlertViewActionObject *tmpAlertViewActionObject in inActionObjectArray)
	{
		[rtnAlertView addButtonWithTitle:tmpAlertViewActionObject.name];
	}
	rtnAlertView.actionObjectArray = inActionObjectArray;
	return rtnAlertView;
}

#pragma mark -
#pragma mark UIAlertView delegate functions
- (void)alertView:(FZAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (alertView.actionObjectArray.count > buttonIndex)
	{
		id tmpBlock = [alertView.actionObjectArray[buttonIndex] block];
		NSString *tmpBlockSignature = tmpBlock ? [NSString stringWithUTF8String:BlockSig(tmpBlock)] : @"";
		// Determine whether this block returns a string or not
		if ([tmpBlockSignature rangeOfString:@"NSString"].location != NSNotFound)
		{
			FZAlertViewButtonPressedBlockWithTextType tmpTextBlock = tmpBlock;
			if (tmpTextBlock)
			{
				tmpTextBlock([alertView textFieldAtIndex:0].text);
			}
		}
		else
		{
			[tmpBlock invoke];
		}
	}
}

// Derived from Clang documentation ( http://clang.llvm.org/docs/Block-ABI-Apple.html ) and this SO post ( http://stackoverflow.com/questions/9048305/checking-objective-c-block-type )
// This code is unsafe to use elsewhere without significant edits.
struct FZAlert_block_literal {
	void *isa;
	int flags;
	int reserved;
	void (*invoke)(void *, ...);
	struct FZAlert_block_descriptor {
		unsigned long reserved;
		unsigned long size;
		void *rest[1];
	} *descriptor;
};

static const char *BlockSig(id blockObj)
{
	struct FZAlert_block_literal *block = (__bridge void *)blockObj;
	struct FZAlert_block_descriptor *descriptor = block->descriptor;
	
	int copyDisposeFlag = 1 << 25;
	int signatureFlag = 1 << 30;
	
	assert(block->flags & signatureFlag);
	
	int index = 0;
	if(block->flags & copyDisposeFlag)
		index += 2;
	
	return descriptor->rest[index];
}

@end
