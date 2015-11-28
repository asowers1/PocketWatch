//
//  FZDebugModuleWindow.h
//  FZModuleLibrary
//
//  Created by Christopher Luu on 11/6/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZDebugModuleWindow : UIWindow

@property (nonatomic, weak) UIWindow *previousKeyWindow;

- (void)showDebugViewController;
- (void)dismissDebugViewController;
- (void)setDisplayAmount:(CGFloat)inDisplayAmount;

@end
