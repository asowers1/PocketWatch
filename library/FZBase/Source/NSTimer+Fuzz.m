//
//  NSTimer+Fuzz.m
//  Demo
//
//  Created by Sean Orelli on 12/22/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import "NSTimer+Fuzz.h"
#import "NSObject+Fuzz.h"

@interface FZAssociatedTimerHelper : NSObject
@property (copy) FZBlock block;
-(void)doBlock;
@end

@implementation FZAssociatedTimerHelper
-(void)doBlock
{
	if(self.block)
		self.block();
}
@end

@implementation NSTimer (Fuzz)

+(NSTimer*)timerWithTimeInterval:(NSTimeInterval)ti andBlock:(FZBlock)inBlock
{
	FZAssociatedTimerHelper *helper = [[FZAssociatedTimerHelper alloc] init];
	helper.block = inBlock;
	NSTimer *timer	=  [NSTimer scheduledTimerWithTimeInterval:ti target:helper selector:@selector(doBlock) userInfo:nil repeats:NO];
	[timer setAssociatedObject:helper forKey:@"FZTimerHelper"];
	return timer;
	
}

+(NSTimer*)timerRepeatWithTimeInterval:(NSTimeInterval)ti andBlock:(FZBlock)inBlock
{
	FZAssociatedTimerHelper *helper = [[FZAssociatedTimerHelper alloc] init];
	helper.block = inBlock;
	
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ti target:helper selector:@selector(doBlock) userInfo:nil repeats:YES];
	[timer setAssociatedObject:helper forKey:@"FZTimerHelper"];
	
	return timer;
}

@end