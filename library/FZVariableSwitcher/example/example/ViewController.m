//
//  ViewController.m
//  example
//
//  Created by Sheng Jun Dong on 3/6/14.
//  Copyright (c) 2014 Fuzz. All rights reserved.
//

#import "ViewController.h"
#import <FZVariableSwitcher/FZVariableSwitcher.h>

static NSString *MY_APP_API_KEY = @"Network API";
static NSString *MY_APP_TIMER_KEY = @"MY_APP_TIMER_KEY";
static NSString *ANALYTIC_API_KEY = @"com.wegmans.debugBaseURLOverride";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *varName1;
@property (weak, nonatomic) IBOutlet UILabel *varValue1;
@property (weak, nonatomic) IBOutlet UILabel *varName2;
@property (weak, nonatomic) IBOutlet UILabel *varValue2;
@property (weak, nonatomic) IBOutlet UILabel *varName3;
@property (weak, nonatomic) IBOutlet UILabel *varValue3;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Var Switcher Demo";
    [self updateLabel];
	// Do any additional setup after loading the view, typically from a nib.
    
    FZVariableSwitcherOption *appDevUrl = [FZVariableSwitcherOption optionWithName:@"Development" andValue:@"https://apidev.yourapp.com"];
    FZVariableSwitcherOption *appStagingUrl = [FZVariableSwitcherOption optionWithName:@"Staging" andValue:@"https://apistaging.yourapp.com"];
    FZVariableSwitcherOption *appProductionUrl = [FZVariableSwitcherOption optionWithName:@"Production" andValue:@"https://apiprod.yourapp.com"];
    NSArray *appOptions = @[appDevUrl, appStagingUrl, appProductionUrl];
    
    FZVariableSwitcherGroup *appRow = [FZVariableSwitcherGroup groupRowWithName:@"App API" key:MY_APP_API_KEY andOptions:appOptions];
    [FZVariableSwitcher addRow:appRow];
    
    
    FZVariableSwitcherOption *analyticDevUrl = [FZVariableSwitcherOption optionWithName:@"Development" andValue:@"https://apidev.yourapp.com"];
    FZVariableSwitcherOption *analyticStagingUrl = [FZVariableSwitcherOption optionWithName:@"Staging" andValue:@"https://apistaging.yourapp.com"];
    FZVariableSwitcherOption *analyticProductionUrl = [FZVariableSwitcherOption optionWithName:@"Production" andValue:@"https://apiprod.yourapp.com"];
    NSArray *analyticOptions = @[analyticDevUrl, analyticStagingUrl, analyticProductionUrl];
    
    FZVariableSwitcherGroup *analyticRow = [FZVariableSwitcherGroup groupRowWithName:@"Analytics API" key:ANALYTIC_API_KEY andOptions:analyticOptions];
    analyticRow.groupValueType = FZVariableSwitcherGroupTypeString;
    [FZVariableSwitcher addRow:analyticRow];
    
    
    NSInteger minutes = 45 * 60;
    FZVariableSwitcherOption *timerDefaultOption = [FZVariableSwitcherOption optionWithName:@"Default 45 Minute" andValue:@(minutes)];
    FZVariableSwitcherGroup *timerRow = [FZVariableSwitcherGroup groupRowWithName:@"Timer Time in second" key:MY_APP_TIMER_KEY type:FZVariableSwitcherGroupTypeNumber andOptions:@[timerDefaultOption]];
    [FZVariableSwitcher addRow:timerRow];
    
    
    [FZVariableSwitcher setCompletionBlock:^{
        [self updateLabel];
    }];
}

- (void)updateLabel {
    [self.varName1 setText:@"My App API"];
    NSString *api = [FZVariableSwitcher objectForKey:MY_APP_API_KEY];
    NSString *apiValueText = api? api : @"Value is not set";
    [self.varValue1 setText:apiValueText];
    
    [self.varName2 setText:@"My Analytic API with free form field"];
    NSString *analyticAPI = [FZVariableSwitcher objectForKey:ANALYTIC_API_KEY];
    NSString *analyticValueText = analyticAPI? analyticAPI : @"Value is not set";
    [self.varValue2 setText:analyticValueText];
    
    [self.varName3 setText:@"My Timer Time"];
    NSNumber *number = [FZVariableSwitcher objectForKey:MY_APP_TIMER_KEY];
    NSString *numberValueText = number? [NSString stringWithFormat:@"%@", number] : @"Value is not set";
    [self.varValue3 setText:numberValueText];
}
- (IBAction)pickerButtonPressed:(id)sender {
    [self openAPIPicker];
}

- (void)openAPIPicker {
    [self presentViewController:[FZVariableSwitcher defaultVariablePicker] animated:YES completion:nil];
}

@end
