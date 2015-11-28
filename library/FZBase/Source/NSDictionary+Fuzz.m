//
//  NSDictionary+Fuzz.m
//  Pods
//
//  Created by Sean Orelli on 12/5/14.
//
//

#import "NSDictionary+Fuzz.h"
#import "NSString+Fuzz.h"
@implementation NSDictionary (Fuzz)

- (NSString *)urlQueryString
{
    NSMutableArray *pairs = NSMutableArray.array;
    for (NSString *key in self.keyEnumerator)
    {
        id value = self[key];
        
        if ([value isKindOfClass:[NSDictionary class]])
        {
            for (NSString *subKey in value)
            {
                NSString *tmpValue = [[value objectForKey:subKey] urlEncodedString];
                [pairs addObject:[NSString stringWithFormat:@"%@[%@]=%@", key, subKey, tmpValue]];
            }
        }
        else
            if ([value isKindOfClass:[NSArray class]])
            {
                for (NSString *subValue in value)
                {
                    NSString *tmpValue = [subValue urlEncodedString];
                    [pairs addObject:[NSString stringWithFormat:@"%@[]=%@", key, tmpValue]];
                }
            }
            else
            {
                NSString *tmpValue = [value urlEncodedString];
                [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, tmpValue]];
            }
        
    }
    return [pairs componentsJoinedByString:@"&"];
}

-(NSString*)localizedStringValueForKey:(NSString*)inKey{
    //
    if (inKey == nil) {
        return nil;
    }
    
    NSString * tmpReturnValue = nil;
    
    NSLocale * tmpLocal = [NSLocale currentLocale];
    NSString * tmpLocalID  = [[tmpLocal localeIdentifier] lowercaseString];
    
    NSString * tmpLocalizedKey = [inKey stringByAppendingString:@"_localized"];
    NSDictionary * tmpLocalValues = [self valueForKey:tmpLocalizedKey];
    if([tmpLocalValues isKindOfClass:[NSMutableDictionary class]]){
        
        tmpReturnValue  = tmpLocalValues[tmpLocalID];
        if(tmpReturnValue == nil){
            if( [tmpLocalID length] > 2){
                tmpLocalID = [tmpLocalID substringToIndex:2];
                tmpReturnValue  = tmpLocalValues[tmpLocalID];
            }
        }
    }
    
    if(tmpReturnValue == nil){
        tmpReturnValue = [self valueForKey:inKey];
    }
    
    return tmpReturnValue;
}
@end
