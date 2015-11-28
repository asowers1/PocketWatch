//
//  FZDebugModuleGestureRecognizer.m
//  FZModuleLibrary
//
//  Created by Christopher Luu on 11/5/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import "FZDebugModuleGestureRecognizer.h"

#import "FZDebugModuleWindow.h"

#import <UIKit/UIGestureRecognizerSubclass.h>
#import <QuartzCore/QuartzCore.h>

static UIWindow *sharedDebugWindow;

@interface FZDebugModuleGestureRecognizer ()

@end

@implementation FZDebugModuleGestureRecognizer

+ (void)attachToWindow:(UIWindow *)inWindow
{
    
    // Check if gesture already exists
    
    for (UIGestureRecognizer * tmpGR in inWindow.gestureRecognizers)
    {
        if ([tmpGR isKindOfClass:[FZDebugModuleGestureRecognizer class]])
        {
            return;
        }
    }
    
	FZDebugModuleGestureRecognizer *tmpGestureRecognizer = [[FZDebugModuleGestureRecognizer alloc] init];
	[tmpGestureRecognizer addTarget:tmpGestureRecognizer action:@selector(debugGestureRecognized:)];
	[tmpGestureRecognizer setDelegate:tmpGestureRecognizer];
	[inWindow addGestureRecognizer:tmpGestureRecognizer];
}

+ (void)detachFromWindow:(UIWindow *)inWindow
{
    for (UIGestureRecognizer * tmpGR in inWindow.gestureRecognizers)
    {
        if ([tmpGR isKindOfClass:[FZDebugModuleGestureRecognizer class]])
        {
            [inWindow removeGestureRecognizer:tmpGR];
        }
    }
}


- (instancetype)init
{
	if (self = [super init])
	{
		_debugWindow = [[FZDebugModuleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		
		
		sharedDebugWindow = _debugWindow;

#if !TARGET_IPHONE_SIMULATOR
		[self setMinimumNumberOfTouches:2];
		[self setMaximumNumberOfTouches:2];
#else
		[self setMinimumNumberOfTouches:1];
		[self setMaximumNumberOfTouches:1];
#endif
		[self setEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
	}
	return self;
}


#pragma Utility Methods

+ (void)dismissDebugController
{
	[(FZDebugModuleWindow*)[self sharedDebugWindow] dismissDebugViewController];
}

+ (UIWindow*)sharedDebugWindow
{
	return sharedDebugWindow;
}

#pragma mark -
#pragma mark UIGestureRecognizer action methods

- (void)debugGestureRecognized:(FZDebugModuleGestureRecognizer *)inGestureRecognizer
{
	UIView *tmpView = [inGestureRecognizer view];
	CGPoint tmpPoint = [inGestureRecognizer locationInView:tmpView];

	if (tmpPoint.x < 0.0f)
		tmpPoint.x = 0.0f;
	else if (tmpPoint.x > tmpView.bounds.size.width)
		tmpPoint.x = tmpView.bounds.size.width;

	if ([inGestureRecognizer state] == UIGestureRecognizerStateBegan)
	{
		if (!([inGestureRecognizer firstTouchArea] & YIEdgePanGestureRecognizerFirstTouchAreaRight))
		{
			[self setState:UIGestureRecognizerStateFailed];
			return;
		}
		[_debugWindow makeKeyAndVisible];
		[_debugWindow setDisplayAmount:0.0f];
	}
	else if ([inGestureRecognizer state] == UIGestureRecognizerStateChanged)
	{
		[_debugWindow setDisplayAmount:(tmpView.bounds.size.width - tmpPoint.x) / tmpView.bounds.size.width];
	}
	else if ([inGestureRecognizer state] == UIGestureRecognizerStateEnded)
	{
		if (tmpPoint.x > tmpView.bounds.size.width / 2.0f)
		{
			[_debugWindow dismissDebugViewController];
		}
		else
		{
			[_debugWindow showDebugViewController];
		}
	}
}

#pragma mark -
#pragma mark UIGestureRecognizer delegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

@end
