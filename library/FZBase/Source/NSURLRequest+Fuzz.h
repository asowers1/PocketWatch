//
//  NSMutableURLRequest+Fuzz.h
//  Pods
//
//  Created by Sean Orelli on 12/5/14.
//
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (Fuzz)
+ (void)setTimeOutInterval:(float)interval;
+ (NSURLRequest*)requestWithURLString:(NSString*)inURLString method:(NSString*)inMethod query:(NSDictionary*)inParameters;
@end
