//
//  FZDebugModuleGestureRecognizer.h
//  FZModuleLibrary
//
//  Created by Christopher Luu on 11/5/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import "YIEdgePanGestureRecognizer.h"
#import "FZDebugModuleWindow.h"

@interface FZDebugModuleGestureRecognizer : YIEdgePanGestureRecognizer <UIGestureRecognizerDelegate>

+ (void)attachToWindow:(UIWindow *)inWindow;
+ (void)detachFromWindow:(UIWindow *)inWindow;

@property (nonatomic, strong) FZDebugModuleWindow *debugWindow;
+ (UIWindow*)sharedDebugWindow;
+ (void)dismissDebugController;

@end
