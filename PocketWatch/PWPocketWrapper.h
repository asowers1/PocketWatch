//
//  PWPocketWrapper.h
//  PocketWatch
//
//  Created by Andrew Sowers on 11/22/15.
//  Copyright © 2015 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PocketWatch-Swift.h"


@protocol PWPocketWrapperDelegate <NSObject>
- (void)pocketDidLogin;

@end

@interface PWPocketWrapper : NSObject
@property (weak, nonatomic) id<PWPocketWrapperDelegate> delegate;
+ (id)sharedWrapper;
- (void)login;


@end
