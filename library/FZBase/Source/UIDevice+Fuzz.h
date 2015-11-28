//
//  UIDevice+Fuzz.h
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//

#import <UIKit/UIKit.h>

@interface UIDevice (Fuzz)

+ (NSString*)uuid;
+ (NSString*)model;
+ (NSString*)system;
+ (CGFloat)systemVersion;
+ (NSString*)batteryState;

+ (BOOL)isIPad;
+ (BOOL)isIPhone;
+ (BOOL)isSimulated;
+ (BOOL)isPortraitOrientation;
+ (BOOL)isLandscapeOrientation;

+ (BOOL)hasPortraitInterface;
+ (BOOL)hasLandscapeInterface;
+ (BOOL)hasRetinaScreen;
+ (BOOL)hasTelephone;
+ (BOOL)hasSMS;
+ (BOOL)hasEmail;
+ (BOOL)hasMicrophone;
+ (BOOL)hasCamera;
+ (BOOL)hasGyroscope;
+ (BOOL)hasPhotoLibrary;

+ (void)logSystemValues;

//deprecated
+ (BOOL)has4InchScreen;
@end
