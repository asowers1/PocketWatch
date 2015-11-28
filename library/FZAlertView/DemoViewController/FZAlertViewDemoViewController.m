//
//  FZViewController.m
//  example
//
//  Created by Nick Trienens on 1/22/14.
//  Copyright (c) 2014 com.fuzzproductions. All rights reserved.
//

#import "FZAlertViewDemoViewController.h"
#import <FZAlertView.h>


@implementation FZAlertViewDemoViewController

+(FZDemoDataModel*)aboutMe{
	return [FZDemoDataModel demoMethodWithSelector:nil title:@"FZAlertView Demo" description:@"show meessages with blocks"];
}

-(void)setupDemoData{
	
	self.demoListingArray = [NSMutableArray array];
	[self.demoListingArray addObject:[FZDemoDataModel demoMethodWithBlock:^(){
		
		[FZAlertView showAlertViewWithTitle:@"Testing Title" message:nil];
		
	} title:@"Alert With Title" description:@"Simple"]];
	
	
	[self.demoListingArray addObject:[FZDemoDataModel demoMethodWithBlock:^(){
		
		[FZAlertView showAlertViewWithTitle:@"Testing Title & message" message:@"message goes here. \n newline"];
		
	} title:@"Alert With Title & message" description:@"Also Very Simple"]];
	
	
	[self addTestRowWithName:@"Close Block Test"
				 description:@"Alert with a close block"
			  executionBlock:
	 ^
	 {
		 [FZAlertView showAlertViewWithTitle:@"Title!"
									 message:@"My message!"
							closeButtonTitle:@"Block Close!" closeBlock:
		  ^
		  {
			  DLog(@"I was closed!");
		  }];
	 }];
	
	
	
	[self.demoListingArray addObject:[FZDemoDataModel demoMethodWithSelector:@"fullBlockDemo" title:@"Full Block Test" description:@"Alert with cancel and accept blocks"]];
	
	
}

-(void)fullBlockDemo{
	
	
	[FZAlertView showAlertViewWithTitle:@"Oh no!"
								message:@"Something terrible is about to happen!"
					  cancelButtonTitle:@"Abort!"
					  acceptButtonTitle:@"Concede..."
							cancelBlock:
	 ^
	 {
		 DLog(@"Abort failed! You have been eaten by a grue");
	 }
							acceptBlock:
	 ^
	 {
		 DLog(@"You've resigned yourself to weep softly in the corner. You are then eaten by a grue.");
	 }];
}
@end
