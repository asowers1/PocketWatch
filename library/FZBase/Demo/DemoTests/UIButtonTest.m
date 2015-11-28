//
//  UIButtonTest.m
//  Demo
//
//  Created by Sean Orelli on 7/11/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import <XCTest/XCTest.h>


#import <UIButton+Fuzz.h>

@interface UIButtonTest : XCTestCase

@end

@implementation UIButtonTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


-(void)testUIButton
{
	
	/*
    UIButton *tmp = [UIButton buttonWithType:UIButtonTypeCustom];
    tmp.backgroundColor = [UIColor redColor];
    tmp.frame = CGRectMake(100, 100, 100, 100);
    [tmp setTitle:@"Press me" forState:UIControlStateNormal];
    [self.view addSubview:tmp];
    
    
    [tmp addButtonPressBlock:^
	 {
        DLog(@"one");
    }];
    
    
    [tmp addButtonPressBlock:^
	 {
        DLog(@"two");
    }];
	
    
    [tmp addButtonPressBlock:^
	 {
        DLog(@"three");
    }];
	*/
}
@end
