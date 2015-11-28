//
//  NSData+Fuzz.m
//  Pods
//
//  Created by Sean Orelli on 12/5/14.
//
//

#import "NSData+Fuzz.h"
#import "NSError+Fuzz.h"
@implementation NSData (Fuzz)
-(id)jsonValue
{
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    ELog( error );
    return json;
}
@end
