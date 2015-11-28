//
//  UIFont+Fuzz.h
//  BuzzBack
//
//  Created by Fuzz Productions on 11/6/13.
//  Copyright (c) 2013 Sobits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Fuzz)
+ (void)logFontNames;

#ifdef __IPHONE_7_0
+ (UIFont *)preferredFontNamed:(NSString *)inFont withBaseFontSize:(CGFloat)inFontSize;
+ (UIFont *)cachedFontNamed:(NSString *)inFont atSize:(CGFloat)inFontSize;
#endif
@end
