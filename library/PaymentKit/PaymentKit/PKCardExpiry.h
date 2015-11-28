//
//  PKCardExpiry.h
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKCardExpiry : NSObject

@property (nonatomic, readonly) NSUInteger month;
@property (nonatomic, readonly) NSUInteger year;
@property (nonatomic, readonly) NSString *formattedString;
@property (nonatomic, readonly) NSString *formattedStringWithTrail;

+ (instancetype)cardExpiryWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithMonth:(NSString *)monthStr andYear:(NSString *)yearStr;

- (NSString *)formattedString;
- (NSString *)formattedStringWithTrail;
- (BOOL)isValid;
- (BOOL)isValidLength;
- (BOOL)isValidDate;
- (BOOL)isPartiallyValid;
- (NSUInteger)month;
- (NSUInteger)year;

@end
