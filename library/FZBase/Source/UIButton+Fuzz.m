//
//  UIButton+Fuzz.m
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//

#import "UIButton+Fuzz.h"
#import "UIImage+Fuzz.h"
#import "Fuzz.h"
#import <objc/runtime.h>

@implementation UIButton (Fuzz)

-(NSMutableArray*)associatedBlocksArray
{
    NSMutableArray *blocksArray = (NSMutableArray*)objc_getAssociatedObject(self, @selector(associatedBlocksArray));
    if(blocksArray == nil)
    {
        blocksArray = [NSMutableArray array];
        objc_setAssociatedObject(self, @selector(associatedBlocksArray), blocksArray, OBJC_ASSOCIATION_RETAIN);
    }
    return blocksArray;
}

-(void)addButtonPressBlock:(FZBlock)inBlock
{
	[self addTarget:self action:@selector(respondToButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [[self associatedBlocksArray] addObject:[inBlock copy]];
}

-(void)setButtonPressBlock:(FZBlock)inBlock
{
	[[self associatedBlocksArray] removeAllObjects];
	[self addButtonPressBlock:inBlock];
}


-(void)respondToButtonPress
{
    for(FZBlock block in [self associatedBlocksArray])
        block();
}



-(void)setColor:(UIColor *)inColor forState:(UIControlState)state
{
	[self setBackgroundImage:[UIImage imageWithColor:inColor] forState:state];
}


@end
