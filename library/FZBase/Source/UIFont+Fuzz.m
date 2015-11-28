//
//  UIFont+Fuzz.m
//  BuzzBack
//
//  Created by Fuzz Productions on 11/6/13.
//  Copyright (c) 2013 Sobits. All rights reserved.
//

#import "UIFont+Fuzz.h"
#import "Fuzz.h"

static NSMutableDictionary *_fontCacheDictionary = nil;

@implementation UIFont (Fuzz)
+(void)logFontNames
{
    NSArray *tmpFontFamily = [UIFont familyNames];
    for(NSString *f in tmpFontFamily)
    {
        DLog(@"%@", @" ");
        DLog(@"Family:%@", f);
        DLog(@"%@", @" ");
        NSArray *tmpFontNames = [UIFont fontNamesForFamilyName:f];
        for(__unused NSString *k in tmpFontNames)
            DLog(@"     %@", k);
    }
}

#pragma mark -
#pragma mark Font caching
+ (UIFont *)cachedFontNamed:(NSString *)inFont atSize:(CGFloat)inFontSize
{
	if (!_fontCacheDictionary)
        _fontCacheDictionary = [NSMutableDictionary dictionary];
	
	NSString *tmpFontCacheKey = [NSString stringWithFormat:@"%@_%f",inFont,inFontSize];
	UIFont *rtnCachedFont = [_fontCacheDictionary objectForKey:tmpFontCacheKey];
    if(rtnCachedFont)
		return rtnCachedFont;
	else
	{
		rtnCachedFont = [UIFont fontWithName:inFont size:inFontSize];
		[_fontCacheDictionary setObject:rtnCachedFont forKey:tmpFontCacheKey];
		return rtnCachedFont;
	}
}

#pragma mark
#pragma mark - Dynamic fonts
#ifdef __IPHONE_7_0
+ (UIFont *)preferredFontNamed:(NSString *)inFontName withBaseFontSize:(CGFloat)inFontSize
{
	
	NSRange tmpRange = NSMakeRange(MAX(4.0f, inFontSize - 6.0f), 22.0f);
	CGFloat tmpFontSize = [UIFont preferredFontSizeWithRange:tmpRange];
	
	return [self cachedFontNamed:inFontName atSize:tmpFontSize];
}

+ (CGFloat)preferredFontSizeWithRange:(NSRange)inRange
{
	CGFloat tmpFontSize = 0.0f;
	NSString *tmpContentSize = [UIApplication sharedApplication].preferredContentSizeCategory;
	
	CGFloat tmpIncrement = inRange.length / 11.0f;
	
	// Font size resolution
	if ([tmpContentSize isEqualToString:UIContentSizeCategoryExtraSmall])
		tmpFontSize = inRange.location;
	else if ([tmpContentSize isEqualToString:UIContentSizeCategorySmall])
		tmpFontSize = round(inRange.location + tmpIncrement);
	else if ([tmpContentSize isEqualToString:UIContentSizeCategoryMedium])
		tmpFontSize = round(inRange.location + tmpIncrement * 2.0f);
	else if ([tmpContentSize isEqualToString:UIContentSizeCategoryLarge])
		tmpFontSize = round(inRange.location + tmpIncrement * 3.0f);
	else if ([tmpContentSize isEqualToString:UIContentSizeCategoryExtraLarge])
		tmpFontSize = round(inRange.location + tmpIncrement * 4.0f);
	else if ([tmpContentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge])
		tmpFontSize = round(inRange.location + tmpIncrement * 5.0f);
	else if ([tmpContentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge])
		tmpFontSize = round(inRange.location + tmpIncrement * 6.0f);
	else if ([tmpContentSize isEqualToString:UIContentSizeCategoryAccessibilityMedium])
		tmpFontSize = round(inRange.location + tmpIncrement * 7.0f);
	else if ([tmpContentSize isEqualToString:UIContentSizeCategoryAccessibilityLarge])
		tmpFontSize = round(inRange.location + tmpIncrement * 8.0f);
	else if ([tmpContentSize isEqualToString:UIContentSizeCategoryAccessibilityExtraLarge])
		tmpFontSize = round(inRange.location + tmpIncrement * 9.0f);
	else if ([tmpContentSize isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraLarge])
		tmpFontSize = round(inRange.location + tmpIncrement * 10.0f);
	else if ([tmpContentSize isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge])
		tmpFontSize = round(inRange.location + tmpIncrement * 11.0f);
	
	return tmpFontSize;
}
#endif
@end
