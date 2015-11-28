//
//  FZAlertView.h
//  FZModuleLibrary
//
//  Created by Christopher Luu on 10/12/11.
//  Copyright (c) 2011 Fuzz Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZAlertViewActionObject : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy) id block;
+ (instancetype)alertViewActionObjectWithName:(NSString *)inName block:(id)inBlock;
@end

typedef void (^FZAlertViewButtonPressedBlockType)();
typedef void (^FZAlertViewButtonPressedBlockWithTextType)(NSString *inString);

/**
 
 FZAlertView is primarily a set of convenience methods that show alert dialog pop-ups with any combination of text content and buttons.  This class enables the developer to easily create and show alerts without having to instantiate them and implement their delegate functions. There are two properties that are for internal use for storing execution blocks, and should be of no concern or use to the developer.  All callback blocks are set by passing them into the convenience methods of this class, so calling setCancelBlock or setAcceptBlock are not necessary. Note that supplying all parameters as NIL will show just a small bubble that cannot be dismissed.
 
 */
@interface FZAlertView : UIAlertView <UIAlertViewDelegate>

/**
 
 Displays an alert box with the supplied title and message.  This alert will have one button labelled "Close" which will dismiss the alert box.
 
 @param inTitle The title of the alert box
 @param inMessage The text to be displayed in the alert box's content area
 
 */
+ (instancetype)showAlertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage;

/**
 
 Displays an alert box with the supplied title and message.  This alert uses the inCloseButtonTitle for the label of the button that will dismiss the alert when pressed.
 
 @param inTitle The title of the alert box
 @param inMessage The text to be displayed in the alert box's content area
 @param inCloseButtonTitle The title of the button that dismisses the alert
 
 */
+ (instancetype)showAlertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage closeButtonTitle:(NSString *)inCloseButtonTitle;

/**
 
 Displays an alert box with the supplied title and message.  This alert uses the inCloseButtonTitle for the label of the button that will dismiss the alert when pressed. The last parameter is a callback block that will be
 
 @param inTitle The title of the alert box
 @param inMessage The text to be displayed in the alert box's content area
 @param inCloseButtonTitle The title of the button that dismisses the alert
 
 */
+ (instancetype)showAlertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage closeButtonTitle:(NSString *)inCloseButtonTitle closeBlock:(FZAlertViewButtonPressedBlockType)inCloseBlock;
+ (instancetype)showAlertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage closeButtonTitle:(NSString *)inCloseButtonTitle acceptButtonTitle:(NSString *)inAcceptButtonTitle closeBlock:(FZAlertViewButtonPressedBlockType)inCloseBlock acceptBlock:(FZAlertViewButtonPressedBlockType)inAcceptBlock;
+ (instancetype)showAlertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonTitle:(NSString *)inCancelButtonTitle acceptButtonTitle:(NSString *)inAcceptButtonTitle cancelBlock:(FZAlertViewButtonPressedBlockType)inCancelBlock acceptBlock:(FZAlertViewButtonPressedBlockType)inAcceptBlock DEPRECATED_ATTRIBUTE;
+ (instancetype)showAlertViewWithStyle:(UIAlertViewStyle)inStyle title:(NSString *)inTitle message:(NSString *)inMessage closeButtonTitle:(NSString *)inCloseButtonTitle acceptButtonTitle:(NSString *)inAcceptButtonTitle closeBlock:(FZAlertViewButtonPressedBlockType)inCloseBlock acceptBlock:(FZAlertViewButtonPressedBlockWithTextType)inAcceptBlock;

+ (instancetype)alertViewWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonTitle:(NSString *)inCancelButtonTitle acceptButtonTitle:(NSString *)inAcceptButtonTitle cancelBlock:(FZAlertViewButtonPressedBlockType)inCancelBlock acceptBlock:(FZAlertViewButtonPressedBlockType)inAcceptBlock DEPRECATED_ATTRIBUTE;

+ (instancetype)showAlertViewWithStyle:(UIAlertViewStyle)inStyle title:(NSString *)inTitle message:(NSString *)inMessage actionObjectArray:(NSArray *)inActionObjectArray;
+ (instancetype)alertViewWithStyle:(UIAlertViewStyle)inStyle title:(NSString *)inTitle message:(NSString *)inMessage actionObjectArray:(NSArray *)inActionObjectArray;
@end
