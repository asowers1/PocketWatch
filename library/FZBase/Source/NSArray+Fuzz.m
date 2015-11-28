//
//  NSArray+Fuzz.m
//  Credly
//
//  Created by Fuzz Productions on 11/6/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import "NSArray+Fuzz.h"

@implementation NSArray (Fuzz)

-(id)objectAt:(NSInteger)index
{
    if(index>=0)
    if(index<self.count)
        return [self objectAtIndex:index];
    
    return nil;
}



- (NSArray *)reversedArray
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
	NSEnumerator *enumerator = [self reverseObjectEnumerator];
	
	for (id element in enumerator)
	{
		[array addObject:element];
	}
	return array;
}



- (NSArray *)sortArrayOfStringsAlphabetically
{
    NSArray *sortedArray;
    sortedArray = [self sortedArrayUsingComparator:^(id a, id b)
				   {
					   NSString *firstString  = a;
					   NSString *secondString = b;
                       
					   return [firstString compare:secondString];
				   }];
	return sortedArray;
}



@end
