//
//  FZCacheDemoViewController.m
//  FZCache
//
//  Created by Anton Remizov on 6/12/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "FZCacheDemoViewController.h"

@implementation FZCacheDemoViewController

-(void)setupDemo{
    [super setupDemo];
    
    __block UIViewController* blockSelf = self;
	[self addTestRowWithName:@"Test manipulating the cache."
				 description:@"See the RAM/LocalHD changes in real time."
			  executionBlock:
	 ^
	 {
         [blockSelf.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Demo" bundle:nil] instantiateInitialViewController] animated:YES];
	 }];
	
}

@end
