//
//  FZDDebugModuleCustomAction.h
//  Wegmans
//
//  Created by Rajiev Timal on 1/8/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FZBase/Fuzz.h>

@interface FZDebugModuleCustomCommand : NSObject

@property (nonatomic, strong) NSString *commandName;

- (id)initWithName:(NSString *)name andExecutionBlock:(FZBlock)executionBlock;
- (void)execute;


@end
