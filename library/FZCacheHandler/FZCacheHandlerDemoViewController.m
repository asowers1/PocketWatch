//
//  FZCacheHandlerDemoViewController.m
//  FZModuleLibrary
//
//  Created by Michael Rakowski on 8/26/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import "FZCacheHandlerDemoViewController.h"

#import "FZCacheHandler.h"

static NSString *const FZCacheHandlerDemoViewControllerCacheKeyStringTest = @"FZCacheHandlerDemoViewControllerCacheKeyStringTest";

@interface FZCacheHandlerDemoViewController ()

@end

@implementation FZCacheHandlerDemoViewController

- (id)init
{
    self = [super init];
    if (self)
	{
		[self setTitle:@"FZCacheHandler"];
		
		[self addTestRowWithName:@"Add object to cache then retrieve"
					 description:@"Shows the typical pattern for retrieving an object from the cache "
				  executionBlock:
		 ^
		 {
			 // A joke string object that we will attempt to cache
			 NSString *tmpJokeString = @"Knock knock. Who's there? Interrupting cow. Interrup-MOOOOOOOOOOOOOO!! (attempt to cache this joke)";
			 
			 // Set the object in the cache
			 [FZCacheHandler setObject:tmpJokeString forKey:FZCacheHandlerDemoViewControllerCacheKeyStringTest];
			 
			 // Try to get the object from the cache
			 NSString *tmpString = [FZCacheHandler objectForKey:FZCacheHandlerDemoViewControllerCacheKeyStringTest];
			 if (!tmpString)
			 {
				 // The object was not found in cache. Generate the data by other means (ie. from local disk, remote server, do processing locally, etc).
				 tmpString = @"Knock knock. Who's there? Interrupting cow. Interrup-MOOOOOOOOOOOOOO!! (joke was not in cache)";
			 }
			 
			 // Show an alert view with the string that either came from the cache or was created on demand
			 UIAlertView *tmpAlertView = [[UIAlertView alloc] initWithTitle:@"The Joke"
																	message:tmpString
																   delegate:nil
														  cancelButtonTitle:@"Close"
														  otherButtonTitles:nil];
			 [tmpAlertView show];
		 }];
    }
    return self;
}

@end
