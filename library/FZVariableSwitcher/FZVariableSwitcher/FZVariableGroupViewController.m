//
//  FZDAPIPickerViewController.m
//  FZDebugModuleDemo
//
//  Created by Sheng Jun Dong on 3/6/14.
//  Copyright (c) 2014 Strivr. All rights reserved.
//

#import "FZVariableGroupViewController.h"
#import "FZVariableSwitcher.h"
#import "FZVariableCell.h"
#import "FZAlertView.h"

static NSString *CUSTOM_VALUE_NAME = @"Custom Value";

@interface FZVariableGroupViewController ()

 // Used to query for api Dict
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *optionArray;

@property (nonatomic, strong) UIBarButtonItem *plusButton;
@end

@implementation FZVariableGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.group.groupName;
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadOptions)];
    
    NSMutableArray *rightButtons = [NSMutableArray array];
    [rightButtons addObject:refreshButton];
    
    if (self.group.groupValueType != FZVariableSwitcherGroupTypeUnsupported) {
        self.plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCustomValue)];
        [rightButtons addObject:self.plusButton];
    }
    
    self.navigationItem.rightBarButtonItems = rightButtons;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadOptions];
}

- (void)reloadOptions {
    NSMutableArray *optionArray = [self.group.groupOptions mutableCopy];

    // Add a option if current value exists, but is not one of the default.
    if (self.group.groupValueType != FZVariableSwitcherGroupTypeUnsupported) {
        id value = [FZVariableSwitcher objectForKey:self.group.groupKey];
        if (value) {
            FZVariableSwitcherOption *customOption = [self.group optionForCurrentKey];
            if (!customOption) {
                // No option exist, create a custom option field
                customOption = [self createOptionWithValue:value];
                [optionArray addObject:customOption];
            }
        }
    }
    self.optionArray = optionArray;
    [self.tableView reloadData];
    
    [self markCurrentOptionSelected];
}

- (FZVariableSwitcherOption *)createOptionWithValue:(id)value {
    FZVariableSwitcherOption *customOption = [FZVariableSwitcherOption optionWithName:CUSTOM_VALUE_NAME andValue:value];
    return customOption;
}

- (void)addCustomValue {
    
    if (self.group.groupValueType == FZVariableSwitcherGroupTypeBoolean) {
        FZAlertViewActionObject *cancelAction = [FZAlertViewActionObject alertViewActionObjectWithName:@"Cancel" block:nil];
        FZAlertViewActionObject *yesAction = [FZAlertViewActionObject alertViewActionObjectWithName:@"YES" block:^(){
            FZVariableSwitcherOption *option = [self createOptionWithValue:@(YES)];
            [self selectOptionAndDismiss:option];
        }];
        FZAlertViewActionObject *noAction = [FZAlertViewActionObject alertViewActionObjectWithName:@"NO" block:^(){
            FZVariableSwitcherOption *option = [self createOptionWithValue:@(NO)];
            [self selectOptionAndDismiss:option];
        }];
        NSArray *actions = @[yesAction, noAction, cancelAction];
        [FZAlertView showAlertViewWithStyle:UIAlertViewStyleDefault title:@"Select Value" message:nil actionObjectArray:actions];
        
    } else {
        [FZAlertView showAlertViewWithStyle:UIAlertViewStylePlainTextInput title:@"Enter Value" message:nil closeButtonTitle:@"Cancel" acceptButtonTitle:@"Apply" closeBlock:nil acceptBlock:^(NSString *inString) {
            if (self.group.groupValueType == FZVariableSwitcherGroupTypeString) {
                if ([inString isEqualToString:@""]) {
                    [FZAlertView showAlertViewWithTitle:@"Error" message:@"value can't be empty"];
                } else {
                    FZVariableSwitcherOption *option = [self createOptionWithValue:inString];
                    [self selectOptionAndDismiss:option];
                }
            } else if (self.group.groupValueType == FZVariableSwitcherGroupTypeNumber) {
                if (![inString isEqualToString:@""]) {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    NSNumber *number = [formatter numberFromString:inString];
                    if (number) {
                        FZVariableSwitcherOption *option = [self createOptionWithValue:number];
                        [self selectOptionAndDismiss:option];
                    } else {
                        [FZAlertView showAlertViewWithTitle:@"Error" message:@"entered value is not a number"];
                    }
                } else {
                    [FZAlertView showAlertViewWithTitle:@"Error" message:@"value can't be empty"];
                }
            }
        }];
    }
    
}

- (void)selectOptionAndDismiss:(FZVariableSwitcherOption *)option {
    [FZVariableSwitcher setObject:option.optionValue forKey:self.group.groupKey];
    [self dismiss];
}

- (void)markCurrentOptionSelected {
    FZVariableSwitcherOption *currentOption;
    id value = [FZVariableSwitcher objectForKey:self.group.groupKey];
    for (FZVariableSwitcherOption *option in self.optionArray) {
        if ([option.optionValue isEqual:value]) {
            currentOption = option;
            break;
        }
    }
    
    if (currentOption) {
        NSInteger index = [self.optionArray indexOfObject:currentOption];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)done
{
    [self dismiss];
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TableView Delegate and Datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.optionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZVariableCell *tmpCell = [tableView dequeueReusableCellWithIdentifier:@"VariableGroupCell"];
	
    FZVariableSwitcherOption *option = [self.optionArray objectAtIndex:indexPath.row];
    tmpCell.keyLabel.text = option.optionName;
    if (self.group.groupValueType == FZVariableSwitcherGroupTypeString) {
        tmpCell.valueLabel.text = option.optionValue;
    } else {
        if (self.group.groupValueType == FZVariableSwitcherGroupTypeBoolean) {
            NSNumber *number = option.optionValue;
            tmpCell.valueLabel.text = [number boolValue]? @"YES" : @"NO";
        } else {
            tmpCell.valueLabel.text = [NSString stringWithFormat:@"%@", option.optionValue];
        }
    }
    
    return tmpCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FZVariableSwitcherOption *option = [self.optionArray objectAtIndex:indexPath.row];
    [self selectOptionAndDismiss:option];
}

@end
