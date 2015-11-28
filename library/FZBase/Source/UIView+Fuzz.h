//
//  UIView+Fuzz.h
//  
//
//  Created by Fuzz Productions on 11/6/13.
////  Copyright (c) 2014 Fuzz Productions. All rights reserved.

//
#import <UIKit/UIKit.h>

/*________________________________________________
 
                UIView + Fuzz
________________________________________________*/
@interface UIView (Fuzz)

- (void)setSize:(CGSize)inSize;
- (void)setOrigin:(CGPoint)inOrigin;

- (void)setX:(CGFloat)inX;
- (void)setY:(CGFloat)inY;
- (void)setWidth:(CGFloat)inW;
- (void)setHeight:(CGFloat)inH;

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)maxX;
- (CGFloat)maxY;

- (void)roundCorners:(float)radius;
- (void)roundSelectedCorners:(UIRectCorner)inCorners withRadius:(CGFloat)radius;

- (UIBezierPath*)mask;
- (void)setMask:(UIBezierPath*)inBezierPath;

- (void)show:(CGFloat)inSeconds;
- (void)hide:(CGFloat)inSeconds;

- (UIImage*)snapshot;
/**
 * @description Renders the current context of the view, buffering its contents into the returned NSData as a PDF.
 * @return A PDF of the receiver.
 *
 */
- (NSData *)PDFData;

@end

/*________________________________________________
 
 CGRectGeometry functions
 ________________________________________________*/
CGRect CGRectAddPoint(CGRect inRect, CGPoint inPoint);
CGRect CGRectSubPoint(CGRect inRect, CGPoint inPoint);

CGPoint CGPointAddPoint(CGPoint inPoint1, CGPoint inPoint2);
CGPoint CGPointSubPoint(CGPoint inPoint1, CGPoint inPoint2);

CGSize CGSizeConstrainSizeToMaxWidth(CGSize largeSize, CGFloat maxWidth);
CGSize CGSizeCeil(CGSize largeSize);
