//
//  FZActionSheet.m
//  Zagat
//
//  Created by Christopher Luu on 10/21/11.
//  Copyright (c) 2011 Fuzz Productions. All rights reserved.
//

#import "FZActionSheet.h"

/**
 
 FZActionSheet is an easy-to-use subclass of UIActionSheet that simplifies the creation, alteration, and execution handling of the class.  Built around code blocks, the developer can easily create new buttons and assign callback methods to be executed when that button is pressed. Developers can instantiate an instance with just the default buttons - the dark grey 'cancel' and bright red 'destructive' ones - or add new buttons and change the default cancel button index.  All callback blocks are stored in a private mutable dictionary that is indexed by button title, so the developer must be sure to give each button a unique name to avoid collisions.
 
 */

@implementation FZActionSheet

/**
 
 Creates and returns an action sheet object using the supplied parameters.
 
 @return An new instance of FZActionSheet
 
 @param inTitle The text to be shown at the top center of the sheet
 @param inCancelButtonTitle The text that will be shown over the system default cancel button which has a grey color that is darker than other 'normal' buttons
 @param inCancelBlock The action to be performed when the user presses the cancel button
 @param destructiveButtonTitle The text that will be shown over the red-colored button
 @param inDestructiveBlock The action to be performed when the user presses the destructive button
 
 */



- (id)initWithTitle:(NSString *)inTitle cancelButtonTitle:(NSString *)inCancelButtonTitle cancelBlock:(FZActionSheetButtonPressedBlockType)inCancelBlock destructiveButtonTitle:(NSString *)inDestructiveButtonTitle destructiveBlock:(FZActionSheetButtonPressedBlockType)inDestructiveBlock
{
	if ((self = [super initWithTitle:inTitle delegate:self cancelButtonTitle:inCancelButtonTitle destructiveButtonTitle:inDestructiveButtonTitle otherButtonTitles:nil]))
	{
		_blockDictionary = [[NSMutableDictionary alloc] init];

		if (inCancelButtonTitle && inCancelBlock)
		{
			FZActionSheetButtonPressedBlockType tmpBlock = [inCancelBlock copy];
			[_blockDictionary setObject:tmpBlock forKey:inCancelButtonTitle];
		}
		if (inDestructiveButtonTitle && inDestructiveBlock)
		{
			FZActionSheetButtonPressedBlockType tmpBlock = [inDestructiveBlock copy];
			[_blockDictionary setObject:tmpBlock forKey:inDestructiveButtonTitle];
		}
	}
	return self;
}

/**
 
 Adds an additional light-grey button to an existing FZActionSheet instance.
 
 @return An integer representing the index of the newly-added button. This index starts at 0 and increases with each added button.
 
 @param inTitle The title to be displayed over the new button
 @param inButtonBlock The action to be performed when this button is pressed
 
 */

- (NSInteger)addButtonWithTitle:(NSString *)inTitle buttonBlock:(FZActionSheetButtonPressedBlockType)inButtonBlock
{
	if (inButtonBlock)
	{
		FZActionSheetButtonPressedBlockType tmpBlock = [inButtonBlock copy];
		[_blockDictionary setObject:tmpBlock forKey:inTitle];
	}

	return [super addButtonWithTitle:inTitle];
}

/**
 
 Adds a new button to an existing FZActionSheet that will become the new cancel button, which will be dark-grey with white text.  This will override any previous assignment of a cancel button.
 
 @param inTitle The text that will be shown over the system default cancel button which has a grey color that is darker than other 'normal' buttons
 @param inCancelButtonBlock The action to be performed when the user presses the cancel button
 
 */

- (void)addCancelButtonWithTitle:(NSString *)inTitle cancelButtonBlock:(FZActionSheetButtonPressedBlockType)inCancelButtonBlock
{
	NSInteger tmpInteger = [self addButtonWithTitle:inTitle buttonBlock:inCancelButtonBlock];
	[self setCancelButtonIndex:tmpInteger];
}

#pragma mark -
#pragma mark UIActionSheet delegate functions
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	FZActionSheetButtonPressedBlockType tmpBlock = [_blockDictionary objectForKey:[self buttonTitleAtIndex:buttonIndex]];
	if (tmpBlock)
		tmpBlock();
}

@end
