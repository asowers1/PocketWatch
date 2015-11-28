//
//  NSBundle+Fuzz.m
//  FZBase
//
//  Created by Fuzz Productions on 12/5/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import "NSBundle+Fuzz.h"

@implementation NSBundle (Fuzz)

+(NSString*)version
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}


@end
