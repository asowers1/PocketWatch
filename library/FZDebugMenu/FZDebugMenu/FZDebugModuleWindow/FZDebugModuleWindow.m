//
//  FZDebugModuleWindow.m
//  FZModuleLibrary
//
//  Created by Christopher Luu on 11/6/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import "FZDebugModuleWindow.h"

#import "FZDebugMenuTableViewController.h"

@implementation FZDebugModuleWindow

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		FZDebugMenuTableViewController *tmpViewController = [[FZDebugMenuTableViewController alloc] init];
		[tmpViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(doClose)]];
		UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:tmpViewController];
		[self setRootViewController:tmpNavController];
	}
	return self;
}

- (void)makeKeyAndVisible {
	[self setPreviousKeyWindow:[[UIApplication sharedApplication] keyWindow]];
	[super makeKeyAndVisible];
}

- (void)showDebugViewController
{
	[UIView animateWithDuration:0.5f
						  delay:0.0f
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:
	 ^
	 {
		 [self setDisplayAmount:1.0f];
	 }
					 completion:nil];
}

- (void)dismissDebugViewController
{

	[UIView animateWithDuration:0.5f
						  delay:0.0f
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:
	 ^
	 {
		 [self setDisplayAmount:0.0f];
	 }
					 completion:
	 ^(BOOL finished)
	 {
		 [_previousKeyWindow makeKeyAndVisible];
	 }];
}

- (void)setDisplayAmount:(CGFloat)inDisplayAmount {
	CGFloat tmpScale = -0.3f * inDisplayAmount + 1.0f;
	[_previousKeyWindow setTransform:CGAffineTransformMakeScale(tmpScale, tmpScale)];
	[self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:inDisplayAmount * 0.6f]];
    
	if (inDisplayAmount < 1.0f)
		[self.rootViewController.view setTransform:CGAffineTransformMakeTranslation(self.bounds.size.width - self.bounds.size.width * inDisplayAmount, 0.0f)];
	else
		[self.rootViewController.view setTransform:CGAffineTransformIdentity];
}

- (void)doClose {
	[self dismissDebugViewController];
}

@end
