//
//  PWLoginViewController.m
//  PocketWatch
//
//  Created by Andrew Sowers on 10/5/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

#import "PWLoginViewController.h"
#import "PocketAPI.h"

@interface PWLoginViewController ()

@end

@implementation PWLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup{
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(pocketLoginStarted:)
                                               name:[NSString stringWithFormat:@"%@",PocketAPILoginStartedNotification]
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(pocketLoginFinished:)
                                               name:[NSString stringWithFormat:@"%@",PocketAPILoginFinishedNotification]
                                             object:nil];
}

-(void)pocketLoginStarted:(NSNotification *)notification{
  // present login loading UI here
}

-(void)pocketLoginFinished:(NSNotification *)notification{
  // hide login loading UI here
}

#pragma mark - actions

- (IBAction)loginTapped:(id)sender {
  [[PocketAPI sharedAPI] loginWithHandler: ^(PocketAPI *API, NSError *error){
    if (error != nil)
    {
      // There was an error when authorizing the user.
      // The most common error is that the user denied access to your application.
      // The error object will contain a human readable error message that you
      // should display to the user. Ex: Show an UIAlertView with the message
      // from error.localizedDescription
      
    }
    else
    {
      // The user logged in successfully, your app can now make requests.
      // [API username] will return the logged-in user’s username
      // and API.loggedIn will == YES
      
    }
  }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
