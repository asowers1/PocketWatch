//
//  NSObjectTest.m
//  Demo
//
//  Created by Sean Orelli on 7/11/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import  <Fuzz.h>
#import  <NSObject+Fuzz.h>
#import  <NSString+Fuzz.h>

@interface FZBaseTestObject : NSObject
@property NSString *name;
@end

@implementation FZBaseTestObject
@end


@interface NSObjectTest : XCTestCase

@end

@implementation NSObjectTest

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


- (void)testIntrospection
{
	
}

static NSMutableArray *receivedSelectorNotifications = nil;
static NSObject *expectedObject;
-(void)objectWasNotified:(NSNotification*)inNotification
{
	
	DLog(@"Notification recevied with selector: %@", inNotification.name);
	
	
	[receivedSelectorNotifications addObject:inNotification.name];
	if(inNotification.object != expectedObject)
		XCTFail(@"Object sending the notification and object recevied are not the same: \"%s\"", __PRETTY_FUNCTION__);

}



- (void)testNotifications
{
	
		

	
	__block NSObject *A = [[NSObject alloc] init];
	NSObject *B = [[NSObject alloc] init];
	
	NSArray *testStrings = @[@"Roebling", @"Metropolitan", @"Hope", @"Driggs", @"Fillmore", @"Grand", @"Bedford", @"Havemeyer", @"Berry", @"Wythe", @"Kent"];
	
	__block NSMutableArray *receivedNotifications = [NSMutableArray array];
	receivedSelectorNotifications = [NSMutableArray array];
	expectedObject = A;
	
	for(NSString *tmp in testStrings)
	{

		
		[B observeNotification:tmp withBlock:^(NSNotification *inNotification)
		{
			DLog(@"Notification recevied with block: %@", inNotification.name);
			[receivedNotifications addObject:inNotification.name];
			if(inNotification.object != A)
				XCTFail(@"Object sending the notification and object recevied are not the same: \"%s\"", __PRETTY_FUNCTION__);
		}];
		 
		[self observeNotification:tmp withSelector:@selector(objectWasNotified:)];
		[A sendNotification:tmp];
	}
	
	NSSet *sent = [NSSet setWithArray:testStrings];
	NSSet *receivedBlockSet = [NSSet setWithArray:receivedNotifications];
	
	NSSet *receivedSelectorSet = [NSSet setWithArray:receivedNotifications];

	if(![sent isEqualToSet:receivedBlockSet])
		XCTFail(@"Sent and received notifications are not the same: \"%s\"", __PRETTY_FUNCTION__);

	if(![sent isEqualToSet:receivedSelectorSet])
		XCTFail(@"Sent and received notifications are not the same: \"%s\"", __PRETTY_FUNCTION__);

	if(![receivedSelectorSet isEqualToSet:receivedBlockSet])
		XCTFail(@"Sent and received notifications are not the same: \"%s\"", __PRETTY_FUNCTION__);

	

	// Test that the same notifications are automatically removed
	// When object B is deallocated
	B = nil;
	for(NSString *tmp in testStrings)
	{
		[self stopObservingNotification:tmp];
		[A sendNotification:tmp];
	}

}


static FZBaseTestObject *testObject = nil;
static NSString *testName = @"Test Name";
-(void)objectWasObserved:(NSDictionary*)inDictionary
{
	DLog(@"KVO with selector \n%@", [inDictionary description]);
	if([inDictionary objectForKey:@"observed object"] != testObject)
		XCTFail(@"Observed object and received object are not the same: \"%s\"", __PRETTY_FUNCTION__);

}

- (void)testKeyValueObserving
{
	testObject = [[FZBaseTestObject alloc] init];
	
	[self observeObject:testObject forKeyPath:@"name" withBlock:^(NSDictionary *inDictionary)
	{
		DLog(@"KVO with block \n%@", [inDictionary description]);
		if([inDictionary objectForKey:@"observed object"] != testObject)
			XCTFail(@"Observed object and received object are not the same: \"%s\"", __PRETTY_FUNCTION__);
	}];

	FZBaseTestObject *testObjectB = [FZBaseTestObject new];
	[testObjectB observeObject:testObject forKeyPath:@"name" withBlock:^(NSDictionary *inDictionary)
	{
		DLog(@"Test Object B: KVO with block \n%@", [inDictionary description]);
		if([inDictionary objectForKey:@"observed object"] != testObject)
			XCTFail(@"Observed object and received object are not the same: \"%s\"", __PRETTY_FUNCTION__);
	}];
	
	testObject.name = testName;

	// Test that KVO relationships are automatically removed
	// When object B is deallocated
	testObjectB = nil;
	
	
	[self observeObject:testObject forKeyPath:@"name" withSelector:@selector(objectWasObserved:)];
	testObject.name = testName;
}


- (void)testAssociatedObjects
{
	
}


@end
