//
//  PWPocketWrapper.m
//  PocketWatch
//
//  Created by Andrew Sowers on 11/22/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

#import "PWPocketWrapper.h"
#import "PocketAPI.h"

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
                                                 NSLog(@"%@",response);
                                             }
                                         }];
        }
    }];

}

@end
