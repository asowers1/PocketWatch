//
//  UIColor+Fuzz.h
//
//  Created by Fuzz Productions on 11/6/13.

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIColor (Fuzz)



+ (UIColor*)colorFromHexString:(NSString*)hex;
- (NSString*)hexString;

@end
