//
//  NSMutableURLRequest+Fuzz.m
//  Pods
//
//  Created by Sean Orelli on 12/5/14.
//
//

#import "NSURLRequest+Fuzz.h"
#import "NSDictionary+Fuzz.h"

@implementation NSURLRequest (Fuzz)

static float timeOutInterval = 60.0;
+ (void)setTimeOutInterval:(float)interval
{
    timeOutInterval = interval;
}
+ (NSURLRequest*)requestWithURLString:(NSString*)inURLString method:(NSString*)inMethod query:(NSDictionary*)inParameters
{
    NSURL *url = [NSURL URLWithString:inURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:timeOutInterval];
    
    
    NSString *queryString = [inParameters urlQueryString];
    NSData *queryData = [queryString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:queryData];
    [request setHTTPMethod:inMethod];
    
    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[request setValue:@"" forHTTPHeaderField:@"Content-type"];
    return request;
}

@end