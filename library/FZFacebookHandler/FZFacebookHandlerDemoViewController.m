//
//  FZFacebookHandlerDemoViewController.m
//  FZModuleLibrary
//
//  Created by Christopher Luu on 7/21/12.
//  Copyright (c) 2012 Fuzz Productions. All rights reserved.
//

#import "FZFacebookHandlerDemoViewController.h"
#import "FZFacebookHandler.h"
//#import <FZAlertView/FZAlertView.h>
#import <FZAlertView.h>
//#import <FZBase/Fuzz.h>
#import <Fuzz.h>
@implementation FZFacebookHandlerDemoViewController

- (void)setupDemo
{
	[super setupDemo];
	[self setTitle:@"FZFacebookHandler"];

		 //Set up the Facebook Handler, with basic read permissions
         //[FZFacebookHandler setUpHandlerWithAppId:@"1516458861907804"];
    
         //Otherwise you can specify permisions by using this class method, For more : https://developers.facebook.com/docs/facebook-login/permissions/v2.0
    
    
        // To test Publish permissions, log in with QA account
        // login: pablo@fuzzproductions.com
        // pw: qa0307
    
    
        NSArray *tmpReadPermissionsArray = @[@"email",@"user_photos"];
        // need publish_actions now
        NSArray *tmpPublishPermissionsArray = @[@"publish_actions"];
    
        [FZFacebookHandler setUpHandlerWithAppId:@"1516458861907804" readPermissions:tmpReadPermissionsArray publishPermissions:tmpPublishPermissionsArray];
    

    
		[self addTestRowWithName:@"Check Logged In"
					 description:@"Tests to see if Facebook is logged in"
				  executionBlock:
		 ^
		 {
			 if ([FZFacebookHandler isLoggedIn])
				 [FZAlertView showAlertViewWithTitle:@"FZFacebookHandler" message:@"User is logged in"];
			 else
				 [FZAlertView showAlertViewWithTitle:@"FZFacebookHandler" message:@"User is logged out"];
		 }];
		[self addTestRowWithName:@"Login"
					 description:@"Login to Facebook"
				  executionBlock:
		 ^
		 {
			 [FZFacebookHandler loginWithCompletionBlock:
			  ^(BOOL inSuccess, NSError *inError)
			  {
				  if (inSuccess)
					  [FZAlertView showAlertViewWithTitle:@"FZFacebookHandler" message:@"User successfully logged in to Facebook"];
				  else
					  [FZAlertView showAlertViewWithTitle:@"FZFacebookHandler" message:[NSString stringWithFormat:@"User failed to login to Facebook. Error: %@", [inError localizedDescription]]];
			  }];
		 }];
		[self addTestRowWithName:@"Logout"
					 description:@"Logout from Facebook"
				  executionBlock:
		 ^
		 {
			 [FZFacebookHandler logout];
			 [FZAlertView showAlertViewWithTitle:@"FZFacebookHandler" message:@"User should be logged out from Facebook"];
		 }];
		[self addTestRowWithName:@"Fetch Profile"
					 description:@"Fetch the logged in user's Facebook profile"
				  executionBlock:
		 ^
		 {
			 [FZFacebookHandler connectionForRequestWithGraphPath:@"me"
													   parameters:nil
													   HTTPMethod:@"GET"
												completionHandler:
			  ^(FBRequestConnection *connection, id result, NSError *error)
			  {
				  DLog(@"%@", result);
			  }];
		 }];
		[self addTestRowWithName:@"Fetch and Cancel"
					 description:@"Start a Facebook request and immediately cancel it"
				  executionBlock:
		 ^
		 {
			 FBRequestConnection *tmpConnection =
			 [FZFacebookHandler connectionForRequestWithGraphPath:@"me"
													   parameters:nil
													   HTTPMethod:@"GET"
												completionHandler:
			  ^(FBRequestConnection *connection, id result, NSError *error)
			  {
				  DLog(@"%@", error);
			  }];

			 [tmpConnection cancel];
		 }];
		[self addTestRowWithName:@"Post on My Wall"
					 description:@"Post a testing message to the user's wall"
				  executionBlock:
		 ^
		 {
			 [FZFacebookHandler connectionForRequestWithGraphPath:@"me/feed"
													   parameters:@{@"message": @"Hello world!", @"link": @"http://fuzzproductions.com"}
													   HTTPMethod:@"POST"
												completionHandler:
			  ^(FBRequestConnection *connection, id result, NSError *error)
			  {
				  DLog(@"%@", result);
                  if(error){
                      DLog(@"Facebook wall Post Error: %@",error);
                  }
			  }];
		 }];
		[self addTestRowWithName:@"Post an image"
					 description:@"Post a message and image to the user's wall"
				  executionBlock:
		 ^
		 {
			 [FZFacebookHandler connectionForRequestWithGraphPath:@"me/feed"
													   parameters:
			  @{
			  @"message": @"Hello world!",
			  @"picture": @"http://fuzzproductions.com/wp-content/themes/fuzz/images/unicorn.png"
			  }
													   HTTPMethod:@"POST"
												completionHandler:
			  ^(FBRequestConnection *connection, id result, NSError *error)
			  {
				  DLog(@"%@", result);
			  }];
		 }];
        
        [self addTestRowWithName:@"Post only an image"
					 description:@"Post a image to the user's wall"
				  executionBlock:
		 ^
		 {
             
             UIImage * tmpImg = [UIImage imageNamed:@"sample-2.jpg"];
             [FBRequestConnection startForUploadPhoto:tmpImg completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                   DLog(@"%@", result);
             }];
             
             
             
		 }];
}

@end
