//
//  FZDebugMenu.h
//  Fuzz
//
//  Created by Sheng Dong on 3/24/15.
//
//

#import <Foundation/Foundation.h>
#import <FZBase/Fuzz.h>

@interface FZDebugMenu : NSObject

/**
 Adds gesture recognizer to window and shows debug menu on swipe from right of screen
 @param UIWindow *window
 @return void
 */

+ (void)initializeWithWindow:(UIWindow*)window;

/**
 Adds a custom command to be shown in the dbeug menu list
 @param NSString* for title of command
 @param void (^genericBlock)(void) execution block
 @return void
 */

+ (void)addCustomCommandWithTitle:(NSString*)title andExecutionBlock:(FZBlock)actionBlock;

/**
 Returns an array of all custom commands
 @param void
 @return NSArray* of custom commands
 */

+ (NSArray*)customCommands;

/**
 Presents view controller
 @param UIViewController* to present
 @return void
 */

+ (void)presentViewController:(UIViewController*)viewController;

+ (void)pushViewController:(UIViewController *)viewController;

/**
 Dismiss debug module
 @param void
 @return void
 */

+ (void)dismiss;

/**
 *  Removes gesture recognizer that launches the debug menu
 */
+ (void)closeDebugMenuInWindow:(UIWindow *)inWindow;

@end
