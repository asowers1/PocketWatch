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
#import "RLMRealm.h"

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
  NSDictionary *arguments = @{@"state":@"all", @"detailType":@"complete"};
  
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
                                   [self.delegate pocketDidGetData];
                                   
                                   [self saveModelToDefaultRealm:response];
                                   
                                 }
                               }];
}

- (void)saveModelToDefaultRealm:(NSDictionary *)data {
  NSLog(@"data: %@",data);
  [[PWObjectController sharedController] deleteObjects];
  [[PWImageController sharedController] deleteObjects];
  [[PWVideoController sharedController] deleteObjects];
  
  PWObjectController *objectController = [PWObjectController sharedController];
  for (NSString * item_id in data[@"list"]) {
    if ([(NSString *)data[@"list"][item_id][@"has_image"] intValue] >= 1) {
      for (NSDictionary *imageData in data[@"list"][item_id][@"images"]) {
        PWImage *imageObject = [[PWImageController sharedController] getNewImage];
        for (id item in imageData) {
          if ([item isMemberOfClass:[NSString class]]) {
            if ([PWImage respondsToSelector:NSSelectorFromString(item)]) {
              [imageObject setValue:data[@"list"][item_id][item] forKey:item];
            }
          }
        }
        [[PWImageController sharedController] addObject:imageObject];
      }
    }
    if ([(NSString *)data[@"list"][item_id][@"has_video"] intValue] >= 1) {
      for (NSDictionary *videoData in data[@"list"][item_id][@"videos"]) {
        PWVideo *videoObject = [[PWVideoController sharedController] getNewVideo];
        for (id item in videoData) {
          if ([item isMemberOfClass:[NSString class]]) {
            if ([PWVideo respondsToSelector:NSSelectorFromString(item)]) {
              [videoObject setValue:data[@"list"][item_id][item] forKey:item];
            }
          }
        }
        [[PWVideoController sharedController] addObject:videoObject];
      }
    }
    PWObject *savedObject = [objectController getNewObject];
    for (id item in data[@"list"][item_id]) {
      if ([item isMemberOfClass:[NSString class]]) {
        if ([savedObject respondsToSelector:NSSelectorFromString(item)]) {
          [savedObject setValue:data[@"list"][item_id][item] forKey:item];
          [objectController addObject:savedObject];
        }
      }
    }
    [[PWObjectController sharedController] addObject:savedObject];
    
  }
  
  [self.delegate pocketDidSaveData];
}

@end
