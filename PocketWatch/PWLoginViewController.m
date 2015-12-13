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
    [self determinLoginStatus];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)determinLoginStatus {
    NSLog(@"user: %@",[[PWUserController sharedController] user]);
}

-(void)setup{
  
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

- (void)pocketDidLogin {
  NSLog(@"did login");
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
