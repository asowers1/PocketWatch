//
//  NSBundle+Fuzz.h
//  FZBase
//
//  Created by Fuzz Productions on 12/5/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fuzz.h"

#define ELog(error) [NSError log:error withMessage:[NSString stringWithFormat:@"Function:%s Line:%d", __PRETTY_FUNCTION__, __LINE__]]

typedef void (^FZBlockWithErrorAndMessage)(NSError *inError, NSString *message);

@interface NSError (Fuzz)

+ (void)log:(NSError*)inError;

+ (void)log:(NSError*)inError withMessage:(NSString*)inMessage;

+ (void)setErrorHandlingBlock:(FZBlockWithErrorAndMessage)inError;

@end
