//
//  Fuzz.h
//
//  Created by Fuzz Productions on 11/6/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#ifndef Fuzz_h
#define Fuzz_h
#import <UIKit/UIKit.h>


#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#	define DMem( s, ... ) NSLog( @"<%s : (%d) [Memory: %d]> %@",__FUNCTION__, __LINE__,[Global getFreeMemory], [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#	define DLog(...)
#	define DMem(...)
#endif


#define WeakSelf __weak __typeof(self)
#define BlockSelf __block __typeof(self)

//convenience macro for loope, it is lowercase to match the for statement it replaces
#define repeat(x) for(int fuzz_repeating_index = 0; fuzz_repeating_index<x; fuzz_repeating_index++)

//convencience method for using a dispatch_once block
#define Once(x) {static dispatch_once_t onceToken; dispatch_once(&onceToken,x);}

//Common Block type defs
typedef void (^FZBlock)(void);
typedef void (^FZBlockWithObject)(id inObject);
typedef void (^FZBlockWithDictionary)(NSDictionary *inDictionary);
typedef void (^FZBlockWithNotification)(NSNotification *inNotification);
typedef void (^FZBlockWithBool)(BOOL inBool);
typedef void (^FZBlockWithError)(NSError *inError);
typedef void (^FZBlockWithException)(NSException *inException);
typedef void (^FZBlockWithArray)(NSArray *inArray);
typedef void (^FZBlockWithBoolAndError)(BOOL inBool, NSError *inError);
typedef void (^FZBlockWithBoolErrorAndObject)(BOOL inBool, NSError *inError, id inObject);
typedef void (^FZBlockWithFloat)(CGFloat inFloat);


/**
 *  Returns true if the pointer is pointing to a valid object Tests against nil, NULL, 0, and NSNull. Depending on the
 *  compiler and langugage, nil and NULL may be identically defined, and probaly as pointers to 0. There are sublte
 *  differences between each, for example, messages can be sent to nil but not to NULL. Each test for these constants
 *  is provided for completness and platform compatability.
 *
 *  @param inObj an object pointer
 *
 *  @return YES if the object is valid
 */
extern bool exists(id inObj);


/**
 *  Run a block on the background queue
 *  Here the "background" refers to a
 *  global queue off the main thread
 *	not necessarily the "background queue"
 *  which is reserved for the lowest priortiy
 *  events
 *  @param inBlock the block to run
 */
extern void background(FZBlock inBlock);


/**
 *  Run a block on the main queue
 *
 *  @param inBlock the block to run
 */
extern void mainQueue(FZBlock inBlock);


/**
 *  Run a block after waiting the given number of seconds
 *
 *  @param seconds the time to wait
 *  @param FZBlock the block to execute
 */
extern void delay(double seconds, FZBlock);


/**
 *  Swap two methods of a class. This should never be used with a sytem class
 *  or any other class where the implementation is unknown. This should be called 
 *  early in the application lifecycle, preferably in the classes static method
 *  +(void)load, which is called before the application's main()
 *  Swizzling allows overriding category functions and calling the previous code
 *
 *  @param class  the class to be changed
 *  @param isClassmethod  YES if a class method, No if for instances
 *  @param originalMethod the older impementation
 *  @param newMethod the replacement implementation
 *
 *  @return succes or failure
 */
extern BOOL swizzle(Class class, BOOL isClassMethod, SEL originalSelector, SEL newSelector);

#endif
