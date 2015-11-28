//
//  NSDateTest.m
//  Demo
//
//  Created by Sean Orelli on 7/11/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <NSDate+Fuzz.h>

@interface NSDateTest : XCTestCase

@end

@implementation NSDateTest

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


-(void)testNSDate
{
    NSString *format = @"yyyy-MM-dd";
	
    NSDate *now = [NSDate date];
    NSLog(@"%@", [now stringWithFormat:format]);
    NSLog(@"%@", [now stringWithDateStyle:NSDateFormatterFullStyle]);
    NSLog(@"%@", [now stringWithTimeStyle:NSDateFormatterShortStyle]);
	
    NSLog(@"hour:   %d", (int)[now hours]);
    NSLog(@"minute: %d", (int)[now minutes]);
	
    NSLog(@"day:    %d", (int)[now day]);
    NSLog(@"month:  %d", (int)[now month]);
    NSLog(@"year    %d", (int)[now year]);
	
	
    NSLog(@"day:    %@", [now dayShortString]);
    NSLog(@"day:    %@", [now dayString]);
    NSLog(@"month:  %@", [now monthShortString]);
    NSLog(@"month:  %@", [now monthString]);
    NSLog(@"time:  %@", [now timeString]);
	
    
    
    NSLog(@"seconds:    %@", now);
    NSLog(@"seconds:    %@", [now dateByAddingSeconds:20]);
    NSLog(@"minutes:    %@", [now dateByAddingMinutes:20]);
    NSLog(@"hours:  %@", [now dateByAddingHours:20]);
    NSLog(@"days:  %@", [now dateByAddingDays:20]);
    NSLog(@"weeks:  %@", [now dateByAddingWeeks:20]);
    NSLog(@"yearss:  %@", [now dateByAddingYears:20]);
	
	
    
    
    NSLog(@"seconds Since:  %d", (int)[[now dateByAddingMinutes:20] secondsSinceDate:now]);
    NSLog(@"minutes Since:  %d", (int)[[now dateByAddingHours:2] minuteSinceDate:now]);
    NSLog(@"hours Since:    %d", (int)[[now dateByAddingDays:9] hoursSinceDate:now]);
    NSLog(@"days Since:     %d", (int)[[now dateByAddingWeeks:4] daysSinceDate:now]);
    NSLog(@"weeks Since:    %d", (int)[[now dateByAddingYears:2] weeksSinceDate:now]);
    NSLog(@"yearss Since:   %d", (int)[[now dateByAddingDays:200] yearsSinceDate:now]);

	
}


@end
