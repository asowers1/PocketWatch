//
//  Fuzz.m
//  FZBase
//
//  Created by Fuzz Productions on 11/19/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#include <stdio.h>
#import "Fuzz.h"
#import <sys/utsname.h>
#import <objc/runtime.h>

bool exists(id inObj)
{
    if(inObj == nil)
        return NO;
    
    if(inObj == NULL)
        return NO;
    
    if(inObj == 0)
        return NO;
    
    if( ((NSNull*)inObj) == [NSNull null])
        return NO;
    
    return YES;
}






void background(FZBlock inBlock)
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^
				   {
					   inBlock();
				   });
	
}

void mainQueue(FZBlock inBlock)
{
	dispatch_async(dispatch_get_main_queue(),^
				   {
					   inBlock();
				   });
	
}

void delay(double seconds, FZBlock inBlock)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
				   {
					   inBlock();
				   });
	
}





BOOL swizzle(Class class, BOOL isClassMethod, SEL originalSelector, SEL newSelector)
{
	
	if(isClassMethod)
	{
		Class metaClass = object_getClass(class);
		if (!metaClass || metaClass == class) // the metaClass being the same as class shows that class was already a MetaClass
		{
			NSString *reason = [NSString stringWithFormat:@"%@ does not have a meta class to swizzle methods on!", NSStringFromClass(class)];
			@throw [NSException exceptionWithName:@"Invalid Swizzle" reason:reason userInfo:nil];
		}
		class = metaClass;
	}
	
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    if(!newMethod)	@throw [NSException exceptionWithName:@"Invalid Swizzle" reason:@"error, source mothed does not exist" userInfo:nil];
	
	
	IMP newIMP = method_getImplementation(newMethod);
    if(class_addMethod(class, originalSelector, newIMP, method_getTypeEncoding(newMethod)))
        class_replaceMethod(class, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    else
        method_exchangeImplementations(originalMethod, newMethod);
	
    return (method_getImplementation(newMethod) == method_getImplementation(class_getInstanceMethod(class, originalSelector)));
}



