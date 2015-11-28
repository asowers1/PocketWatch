//
//  FZActionSheet.h
//  Zagat
//
//  Created by Christopher Luu on 10/21/11.
//  Copyright (c) 2011 Fuzz Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FZActionSheetButtonPressedBlockType)();
/**
 `FZActionSheet` is a wrapper around `UIActionSheet` that provides convenience constructers and block-based callbacks. Use it wherever `UIActionSheet` would be used. This module enables you to quickly add as many button as you want to the action sheet.
 */
@interface FZActionSheet : UIActionSheet <UIActionSheetDelegate>
{
	NSMutableDictionary *_blockDictionary;
}
///---------------------------------------------
/// @name Action sheet convenience display methods
///---------------------------------------------

/**
 Creates and shows a `UIActionSheet` with the specified title. Simply input nil for the button's title (cancelButtonTitle or destructiveButtonTitle) if you don't want it to show on the action sheet. 
 
 @param inTitle The title for the action sheet.
 @param inCancelButtonTitle The title for the cancel button.
 @param inCancelBlock A block to execute when the action sheet is dismissed with the cancel button.
 @param inDestructiveButtonTitle The title for the destructive button.
 @param inDestructiveBlock A block to execute when the action sheet is dissmissed with the destructive button.
 */
- (id)initWithTitle:(NSString *)inTitle cancelButtonTitle:(NSString *)inCancelButtonTitle cancelBlock:(FZActionSheetButtonPressedBlockType)inCancelBlock destructiveButtonTitle:(NSString *)inDestructiveButtonTitle destructiveBlock:(FZActionSheetButtonPressedBlockType)inDestructiveBlock;

/**
 Add a button with the specified title and a block to execute when tapped.
 
 @param inTitle The title for the button.
 @param inButtonBlock A block to execute when the button is tapped.
 */
- (NSInteger)addButtonWithTitle:(NSString *)inTitle buttonBlock:(FZActionSheetButtonPressedBlockType)inButtonBlock;

/**
 Add a cancel button with the specified title and a block to execute when tapped.
 
 @param inTitle The title for the cancel button.
 @param inCancelButtonBlock A block to execute when the action sheet is dismissed with the cancel button.
 */
- (void)addCancelButtonWithTitle:(NSString *)inTitle cancelButtonBlock:(FZActionSheetButtonPressedBlockType)inCancelButtonBlock;

@end
