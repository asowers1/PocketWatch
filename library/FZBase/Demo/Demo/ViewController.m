//
//  ViewController.m
//  Demo
//
//  Created by Sean Orelli on 5/27/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import "ViewController.h"
#import "NSURLSessionDemoController.h"

#import <Fuzz.h>
#import <UITableView+Fuzz.h>
#import <UICollectionView+Fuzz.h>


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"FZBase";
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)setupDemo
{
	[super setupDemo];
    
    WeakSelf me = self;
	[self addTestRowWithName:@"NSURLSession" description:@"test NSURLSession" executionBlock:^
	{
        NSURLSessionDemoController *controller = [[NSURLSessionDemoController alloc] init];
        [me.navigationController pushViewController:controller animated:YES];
	}];
	[self addTestRowWithName:@"TableView Test" description:@"ez fz table views" executionBlock:^
	 {
		 UIViewController *controller = [UIViewController new];
		 
		 UITableView *table = [[UITableView alloc] initWithFrame:controller.view.bounds style:UITableViewStylePlain];
		 [controller.view addSubview:table];
		 [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"?"];
		 
		 [table numberOfRowsBlock:^NSInteger(NSInteger section)
		 {
			 return 3;
		 }];

		 [table cellForRowBlock:^UITableViewCell *(NSIndexPath *indexPath)
		 {
			  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"?"];
			  cell.textLabel.text = [NSString stringWithFormat:@"---%d", (int)indexPath.row];
			  return cell;
		  }];

		 [me.navigationController pushViewController:controller animated:YES];

		[table reloadData];
	
	 }];
	
	[self addTestRowWithName:@"Collection Test" description:@"ez fz collection views" executionBlock:^
	 {
		 UIViewController *controller = [UIViewController new];
		 [me.navigationController pushViewController:controller animated:YES];
		 
		 UICollectionView *collection = [[UICollectionView alloc] initWithFrame:controller.view.bounds collectionViewLayout:nil];
		 [controller.view addSubview:collection];
		 
		 
		 
		 
	 }];

	
}





@end
