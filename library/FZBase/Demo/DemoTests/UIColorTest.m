//
//  UIColorTest.m
//  Demo
//
//  Created by Sean Orelli on 7/11/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Fuzz.h>
#import <UIColor+Fuzz.h>

@interface UIColorTest : XCTestCase

@end

@implementation UIColorTest

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



-(void)testUIColor
{
	
	/*
    UIColor *one = [UIColor orangeColor];
    DLog(@"%@", [one hexString]);
    NSString *tmp = @"45fa5588";
    UIColor *two = [UIColor colorFromHexString:tmp];
    DLog(@"%@", [two hexString]);
    DLog(@"%@", tmp);
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake( 100, 100, 100, 100)];
    tmpView.backgroundColor = [UIColor colorFromHexString:[one hexString]];
    
    [self.view addSubview:tmpView];
	
    UIView *tmpView2 = [[UIView alloc] initWithFrame:CGRectMake( 100, 210, 100, 100)];
    tmpView2.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:tmpView2];
	*/
}

@end
