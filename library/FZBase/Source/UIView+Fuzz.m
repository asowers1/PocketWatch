//
//  UIView+Fuzz.m
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//

#import "UIView+Fuzz.h"
#import "NSObject+Fuzz.h"

@implementation UIView (Fuzz)

- (void)addShadow
{
    self.layer.shadowColor   = [UIColor blackColor].CGColor;
    
    CGPathRef tmp = CGPathCreateWithRect(CGRectMake(0, 0, self.width, self.height),nil);
    self.layer.shadowPath    = tmp;
    CFRelease(tmp);
    
    self.layer.shadowOffset  = CGSizeMake(0.0,1.0);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius  = 2;
}

- (void)addOutline
{
    //outline
    self.layer.borderWidth   = 1;
    self.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = 2;
    
}

- (void)roundCorners:(float)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = radius;
}

- (void)roundSelectedCorners:(UIRectCorner)inCorners withRadius:(CGFloat)radius
{

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:inCorners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/*
 iOS 7+ provides native support (-snapshotViewAfterScreenUpdates:)
 */
- (UIImage*)snapshot
{
		
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (void)setOrigin:(CGPoint)inOrigin
{
	[self setFrame:CGRectMake(inOrigin.x, inOrigin.y, self.frame.size.width, self.frame.size.height)];
}

- (void)setSize:(CGSize)inSize
{
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, inSize.width, inSize.height)];
}

- (void)setX:(CGFloat)inX
{
    self.frame = CGRectMake(inX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(CGFloat)inY
{
    self.frame = CGRectMake(self.frame.origin.x, inY, self.frame.size.width, self.frame.size.height);
}

- (void)setWidth:(CGFloat)inW
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, inW, self.frame.size.height);
}

- (void)setHeight:(CGFloat)inH
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, inH);
}

- (void)setCenterX:(CGFloat)inX
{
	self.center = CGPointMake(inX, self.center.y);
}

- (void)setCenterY:(CGFloat)inY
{
	self.center = CGPointMake(self.center.x, inY);
}

/************/
/* Getters  */
/************/

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(CGFloat)width
{
    return self.frame.size.width;
}


-(CGFloat)height
{
    return self.frame.size.height;
}


-(CGFloat)maxX
{
	return CGRectGetMaxX(self.frame);
}


-(CGFloat)maxY
{
	return CGRectGetMaxY(self.frame);
}


#define FZ_UIVIEW_MASK_KEY @"FZ_UIVIEW_MASK_BEZIER_PATH"
-(UIBezierPath*)mask
{
    return (UIBezierPath*)[self getAssociatedObjectForKey:FZ_UIVIEW_MASK_KEY];
}
-(void)setMask:(UIBezierPath*)inBezierPath
{
    [self setAssociatedObject:inBezierPath forKey:FZ_UIVIEW_MASK_KEY];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, self.width, self.height);
    maskLayer.path = inBezierPath.CGPath;
    self.layer.mask = maskLayer;
	//[maskLayer release];
    
}

- (void)show:(CGFloat)inSeconds
{
	[UIView animateWithDuration:inSeconds animations:^{self.alpha = 1;}];
}


- (void)hide:(CGFloat)inSeconds
{
	[UIView animateWithDuration:inSeconds animations:^{self.alpha = 0;}];
}

#pragma mark - PDF Generation
- (NSData *)PDFData
{
	// Drawn from SO: http://stackoverflow.com/questions/5443166/how-to-convert-uiview-to-pdf-within-ios
	NSMutableData *rtnPDFData = [NSMutableData data];
	
	// Directs contents of graphical context to be written to the returned data object
	UIGraphicsBeginPDFContextToData(rtnPDFData, self.bounds, nil);
	UIGraphicsBeginPDFPage();
	CGContextRef tmpPDFContext = UIGraphicsGetCurrentContext();
	
	// Rendering layer triggers the data-write
	[self.layer renderInContext:tmpPDFContext];
	
	// Remove PDF rendering context
	UIGraphicsEndPDFContext();
	
	return rtnPDFData;
}


@end

#pragma mark - CGRect Geometry
CGRect CGRectAddPoint(CGRect inRect, CGPoint inPoint){
    
    inRect.origin.x += inPoint.x;
    inRect.origin.y += inPoint.y;
    return inRect;
    
}

CGRect CGRectSubPoint(CGRect inRect, CGPoint inPoint){
    
    inRect.origin.x -= inPoint.x;
    inRect.origin.y -= inPoint.y;
    return inRect;
    
}

CGPoint CGPointAddPoint(CGPoint inPoint1, CGPoint inPoint2){
    
    inPoint1.x += inPoint2.x;
    inPoint1.y += inPoint2.y;
    return inPoint1;
    
}
CGPoint CGPointSubPoint(CGPoint inPoint1, CGPoint inPoint2){
    
    inPoint1.x -= inPoint2.x;
    inPoint1.y -= inPoint2.y;
    return inPoint1;
    
}


CGSize CGSizeConstrainSizeToMaxWidth(CGSize largeSize, CGFloat maxWidth){
    CGFloat newWidth = largeSize.width;
    CGFloat newHeight = largeSize.height;
    
    
    if(newWidth > maxWidth) {
        CGFloat aspectRatio = newHeight / newWidth;
        
        newWidth = maxWidth;
        newHeight = maxWidth * aspectRatio;
    }
    
    return CGSizeMake(newWidth, newHeight);
}

CGSize CGSizeCeil(CGSize largeSize){
    return CGSizeMake(ceil(largeSize.width) , ceil(largeSize.height) );
}



