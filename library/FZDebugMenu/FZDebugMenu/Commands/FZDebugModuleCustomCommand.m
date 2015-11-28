//
//  FZDDebugModuleCustomAction.m
//  Wegmans
//
//  Created by Rajiev Timal on 1/8/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "FZDebugModuleCustomCommand.h"

@interface FZDebugModuleCustomCommand()

@property (nonatomic, strong) FZBlock executionBlock;

@end

@implementation FZDebugModuleCustomCommand

- (id)initWithName:(NSString *)name andExecutionBlock:(FZBlock)executionBlock
{
	self = [super init];
	if(self)
	{
		_executionBlock = executionBlock;
		_commandName = name;
	}
	return self;
}

- (void)execute {
    if (self.executionBlock) {
        self.executionBlock();
    }
}

@end
