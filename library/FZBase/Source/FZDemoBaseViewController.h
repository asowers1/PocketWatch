//
//  FZDemoBaseViewController.h
//  DemoProject
//
//  Created by Nick Trienens on 2/25/14.
//  Copyright (c) 2014 com.fuzzproductions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fuzz.h"

@class FZDemoDataModel;

@interface FZDemoBaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) NSMutableArray * demoListingArray;

-(void)setupDemoData;
+(FZDemoDataModel*)aboutMe;

- (void)addTestRowWithName:(NSString *)inName description:(NSString *)inDescription executionBlock:(FZBlock)inExecutionBlock;

@end


@interface FZDemoDataModel : NSObject

@property(nonatomic, strong) NSString * title;
//@property(nonatomic, strong) NSString * description;
@property(nonatomic, strong) NSString * selectorName;
@property(nonatomic, copy)   FZBlock	actionBlock;

+(instancetype)demoMethodWithSelector:(NSString*)inSelector title:(NSString*)inTitle description:(NSString*)inDescription;
+(instancetype)demoMethodWithBlock:(FZBlock)inBlock title:(NSString*)inTitle description:(NSString*)inDescription;
@end