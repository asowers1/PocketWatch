//
//  UIViewTest.m
//  Demo
//
//  Created by Sean Orelli on 7/11/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIView+Fuzz.h>


@interface UIViewTest : XCTestCase

@end

@implementation UIViewTest

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



-(void)testUIView
{

	/*
    UIView *tmp = [[UIView alloc] initWithFrame:CGRectZero];
    tmp.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:tmp];
    [tmp setSize:CGSizeMake(100, 100)];
    [tmp setOrigin:CGPointMake(50, 20)];
    
    
    UIView *tmp2 = [[UIView alloc] initWithFrame:CGRectZero];
    tmp2.backgroundColor = [UIColor redColor];
    [self.view addSubview:tmp2];
    tmp2.frame = tmp.frame;
    
    tmp2.x += tmp.width/2;
    tmp2.y += tmp.height/2;
    
    UIView *tmp3 = [[UIView alloc] initWithFrame:CGRectZero];
    tmp3.backgroundColor = [UIColor greenColor];
    [self.view addSubview:tmp3];
	
    tmp3.width = tmp2.width;
    tmp3.height = tmp2.height;
    tmp3.x = tmp.maxX;
    tmp3.y = tmp2.maxY;
    
    
    
    UIImage *tmpImage =[self.view snapshot];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:tmpImage];
    [self.view addSubview:imageView];
    [imageView setOrigin:CGPointMake(0, tmp3.maxY+10)];
    
    
    self.view.backgroundColor = [UIColor grayColor];
	
    */
	
}


@end
