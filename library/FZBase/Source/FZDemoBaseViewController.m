//
//  FZDemoBaseViewController.m
//  DemoProject
//
//  Created by Nick Trienens on 2/25/14.
//  Copyright (c) 2014 com.fuzzproductions. All rights reserved.
//

#import "FZDemoBaseViewController.h"
#import "UIDevice+Fuzz.h"

@interface FZDemoBaseViewController ()

@end

@implementation FZDemoBaseViewController

+(FZDemoDataModel*)aboutMe{
	return [FZDemoDataModel demoMethodWithSelector:nil title:@"Unknown Controller" description:@"Got Nothing"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	CGRect tmpFrame = self.view.bounds;
	if([UIDevice systemVersion] >=7) {
		self.edgesForExtendedLayout=UIRectEdgeNone;
		self.extendedLayoutIncludesOpaqueBars=NO;
		self.automaticallyAdjustsScrollViewInsets=NO;
		
		if( self.navigationController == nil){
			tmpFrame.size.height -= 20;
			tmpFrame.origin.y = 20;
		}
	}
	
	
	self.tableView = [[UITableView alloc] initWithFrame:tmpFrame];
	[self.tableView setBackgroundColor:[UIColor whiteColor]];
	[self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.view addSubview:self.tableView];

	[self.view setBackgroundColor:[UIColor whiteColor]];

	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self setupDemoData];
	[self.tableView reloadData];
	
}




- (void)addTestRowWithName:(NSString *)inName description:(NSString *)inDescription executionBlock:(FZBlock)inExecutionBlock{
	
	if(	self.demoListingArray == nil ) {
		self.demoListingArray = [NSMutableArray array];
	}
		
	[self.demoListingArray addObject:[FZDemoDataModel demoMethodWithBlock:inExecutionBlock title:inName description:inDescription]];
	
}


-(void)setupDemoData{
	
	self.demoListingArray = [NSMutableArray array];
	[self.demoListingArray addObject:[FZDemoDataModel demoMethodWithSelector:nil title:@"No Demos Defined" description:@"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."]];
	
	
	
}


#pragma mark -
#pragma mark UITableView datasource functions

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UIFont* tmpFont = [UIFont systemFontOfSize:16];
	FZDemoDataModel *tmpOption = self.demoListingArray[indexPath.row];
	
	CGFloat tmpHeight = 10;
	CGSize tmpSize = CGSizeZero;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
		tmpSize = [(NSString*)tmpOption.title boundingRectWithSize:CGSizeMake(300, 640)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: tmpFont} context:nil].size;
#else
		tmpSize = [(NSString*)tmpOption.title sizeWithFont:tmpFont constrainedToSize:CGSizeMake(300, 640) lineBreakMode:NSLineBreakByWordWrapping];
#endif
	
	tmpHeight += tmpSize.height;
	
	
	tmpFont = [UIFont systemFontOfSize:13];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
		tmpSize = [(NSString*)tmpOption.description boundingRectWithSize:CGSizeMake(300, 5660)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: tmpFont} context:nil].size;
#else
	tmpSize = [(NSString*)tmpOption.description sizeWithFont:tmpFont constrainedToSize:CGSizeMake(300, 5640) lineBreakMode:NSLineBreakByWordWrapping];
#endif
	
	tmpHeight += tmpSize.height;
	
	return tmpHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	FZDemoDataModel *tmpOption = self.demoListingArray[indexPath.row];
	if(tmpOption.selectorName != nil){
		SEL tmpSlector = NSSelectorFromString(tmpOption.selectorName);
		if([self respondsToSelector:tmpSlector]){
			#pragma clang diagnostic push
			#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
				[self performSelector:tmpSlector];
			#pragma clang diagnostic pop		
		}
	}
	if(tmpOption.actionBlock){
		tmpOption.actionBlock();
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return  [self.demoListingArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *const cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *tmpCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!tmpCell)
	{
		tmpCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] ;
		tmpCell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	FZDemoDataModel *tmpOption = self.demoListingArray[indexPath.row];
	
	[[tmpCell textLabel] setText:tmpOption.title];
	[[tmpCell detailTextLabel] setText:tmpOption.description];
	[[tmpCell detailTextLabel] setNumberOfLines:0];
	[[tmpCell detailTextLabel] setFont:[UIFont systemFontOfSize:13]];
	
	[[tmpCell textLabel] setFont:[UIFont systemFontOfSize:15]];
	
	return tmpCell;
}


@end

@implementation FZDemoDataModel

+(instancetype)demoMethodWithSelector:(NSString*)inSelector title:(NSString*)inTitle description:(NSString*)inDescription{
	
	FZDemoDataModel* newDemo = [[self alloc] init];
	
	newDemo.selectorName = inSelector;
	newDemo.title = inTitle;
	//newDemo.description = inDescription;
	
	return newDemo;
	
}

+(instancetype)demoMethodWithBlock:(FZBlock)inBlock title:(NSString*)inTitle description:(NSString*)inDescription{
	FZDemoDataModel* newDemo = [[self alloc] init];

	newDemo.actionBlock	= inBlock;
	newDemo.title = inTitle;
	//newDemo.description = inDescription;

	return newDemo;

}

-(void)dealloc{
	
	self.actionBlock	= nil;
	self.title = nil;
	//self.description = nil;
	self.selectorName = nil;
	
}

@end
