//
//  FZAPISwitcher.h
//  FZDebugModuleDemo
//
//  Created by Sheng Jun Dong on 3/6/14.
//  Copyright (c) 2014 Strivr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^genericBlock)(void);

@class FZVariableSwitcherGroup, FZVariableSwitcherOption;
@protocol FZVariableSwitcherDelegate;

@interface FZVariableSwitcher : NSObject

+ (NSMutableDictionary *)varDict;

// Initial setup
// Deprecated, use addRow: instead
+ (void)setKey:(NSString *)key andVariableDict:(NSDictionary *)inDict;
+ (NSDictionary *)variableDictForKey:(NSString *)inKey;

// Deprecated, use setCompletionBlock instead
+ (void)setCallbackBlock:(genericBlock)callback;


+ (NSArray *)groupRows;
+ (void)addRow:(FZVariableSwitcherGroup *)row;
+ (void)setRows:(NSArray *)rows;
+ (void)setCompletionBlock:(genericBlock)callback;
+ (void)executeCallback;


// Set Variable using User Default
// Decprecated
+ (void)setVariable:(NSString *)inVar forKey:(NSString *)inKey;
// Deprecated
+ (void)setArray:(NSArray *)inArray forKey:(NSString *)inKey;
+ (NSString *)variableForKey:(NSString *)key;


+ (id)objectForKey:(NSString *)key;
+ (void)setObject:(id)object forKey:(NSString *)key;

// Convinient getters and setters
+ (UIViewController *)defaultVariablePicker;

+ (void)setVarDelegate:(id<FZVariableSwitcherDelegate>)delegate;

@end

#pragma mark - FZVariableSwitcherDelegate
// TODO: need to implement this
@protocol FZVariableSwitcherDelegate <NSObject>
- (void)switcher_setObject:(id)object forKey:(NSString *)key;
- (id)switcher_objectForKey:(NSString *)inKey;
@end

typedef NS_ENUM(NSInteger, FZVariableSwitcherGroupType) {
    FZVariableSwitcherGroupTypeUnsupported = 0,
    FZVariableSwitcherGroupTypeString ,
    FZVariableSwitcherGroupTypeNumber,
    FZVariableSwitcherGroupTypeBoolean
};

#pragma mark - FZVariableSwitcherGroup

@interface FZVariableSwitcherGroup : NSObject
+ (instancetype)groupRowWithName:(NSString *)rowName key:(NSString *)key andOptions:(NSArray *)options;
// Setting a type allows you to to have a free form entry.
+ (instancetype)groupRowWithName:(NSString *)rowName key:(NSString *)key type:(FZVariableSwitcherGroupType)type andOptions:(NSArray *)options;
@property (nonatomic) NSString *groupName;
@property (nonatomic) NSString *groupKey;
@property (nonatomic) NSArray *groupOptions;
// Describes the type of options it should be. Utilize this for free form text option.
@property (nonatomic) FZVariableSwitcherGroupType groupValueType;
- (FZVariableSwitcherOption *)optionForCurrentKey;

@end

#pragma mark - FZVariableSwitcherOption

@interface FZVariableSwitcherOption : NSObject
+ (instancetype)optionWithName:(NSString *)optionName andValue:(id)value;
+ (instancetype)freeformOptionWithName:(NSString *)name;
@property (nonatomic) NSString *optionName;
@property (nonatomic) id optionValue;
@end


#pragma mark - FZVariableSwitcherDefaultStore
@interface FZVariableSwitcherDefaultStore : NSObject <FZVariableSwitcherDelegate>
@end