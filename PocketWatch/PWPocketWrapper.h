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

@interface PWPocketWrapper : MKAnnotationView

+ (id)sharedWrapper;
- (void)login;

@end
