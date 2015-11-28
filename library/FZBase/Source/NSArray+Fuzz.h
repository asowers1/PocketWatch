//
//  NSArray+Fuzz.h
//  Credly
//
//  Created by Fuzz Productions on 11/6/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import <Foundation/Foundation.h>


// ARC_YES


@interface NSArray (Fuzz)


/**
 *  This will check if the given index is within the bounds of the array.
 *  If it is, it will return the object at the index, otherwise it will 
 *  return nil. This is safer than NSArray objectAtIndex which will crash
 *  given an index outside of the bounds
 *
 *  @param index the index of the object
 *
 *  @return The object at the given index
 */
- (id)objectAt:(NSInteger)index;


/**
 *  This will create a new array with the same contents in reverse order
 *  This also serves as a code example of array enumeration.
 *  @return the new array
 */
- (NSArray *)reversedArray;


/**
 *  This will arrange the contents alphabetically, given they are all strings.
 *  This also serves as a code example of sorting by comparison block
 *
 *  @return a new array sorted alphabetically
 */
- (NSArray *)sortArrayOfStringsAlphabetically;

@end
