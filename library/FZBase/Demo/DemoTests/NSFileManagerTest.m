//
//  NSFileManagerTest.m
//  Demo
//
//  Created by Sean Orelli on 7/11/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Fuzz.h>
#import <NSFileManager+Fuzz.h>

@interface NSFileManagerTest : XCTestCase

@end

@implementation NSFileManagerTest

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


-(void)testFileManager
{
	// NSString *library = [NSFileManager libraryDirectoryPath];// stringByAppendingPathComponent:@"test.txt"];
	// [NSFileManager logContentsOfDirectoryAtPath:library];
}


@end
