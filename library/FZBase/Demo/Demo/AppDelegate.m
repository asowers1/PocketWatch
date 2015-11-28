//
//  AppDelegate.m
//  Demo
//
//  Created by Sean Orelli on 5/27/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import "AppDelegate.h"
#import <NSObject+Fuzz.h>
#import <NSURLSession+Fuzz.h>

@interface MyView : UIView
@end

@implementation MyView
-(void)dealloc
{
 
    
}
@end

@implementation AppDelegate





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    __block UIView *A = [UIView new];
    
    
    MyView *B = [MyView new];

    
    [self observeObject:A forKeyPath:@"backgroundColor" withBlock:^(NSDictionary *inDictionary)
    {
        NSLog(@"???");
        [self stopObservingObject:A forKeyPath:@"backgroundColor"];
    }];
    

    [self observeObject:B forKeyPath:@"backgroundColor" withBlock:^(NSDictionary *inDictionary)
     {
         NSLog(@"!!!");
         [self stopObservingObjectKeyPaths];
     }];

    [A observeNotification:@"N1" withBlock:^(NSNotification *inNotification)
    {
        NSLog(@" 111");
        [A stopObservingNotifications];
    }];
    
    [A observeNotification:@"N2" withBlock:^(NSNotification *inNotification)
    {
        NSLog(@" 111111");
        [A stopObservingNotification:@"N2"];
    }];
    
    [B observeNotification:@"N2" withBlock:^(NSNotification *inNotification)
    {
        NSLog(@" 222");
//        [B stopObservingNotification:@"N2"];
    }];

    
    A.backgroundColor = [UIColor redColor];
    B.backgroundColor = [UIColor redColor];
    B = nil;
    
    [A logNotifications];
    [self logObservations];
    
    [self sendNotification:@"N1"];
    [self sendNotification:@"N2"];

    delay(1, ^{
        [self sendNotification:@"N1"];
        [self sendNotification:@"N2"];

    });

    return YES;

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
