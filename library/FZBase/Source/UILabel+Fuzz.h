//
//  UILabel+Fuzz.h
//  
//
//  Created by Fuzz Productions on 11/6/13.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Fuzz)

- (bool)isTruncated;

- (void)sizeToFitMaxWidth:(int)inWidth;
- (void)sizeToFitMaxWidth:(int)inWidth andMaxLines:(int)inLines;

- (void)sizeToFitSize:(CGSize)inSize;
- (void)sizeToFitSizeMaintainWidth:(CGSize)inSize;
- (void)sizeToFitSizeMaintainWidthAndCenter:(CGSize)inSize;

- (void)addLabelStrikeThrough;
- (void)removeLabelStrikeThrough;


@end
