//
//  CMMotionManager+Fuzz.m
//  Pods
//
//  Created by Sean Orelli on 1/15/15.
//
//

#import "CMMotionManager+Fuzz.h"
#import "Fuzz.h"

@implementation CMMotionManager (Fuzz)

+(CMMotionManager*)shared
{
	static CMMotionManager *singleton = nil;
	Once(^
	{
		singleton = [[CMMotionManager alloc] init];
	});
	return singleton;
}

@end
