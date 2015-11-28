//
//  FZAPISwitcher.m
//  FZDebugModuleDemo
//
//  Created by Sheng Jun Dong on 3/6/14.
//  Copyright (c) 2014 Strivr. All rights reserved.
//

#import "FZVariableSwitcher.h"
#import "FZVariableGroupViewController.h"

static NSString *FZVARFREEFORM  = @"FREEFORM";

@interface FZVariableSwitcher ()
@property (nonatomic, strong) NSMutableDictionary *varDict; // Deprecated
@property (nonatomic, strong) NSString *defaultAPIKey;
@property (nonatomic, strong) genericBlock callbackBlock;
@property (nonatomic, strong) NSMutableArray *groupArray;
@property (nonatomic, weak) id<FZVariableSwitcherDelegate> varDelegate;
@end


@implementation FZVariableSwitcher

+ (instancetype)shared
{
	static FZVariableSwitcher *_shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_shared = [[self alloc] init];
	});
	return _shared;
}

//Deprecated
+ (NSDictionary *)varDict
{
    return [[self shared] varDict];
}

- (void)setDelegate:(id<FZVariableSwitcherDelegate>)delegate {
    
}

//Deprecated
+ (void)setKey:(NSString *)key andVariableDict:(NSDictionary *)inDict
{
    [[[self shared] varDict] setValue:inDict forKey:key];
}

// Deprecated
+ (NSDictionary *)variableDictForKey:(NSString *)inKey
{
    return [[[self shared] varDict] valueForKey:inKey];
}


+ (NSArray *)groupRows {
    return [[self shared] groupArray];
}

+ (void)addRow:(FZVariableSwitcherGroup *)row {
    [[[self shared] groupArray] addObject:row];
}

+ (void)setRows:(NSArray *)rows {
    [[[self shared] groupArray] removeAllObjects];
    [[[self shared] groupArray] addObjectsFromArray:rows];
}


+ (void)setVariable:(NSString *)inVar forKey:(NSString *)inKey {
    [self setObject:inVar forKey:inKey];
}

+ (void)setArray:(NSArray *)inArray forKey:(NSString *)inKey {
    [self setObject:inArray forKey:inKey];
}

+ (void)setObject:(id)object forKey:(NSString *)key {
    [[[self shared] varDelegate] switcher_setObject:object forKey:key];
}

+ (NSString *)variableForKey:(NSString *)inKey {
    [self objectForKey:inKey];
}

+ (id)objectForKey:(NSString *)key {
    return [[[self shared] varDelegate] switcher_objectForKey:key];
}

+ (void)setVarDelegate:(id<FZVariableSwitcherDelegate>)delegate {
    [[self shared] setVarDelegate:delegate];
}

- (id<FZVariableSwitcherDelegate>)varDelegate {
    if (!_varDelegate) {
        _varDelegate = [[FZVariableSwitcherDefaultStore alloc] init];
    }
    return _varDelegate;
}

// Deprecated
+ (void)setCallbackBlock:(genericBlock)callback
{
    [[self shared] setCallbackBlock:callback];
}

+ (void)setCompletionBlock:(genericBlock)callback {
    [[self shared] setCallbackBlock:callback];
}

+ (void)executeCallback
{
    if ([[self shared] callbackBlock])
    {
        [[self shared] callbackBlock]();
    }
}

+ (UIViewController *)defaultVariablePicker
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIStoryboard *switcherSB = [UIStoryboard storyboardWithName:@"VariableSwitcher" bundle:bundle];

    UINavigationController *tmpNavController = [switcherSB instantiateInitialViewController];
    
    return tmpNavController;
}

#pragma mark - Instance method

- (NSMutableArray *)groupArray {
    if (!_groupArray) {
        _groupArray = [NSMutableArray array];
    }
    return _groupArray;
}

- (NSMutableDictionary *)varDict
{
    if (!_varDict) {
        _varDict = [NSMutableDictionary dictionary];
    }
    return _varDict;
}

@end


#pragma mark FZVariableSwitcherGroupRow

@implementation FZVariableSwitcherGroup

+ (instancetype)groupRowWithName:(NSString *)rowName key:(NSString *)key andOptions:(NSArray *)options {
    return [self groupRowWithName:rowName key:key type:FZVariableSwitcherGroupTypeUnsupported andOptions:options];
}

+ (instancetype)groupRowWithName:(NSString *)rowName key:(NSString *)key type:(FZVariableSwitcherGroupType)type andOptions:(NSArray *)options {
    FZVariableSwitcherGroup *row = [FZVariableSwitcherGroup new];
    row.groupName = rowName;
    row.groupKey = key;
    row.groupOptions = options;
    row.groupValueType = type;
    return row;
}

- (FZVariableSwitcherOption *)optionForCurrentKey {
    id value = [FZVariableSwitcher objectForKey:self.groupKey];
    for (FZVariableSwitcherOption *option in self.groupOptions) {
        if ([option.optionValue isEqual:value]) {
            return option;
        }
    }
    return nil;
}

- (NSArray *)groupOptions {
    if (!_groupOptions) {
        _groupOptions = @[];
    }
    return _groupOptions;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"groupName: %@, groupKey: %@, options:%@", self.groupName, self.groupKey, self.groupOptions];
}

@end


#pragma mark FZVariableSwitcherVariableOption

@implementation FZVariableSwitcherOption

+ (instancetype)optionWithName:(NSString *)optionName andValue:(id)value {
    FZVariableSwitcherOption *option = [FZVariableSwitcherOption new];
    option.optionName = optionName;
    option.optionValue = value;
    return option;
}

+ (instancetype)freeformOptionWithName:(NSString *)name {
    FZVariableSwitcherOption *option = [FZVariableSwitcherOption new];
    option.optionName = name;
    option.optionValue = FZVARFREEFORM;
    return option;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"optionName: %@, optionValue: %@", self.optionName, self.optionValue];
}

@end


#pragma mark - FZVariableSwitcherDefaultStore
// This uses User Default to persist the objects
@implementation FZVariableSwitcherDefaultStore

// implement switcher delegate method
- (id)switcher_objectForKey:(NSString *)inKey {
    return [self objectForKey:inKey];
}

- (void)switcher_setObject:(id)object forKey:(NSString *)key {
    [self setObject:object forKey:key];
}

// User default method
- (void)setObject:(id)obj forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:obj forKey:key];
    [userDefault synchronize];
}

- (id)objectForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
}

@end
