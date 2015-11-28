//
//  UITextView+Fuzz.m
//  FZBase
//
//  Created by Noah Blake on 7/22/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import "UITextView+Fuzz.h"

@implementation UITextView (Fuzz)

- (CGFloat)textViewContentHeight
{
	if (self.attributedText.length)
	{
		return [self heightOfAttributedTextView];
	}
	else
	{
		return [self heightOfPlainTextView];
	}
}

- (CGFloat)heightOfPlainTextView
{
	CGFloat tmpWidthAdjustment =  self.textContainerInset.left + self.textContainerInset.right + self.textContainer.lineFragmentPadding * 2.0f;
	CGFloat tmpHeightAdjustment = self.textContainerInset.bottom + self.textContainerInset.top;
	
	// Unfortunately, a textView with a sole newline character does not size to two lines
	NSMutableString *tmpSizingString = [self.text mutableCopy];
	if ([tmpSizingString hasSuffix:@"\n"])
	{
		[tmpSizingString appendString:@"a"];
	}
	NSDictionary *tmpAttributes = self.font ? @{NSFontAttributeName : self.font} : nil;
	CGFloat tmpHeightTextRequires = ceil([tmpSizingString boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame) - tmpWidthAdjustment, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tmpAttributes context:nil].size.height) + tmpHeightAdjustment;
	return tmpHeightTextRequires;
}

- (CGFloat)heightOfAttributedTextView
{
	CGFloat tmpWidthAdjustment =  self.textContainerInset.left + self.textContainerInset.right + self.textContainer.lineFragmentPadding * 2.0f;
	CGFloat tmpHeightAdjustment = self.textContainerInset.bottom + self.textContainerInset.top;
	
	// Unfortunately, a textView with a sole newline character does not size to two lines
	NSMutableAttributedString *tmpSizingString = [self.attributedText mutableCopy];
	if ([self.attributedText.string hasSuffix:@"\n"])
	{
		[tmpSizingString replaceCharactersInRange:NSMakeRange(self.attributedText.length - 1, 1) withString:@"\na"];
	}
	CGFloat tmpHeightTextRequires = ceil([tmpSizingString boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame) - tmpWidthAdjustment, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height) + tmpHeightAdjustment;
	return tmpHeightTextRequires;
}

- (NSInteger)numberOfLines
{
	CGFloat tmpHeight = self.textViewContentHeight - self.textContainerInset.top - self.textContainerInset.bottom;
	return round(tmpHeight / self.font.lineHeight);
}
@end
