//
//  FZDebugMenu.m
//  Fuzz
//
//  Created by Sheng Dong on 3/24/15.
//
//

#import <UIKit/UIKit.h>
#import "FZDebugMenu.h"
#import "FZDebugModuleGestureRecognizer.h"
#import "FZDebugModuleCustomCommand.h"

@interface FZDebugMenu ()

@property (nonatomic, strong) NSMutableArray *customCommands;

@end

@implementation FZDebugMenu

#pragma mark Initialize

+ (void)initializeWithWindow:(UIWindow *)window {
    [[self shared] addDebugModuleToWindow:(UIWindow*)window];
    [[self shared] setup];
}

#pragma mark Private Methods

- (void)addDebugModuleToWindow:(UIWindow*)window {
    [FZDebugModuleGestureRecognizer attachToWindow:window];
}

- (void)setup {
    _customCommands = [NSMutableArray new];
}

+ (instancetype)shared
{
    static FZDebugMenu *_shared = nil;
    
    Once(^
         {
             _shared = [[self alloc] init];
             
         });
    
    return _shared;
}

#pragma mark Custom Commands

+ (void)addCustomCommandWithTitle:(NSString*)title andExecutionBlock:(FZBlock)actionBlock
{
    FZDebugModuleCustomCommand *customCommand = [[FZDebugModuleCustomCommand alloc] initWithName:title andExecutionBlock:actionBlock];
    [[[self shared] customCommands] addObject:customCommand];
}

+ (NSArray*)customCommands
{
    return [[self shared] customCommands];
}

#pragma mark Presenting and Dismissing

+ (void)presentViewController:(UIViewController*)viewController
{
    UIViewController *rootViewController = [[FZDebugModuleGestureRecognizer sharedDebugWindow] rootViewController];
    [rootViewController presentViewController:viewController animated:YES completion:nil];
}

+ (void)pushViewController:(UIViewController *)viewController {
    UIViewController *rootViewController = [[FZDebugModuleGestureRecognizer sharedDebugWindow] rootViewController];
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navRootViewController = (UINavigationController *)rootViewController;
        [navRootViewController pushViewController:viewController animated:YES];
    }
}

+ (void)dismiss
{
    [FZDebugModuleGestureRecognizer dismissDebugController];
}

+ (void)closeDebugMenuInWindow:(UIWindow *)inWindow
{
    [FZDebugModuleGestureRecognizer detachFromWindow:inWindow];
}

@end
