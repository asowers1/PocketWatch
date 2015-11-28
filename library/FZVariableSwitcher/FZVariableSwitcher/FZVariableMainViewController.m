//
//  FZVariableMainViewController.m
//  example
//
//  Created by Sheng Jun Dong on 3/7/14.
//  Copyright (c) 2014 Fuzz. All rights reserved.
//

#import "FZVariableMainViewController.h"
#import "FZVariableSwitcher.h"
#import "FZVariableCell.h"
#import "FZVariableGroupViewController.h"

@interface FZVariableMainViewController ()

@property (nonatomic, strong) NSArray *groupRows;

// Deprecated
@property (nonatomic, strong) NSDictionary *varDict;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FZVariableSwitcherGroup *selectedRow;
@end

@implementation FZVariableMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed)];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable)];
    
    self.navigationItem.rightBarButtonItems = @[refreshButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshTable];
}

- (void)refreshTable {
    self.groupRows = [FZVariableSwitcher groupRows];
    [self.tableView reloadData];
}

#pragma mark TableView Delegate and Datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groupRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FZVariableCell *tmpCell = [tableView dequeueReusableCellWithIdentifier:@"VariableMainCell"];
    FZVariableSwitcherGroup *group = [self.groupRows objectAtIndex:indexPath.row];
    
    FZVariableSwitcherOption *option = [group optionForCurrentKey];
    
    NSString *keyText = group.groupName;
    NSString *valueText;
    if (option) {
        valueText = [NSString stringWithFormat:@"%@: %@", option.optionName, option.optionValue];
    } else {
        // Option doesn't exist, but is there actually a value?
        id value = [FZVariableSwitcher objectForKey:group.groupKey];
        if (value) {
            if (group.groupValueType == FZVariableSwitcherGroupTypeBoolean) {
                BOOL val_bool = [(NSNumber *)value boolValue];
                valueText = [NSString stringWithFormat:@"Custom Value: %@",  val_bool? @"YES" : @"NO"];
            } else {
                valueText = [NSString stringWithFormat:@"Custom Value: %@",  value];
            }
        } else {
            valueText = @"Not yet specify";
        }
        
    }
    
    tmpCell.keyLabel.text = keyText;
    tmpCell.valueLabel.text = valueText;
    return tmpCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = [self.groupRows objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier: @"GoToGroupMainController" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToGroupMainController"]) {
        FZVariableGroupViewController *tmpVC = segue.destinationViewController;
        tmpVC.group = self.selectedRow;
    }
}

#pragma mark - button actions
- (void)donePressed {
    [FZVariableSwitcher executeCallback];
    [self dismiss];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
