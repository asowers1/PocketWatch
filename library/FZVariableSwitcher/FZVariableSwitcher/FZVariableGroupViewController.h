//
//  FZDAPIPickerViewController.h
//  FZDebugModuleDemo
//
//  Created by Sheng Jun Dong on 3/6/14.
//  Copyright (c) 2014 Strivr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZVariableSwitcher.h"

@interface FZVariableGroupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FZVariableSwitcherGroup *group;

@end
