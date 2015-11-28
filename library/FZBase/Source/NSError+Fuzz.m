//
//  NSBundle+Fuzz.m
//  FZBase
//
//  Created by Fuzz Productions on 12/5/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import "NSError+Fuzz.h"
#import "Fuzz.h"

@implementation NSError (Fuzz)

static FZBlockWithErrorAndMessage errorReportingBlock = nil;

+ (void)setErrorHandlingBlock:(FZBlockWithErrorAndMessage)inError
{
	errorReportingBlock = [inError copy];
}

+ (void)log:(NSError*)inError
{
	[NSError log:inError withMessage:@""];
}

+ (void)log:(NSError*)inError withMessage:(NSString*)inMessage;
{
	if(inError)
	{
		if([inError isKindOfClass:[NSError class]])
		{
#ifdef DEBUG
			NSLog(@"Error: %@",inMessage);
			NSLog(@"%@",inError);
#endif
			if(errorReportingBlock)
				errorReportingBlock(inError, inMessage);
		}
	}
}

@end
