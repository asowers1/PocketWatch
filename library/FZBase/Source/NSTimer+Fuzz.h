//
//  NSTimer+Fuzz.h
//  Demo
//
//  Created by Sean Orelli on 12/22/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fuzz.h"
@interface NSTimer (Fuzz)
+(NSTimer*)timerWithTimeInterval:(NSTimeInterval)ti andBlock:(FZBlock)inBlock;
+(NSTimer*)timerRepeatWithTimeInterval:(NSTimeInterval)ti andBlock:(FZBlock)inBlock;
@end
