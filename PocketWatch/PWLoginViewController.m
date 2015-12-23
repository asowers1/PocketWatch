//
//  PWLoginViewController.m
//  PocketWatch
//
//  Created by Andrew Sowers on 10/5/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

#import "PWLoginViewController.h"
#import "PocketAPI.h"
#import "PWPocketWrapper.h"
#import "MBProgressHUD.h"
#import "PocketWatch-Swift.h"

@interface PWLoginViewController () <PWPocketWrapperDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) PWPocketWrapper *pocketWrapper;
@end

@implementation PWLoginViewController
@synthesize hud;

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self determinLoginStatus];
  [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
  if ([[PocketAPI sharedAPI] isLoggedIn]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self proceedToNav];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)determinLoginStatus {
  NSLog(@"user: %@",[[PWUserController sharedController] user]);
}

-(void)setup{
  
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  
  self.pocketWrapper = [PWPocketWrapper sharedWrapper];
  self.pocketWrapper.delegate = self;
  
  
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
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)pocketLoginFinished:(NSNotification *)notification{
  // hide login loading UI here
  [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - actions

- (IBAction)loginTapped:(id)sender {
  [[PWPocketWrapper sharedWrapper] login];
}

#pragma mark - other

- (void)pocketDidLogin {
  NSLog(@"did login");
  [self proceedToNav];
}

#pragma mark - Navigation

- (void)proceedToNav {
  [self performSegueWithIdentifier:@"proceedToNav" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [MBProgressHUD hideHUDForView:self.view animated:YES];
}


@end
