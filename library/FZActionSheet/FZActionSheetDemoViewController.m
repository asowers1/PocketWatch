//
//  FZActionSheetDemoBaseViewController.m
//  FZActionSheetDemo
//
//  Created by Nick Trienens on 3/6/14.
//  Copyright (c) 2014 com.fuzzproductions. All rights reserved.
//

#import "FZActionSheetDemoViewController.h"
#import "FZActionSheet.h"
#import "Fuzz.h"

@interface FZActionSheetDemoViewController ()

@end

@implementation FZActionSheetDemoViewController


-(void)setupDemo{
	
    [super setupDemo];
    
	[self setTitle:@"FZActionSheet"];
	
	__block typeof(self) tmpself = self;

	[self addTestRowWithName:@"Simple FZActionSheet"
				 description:@"Sheet with destruction and cancel button"
			  executionBlock:
	 ^
	 {
		 FZActionSheet *tmpActionSheet = [[FZActionSheet alloc] initWithTitle:@"FZActionSheet" cancelButtonTitle:@"Cancel"
																  cancelBlock:^
										  {
											  DLog(@"cancel");
										  }
													   destructiveButtonTitle:@"Destructive"
															 destructiveBlock:^
										  {
											  DLog(@"destructive");
										  }];
		 
		 [tmpActionSheet showInView:tmpself.view];
		 
		 
	 }];
	
	[self addTestRowWithName:@"One more button"
				 description:@"A button added"
			  executionBlock:
	 ^
	 {
         
		 FZActionSheet *tmpActionSheet = [[FZActionSheet alloc] initWithTitle:@"FZActionSheet"
                                                            cancelButtonTitle:nil
																  cancelBlock:nil
													   destructiveButtonTitle:@"Destructive"
															 destructiveBlock:^
										  {
											  DLog(@"destructive");
										  }];
		 
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 
         [tmpActionSheet addCancelButtonWithTitle:@"Cancel" cancelButtonBlock:^
          {
              DLog(@"cancel");
          }];
         
		 [tmpActionSheet showInView:tmpself.view];
		 
		 
	 }];
    
    
	[self addTestRowWithName:@"One more Cancel button"
				 description:@"One more button and cancel button"
			  executionBlock:
	 ^
	 {
		 FZActionSheet *tmpActionSheet = [[FZActionSheet alloc] initWithTitle:@"FZActionSheet" cancelButtonTitle:@"Cancel"
																  cancelBlock:^
										  {
											  DLog(@"cancel");
										  }
													   destructiveButtonTitle:@"Destructive"
															 destructiveBlock:^
										  {
											  DLog(@"destructive");
										  }];
		 
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 
		 [tmpActionSheet showInView:tmpself.view];
		 
	 }];
	
    /*
	[self addTestRowWithName:@"4 buttons + Cancel button"
				 description:@"4 buttons and cancel button"
			  executionBlock:
	 ^
	 {
		 FZActionSheet *tmpActionSheet = [[FZActionSheet alloc] initWithTitle:@"FZActionSheet" cancelButtonTitle:@"Cancel"
																  cancelBlock:^
										  {
											  DLog(@"cancel");
										  }
													   destructiveButtonTitle:@"Destructive"
															 destructiveBlock:^
										  {
											  DLog(@"destructive");
										  }];
		 
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 
		 [tmpActionSheet showInView:tmpself.view];
		 
	 }];
	
	
	[self addTestRowWithName:@"15 buttons + 15 cancel button"
				 description:@"15 more buttons and cancel buttons"
			  executionBlock:
	 ^
	 {
		 FZActionSheet *tmpActionSheet = [[FZActionSheet alloc] initWithTitle:@"FZActionSheet" cancelButtonTitle:@"Cancel"
																  cancelBlock:^
										  {
											  DLog(@"cancel");
										  }
													   destructiveButtonTitle:@"Destructive"
															 destructiveBlock:^
										  {
											  DLog(@"destructive");
										  }];
		 
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 [tmpActionSheet addButtonWithTitle:@"OneMoreButton" buttonBlock:^{ DLog(@"This is another added button");}];
		 
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:@"OneMoreCancelButton" cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 
		 [tmpActionSheet showInView:tmpself.view];
		 
	 }];
	
    
	[self addTestRowWithName:@"Cancel button Nil Test"
				 description:@"What happens when Cancel button is nil?"
			  executionBlock:
	 ^
	 {
		 FZActionSheet *tmpActionSheet = [[FZActionSheet alloc] initWithTitle:@"Cancel button Nil Test" cancelButtonTitle:nil
																  cancelBlock:^
										  {
											  DLog(@"cancel");
										  }
													   destructiveButtonTitle:@"Destructive"
															 destructiveBlock:^
										  {
											  DLog(@"destructive");
										  }];
		 
		 [tmpActionSheet showInView:tmpself.view];
		 
	 }];
	
	[self addTestRowWithName:@"Destructive button Nil Test"
				 description:@"What happens when Destructive button is nil?"
			  executionBlock:
	 ^
	 {
		 FZActionSheet *tmpActionSheet = [[FZActionSheet alloc] initWithTitle:@"Destructive button Nil Test" cancelButtonTitle:@"Cancel"
																  cancelBlock:^
										  {
											  DLog(@"cancel");
										  }
													   destructiveButtonTitle:nil
															 destructiveBlock:^
										  {
											  DLog(@"destructive");
										  }];
		 
		 [tmpActionSheet showInView:tmpself.view];
		 
	 }];
	
	[self addTestRowWithName:@"Nil Test - BAD things"
				 description:@"What happens when every input is nil?"
			  executionBlock:
	 ^
	 {
		 FZActionSheet *tmpActionSheet = [[FZActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil
																  cancelBlock:^
										  {
											  DLog(@"cancel");
										  }
													   destructiveButtonTitle:nil
															 destructiveBlock:^
										  {
											  DLog(@"destructive");
										  }];
		 
		 [tmpActionSheet showInView:tmpself.view];
		 
	 }];
	
	[self addTestRowWithName:@"Massive String"
				 description:@"What Happens with massive string"
			  executionBlock:
	 ^
	 {
		 FZActionSheet *tmpActionSheet = [[FZActionSheet alloc] initWithTitle:@"FZActionSheet" cancelButtonTitle:@"Cancel"
																  cancelBlock:^
										  {
											  DLog(@"cancel");
										  }
													   destructiveButtonTitle:@"Destructive"
															 destructiveBlock:^
										  {
											  DLog(@"destructive");
										  }];
		 
		 NSString *massiveString = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
		 
		 [tmpActionSheet addCancelButtonWithTitle:massiveString cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:massiveString cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:massiveString cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 [tmpActionSheet addCancelButtonWithTitle:massiveString cancelButtonBlock:^{ DLog(@"Another cancel button");}];
		 
		 [tmpActionSheet showInView:tmpself.view];
		 
	 }];
     */
}

@end

