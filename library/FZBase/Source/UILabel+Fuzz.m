//
//  UILabel+Fuzz.m
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//

#import "UILabel+Fuzz.h"
#import "UIView+Fuzz.h"
#import "NSObject+Fuzz.h"

#import <objc/runtime.h>

@implementation UILabel (Fuzz)

-(bool)isTruncated
{
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
	{
		CGSize constrainedSize = CGSizeMake(self.bounds.size.width, NSIntegerMax);
		CGRect tmpSize2 = [self.text boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
		[self setLineBreakMode:self.lineBreakMode];
		[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tmpSize2.size.height)];
		
		if (tmpSize2.size.height > self.bounds.size.height)
			return  YES;
		else
			return NO;
	}
	else
	{
// This is an obnoxious line that should be removed when we move to iOS 8.
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		CGSize perfectSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.bounds.size.width, NSIntegerMax) lineBreakMode:self.lineBreakMode];
		if (perfectSize.height > self.bounds.size.height)
			return YES;
		else
			return NO;
	}
}

-(void)sizeToFitMaxWidth:(int)inWidth
{
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    [self sizeToFitMaxWidth:inWidth andMaxLines:1];
}

-(void)sizeToFitMaxWidth:(int)inWidth andMaxLines:(int)inLines
{
    
    self.numberOfLines=1;
    [self sizeToFit];

    if(inLines == 1)
    {
        if(self.frame.size.width > inWidth)
            [self setSize:CGSizeMake(inWidth, self.frame.size.height)];
    }
    else
    {
        
        int H = self.frame.size.height;
        
        while((self.frame.size.width >= inWidth) && (self.numberOfLines <= inLines))
        {
            [self setSize:CGSizeMake(inWidth, self.numberOfLines*H)];
            self.numberOfLines++;
        }
    }
}


////////////////////////////////////////////////////////////////////////

- (void)sizeToFitSize:(CGSize)inSize
{
	if(CGSizeEqualToSize(inSize, CGSizeZero))
		inSize = self.frame.size;

/*
	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[style setLineBreakMode:NSLineBreakByWordWrapping];
	
	NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: style};
	[self drawInRect:rect withAttributes:attributes];
*/
	
/*
	CGSize tmpSize = [self.text sizeWithFont:self.font constrainedToSize:inSize lineBreakMode:self.lineBreakMode];
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, tmpSize.width, tmpSize.height)];
*/
	
	if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
	{
		CGRect tmpSize2 = [self.text boundingRectWithSize:inSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
		[self setLineBreakMode:self.lineBreakMode];
		[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, tmpSize2.size.width, tmpSize2.size.height)];
	}
	else
	{
		CGSize tmpSize = [self.text sizeWithFont:self.font constrainedToSize:inSize lineBreakMode:self.lineBreakMode];
		[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, tmpSize.width, tmpSize.height)];
	}

}




- (void)sizeToFitSizeMaintainWidth:(CGSize)inSize
{
	if(CGSizeEqualToSize(inSize, CGSizeZero))
		inSize = self.frame.size;
	
	CGFloat tmpwidth = self.frame.size.width;
	if(inSize.width > self.frame.size.width)
		tmpwidth = inSize.width;
	
	if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
	{
		CGRect tmpSize2 = [self.text boundingRectWithSize:inSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
		[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y,tmpwidth, tmpSize2.size.height)];
	}
	else
	{
		CGSize tmpSize = [self.text sizeWithFont:self.font constrainedToSize:inSize lineBreakMode:self.lineBreakMode];
		[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, tmpwidth, tmpSize.height)];
	}
}

- (void)sizeToFitSizeMaintainWidthIOS5:(CGSize)inSize
{
	CGSize tmpSize = [self.text sizeWithFont:self.font constrainedToSize:inSize lineBreakMode:NSLineBreakByWordWrapping];
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tmpSize.height)];
}

- (void)sizeToFitSizeMaintainWidthAndCenter:(CGSize)inSize
{
	CGPoint tmpCenter = self.center;
	
	if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
	{
		CGRect tmpSize2 = [self.text boundingRectWithSize:inSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
		[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tmpSize2.size.height)];
	}
	else
	{
		CGSize tmpSize = [self.text sizeWithFont:self.font constrainedToSize:inSize lineBreakMode:self.lineBreakMode];
		[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tmpSize.height)];
	}
	self.center = CGPointMake((int)tmpCenter.x, (int)tmpCenter.y);
}



-(void)addLabelStrikeThrough
{
    
	UIView * tmpView  =  [self getAssociatedObjectForKey:@"LabelStrikeThrough"];
    
    
    if(!tmpView)
    {
		
		tmpView = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetMidY(self.bounds)-3, CGRectGetWidth(self.bounds), 1)];
		[tmpView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
		[self addSubview:tmpView];
        [self setAssociatedObject:tmpView forKey:@"LabelStrikeThrough"];
	}
    
	[tmpView setFrame:CGRectMake( 0, CGRectGetMidY(self.bounds)-3, CGRectGetWidth(self.bounds), 1)];
	[tmpView setBackgroundColor: self.textColor];


}





-(void)removeLabelStrikeThrough
{
	
	UIView * tmpView  =[self getAssociatedObjectForKey:@"LabelStrikeThrough"];
	if(tmpView)
		[tmpView removeFromSuperview];
}

@end
