//
//  NSStringTest.m
//  Demo
//
//  Created by Sean Orelli on 7/11/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import <XCTest/XCTest.h>


#import <NSString+Fuzz.h>
#import <Fuzz.h>

@interface NSStringTest : XCTestCase

@end

@implementation NSStringTest

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



-(void)testNSString
{

    //for(int i=0; i<255; i++)
    //  DLog(@"%d: %@", i, [NSString stringWithFormat:@"%c", (char)i]);
    NSString *myEmail = @"sean@fuzzproductions.com";
	
    if([myEmail isEmailAddress])
        DLog(@"EMAIL!: %@", myEmail);
    else
		XCTFail(@"not email!: %@ \"%s\"", myEmail, __PRETTY_FUNCTION__);

    DLog(@"%@", [myEmail base64]);
    DLog(@"%@", [myEmail md5]);
    DLog(@"%@", [myEmail urlEncodedString]);
    
    NSString *fred = @"fred";
    NSString *sean = @"sean";
    
    if([myEmail hasPrefix:fred])
        DLog(@"begins With: %@", fred);
    else
        DLog(@"not begins with!: %@", fred);
	
    if([myEmail hasPrefix:sean])
        DLog(@"begins With: %@", sean);
    else
        DLog(@"not begin with!: %@", sean);

}


@end
