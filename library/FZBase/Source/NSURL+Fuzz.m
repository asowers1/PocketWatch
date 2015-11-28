//
//  NSURL+Fuzz.m
//  FZBase
//
//  Created by Fuzz Productions on 2/18/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "NSURL+Fuzz.h"
#import "NSFileManager+Fuzz.h"

@implementation NSURL (Fuzz)
-(BOOL)isDirectoryURL
{
	if ([self isFileURL])
		if([NSFileManager directoryExistsAtPath:self.path])
			return YES;
	return NO;
}
@end
