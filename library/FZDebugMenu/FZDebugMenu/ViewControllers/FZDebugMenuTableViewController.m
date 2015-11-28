//
//  FZDebugMenuTableViewController.m
//  FuzzDebugMenu
//
//  Created by Sheng Dong on 3/24/15.
//
//

#import "FZDebugMenuTableViewController.h"
#import "FZDebugMenu.h"
#import "FZDebugModuleCustomCommand.h"

@interface FZDebugMenuTableViewController ()

@property (nonatomic, strong) NSArray *commandList;

@end

@implementation FZDebugMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    [self setTitle:@"Fuzz Debug Menu"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateData];
}

- (void)updateData {
    self.commandList = [FZDebugMenu customCommands];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commandList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const debugMenuCellIdentifier = @"debugMenuCellIdentifier";
    UITableViewCell *tmpCell = [tableView dequeueReusableCellWithIdentifier:debugMenuCellIdentifier];
    
    if (!tmpCell) {
        tmpCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:debugMenuCellIdentifier];
    }
    
    FZDebugModuleCustomCommand *customCommand = [self.commandList objectAtIndex:indexPath.row];
    [tmpCell.textLabel setText:[customCommand commandName]];
    
    return tmpCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FZDebugModuleCustomCommand *selectedCommand = [self.commandList objectAtIndex:indexPath.row];
    [selectedCommand execute];
}

@end
