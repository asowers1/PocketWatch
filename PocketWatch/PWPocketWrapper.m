//
//  PWPocketWrapper.m
//  PocketWatch
//
//  Created by Andrew Sowers on 11/22/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

#import "PWPocketWrapper.h"
#import "PocketAPI.h"
#import "PocketWatch-Swift.h"

@implementation PWPocketWrapper

#pragma mark Singleton Methods

+ (id)sharedWrapper {
    static PWPocketWrapper *sharedWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWrapper = [[self alloc] init];
    });
    return sharedWrapper;
}


- (void)login {
    [[PocketAPI sharedAPI] loginWithHandler: ^(PocketAPI *API, NSError *error) {
        if (error != nil) {
            
        } else {
            [self.delegate pocketDidLogin];
        }
    }];
}

- (void)getPocketData {
  NSString *apiMethod = @"get";
  PocketAPIHTTPMethod httpMethod = PocketAPIHTTPMethodGET; // usually PocketAPIHTTPMethodPOST
  NSDictionary *arguments = nil;
  
  [[PocketAPI sharedAPI] callAPIMethod:apiMethod
                        withHTTPMethod:httpMethod
                             arguments:arguments
                               handler: ^(PocketAPI *api, NSString *apiMethod,
                                          NSDictionary *response, NSError *error){
                                 // handle the response here
                                 if (error) {
                                   NSLog(@"error: %@",error.localizedDescription);
                                 } else {
                                   // save models
                                   [self saveModelToDefaultRealm:response];
                                   [self.delegate pocketDidGetData];
                                 }
                               }];
}

- (void)saveModelToDefaultRealm:(NSDictionary *)data {
  //NSLog(@"data: %@",data);
  for (NSString * item_id in data[@"list"]) {
    for (NSDictionary *item in data[@"list"][item_id]) {
      NSLog(@"data for %@: %@: %@",item_id, item, data[@"list"][item_id][item]);
    }
  }
  [self.delegate pocketDidSaveData];
}

@end
