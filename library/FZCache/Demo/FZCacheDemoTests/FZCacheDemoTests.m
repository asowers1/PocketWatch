//
//  FZCacheDemoTests.m
//  FZCacheDemoTests
//
//  Created by Anton Remizov on 6/12/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <FZCache.h>
#import <UIImage+FZCache.h>
#import "mach/mach.h" 

@interface FZCacheDemoTests : XCTestCase

@end

@implementation FZCacheDemoTests

- (void)setUp
{
    [super setUp];
	[FZCache cleanCache:kFZCacheAll];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Basic caching tests
- (void)testCacheRootObject
{
	NSArray *array = @[@"one", @"two", @"three"];
	NSString *key = @"testCacheRootObjectKey";
	[FZCache cacheItem:array forKey:key];
	NSArray *cachedArray = [FZCache cachedItemForKey:key];
	XCTAssertEqualObjects(array, cachedArray, @"FZCache did not correctly cache and retrieve an NSArray instance.");
}

- (void)testCacheImage
{
	UIImage *image = [UIImage imageNamed:@"test-image.png"];
	NSString *key = @"testCacheImageKey";
	// Caching occurs on the background thread. To ensure its completion, use GCD.
	[FZCache cacheItem:image forKey:key inCache:kFZCacheLocal];
	UIImage *cachedImage = [FZCache cachedItemForKey:key inCache:kFZCacheLocal];
	XCTAssert(CGSizeEqualToSize(cachedImage.size, image.size), @"FZCache did not correctly cache and retrieve an UIImage instance.");
}

- (void)testCacheImageToRam
{
	UIImage *image = [UIImage imageNamed:@"test-image.png"];
	NSString *key = @"testCacheImageKey";
	// Caching occurs on the background thread. To ensure its completion, use GCD.
	[image cacheToPath:key cacheType:kFZCacheRAM];
	UIImage *cachedImage = [FZCache cachedItemForKey:key inCache:kFZCacheRAM];
	XCTAssertEqualObjects(image, cachedImage, @"FZCache did not correctly cache and retrieve an UIImage instance.");
}

- (void)testAsynchronousCache
{
	NSString *cacheObject = @"testCacheObject";
	NSString *key = @"testCacheImageKey";
	XCTestExpectation *tmpExpectation = [self expectationWithDescription:@"Asynchronous cache expectation."];
	[FZCache cacheItem:cacheObject forKey:key inCache:kFZCacheLocal withCompletionBlock:
	^{
		NSString *cachedObject = [FZCache cachedItemForKey:key inCache:kFZCacheLocal];
		XCTAssertEqualObjects(cacheObject, cachedObject, @"FZCache did not correctly cache and retrieve an NSS	tring instance.");
		[tmpExpectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:3.0f handler:nil];
}

- (void)testAsynchronousCacheReturn
{
	UIImage *image = [UIImage imageNamed:@"test-image.png"];
	NSString *key = @"testCacheImageKey";
	// Caching occurs on the background thread. To ensure its completion, use GCD.
	[FZCache cacheItem:image forKey:key inCache:kFZCacheLocal];
	XCTestExpectation *tmpExpectation = [self expectationWithDescription:@"Asynchronous fetch expectation."];
	[FZCache cachedItemForKey:key inCache:kFZCacheLocal withCompletionBlock:^(id returnObject) {
		XCTAssert(CGSizeEqualToSize([returnObject size], image.size), @"FZCache did not correctly cache and retrieve an UIImage instance.");
		[tmpExpectation fulfill];
	}];
	[self waitForExpectationsWithTimeout:3.0f handler:nil];
}
#pragma mark - Cache destruction tests
- (void)testLocalCacheCleanup
{
    CGFloat size = 20;
    [FZCache setCacheSize:size forCacheType:kFZCacheLocal];
    UIImage* img = [UIImage imageNamed:@"test-image.png"]; // 3.1 MB as PNG
    int itterations = size/3.1*4;
    for (int i = 0; i < itterations; ++i) {
        NSString* key = [NSString stringWithFormat:@"image-%d",i];
        [FZCache cacheItem:UIImagePNGRepresentation(img)
                    forKey:key];
    }
    [FZCache cleanCache:kFZCacheLocal];
    CGFloat localSize = [self folderSize];
    
    XCTAssert(localSize <= size, @"FZCacher local size reducer FAILED.");
}

- (void)testRAMCacheCleanup
{
    @autoreleasepool {
        [FZCache cleanCache:kFZCacheRAM];
    }
    
    vm_size_t startMemory = memoryUsage();
    
    float size = 20;
    [FZCache setCacheSize:size forCacheType:kFZCacheRAM];
    UIImage* img = [UIImage imageNamed:@"test-image.png"]; // 3.1 MB as PNG
    int itterations = size/3.1*4;
    @autoreleasepool {
        for (int i = 0; i < itterations; ++i) {
            NSString* key = [NSString stringWithFormat:@"image-%d",i];
            [FZCache cacheItem:UIImagePNGRepresentation(img)
                        forKey:key];
        }
    }
    @autoreleasepool {
        [FZCache cleanCache:kFZCacheRAM];
    }
    
    vm_size_t endMemory = memoryUsage();
    NSInteger diff = endMemory - startMemory;
    NSInteger delta = 500000; // 0.5 MB delta.
    
    XCTAssert( diff <= delta, @"FZCacher local size reducer FAILED.");
}

#pragma mark - Cache limit tests
- (void)testLocalCacheLimit
{
    CGFloat size = 20.0f;
    [FZCache setCacheSize:size forCacheType:kFZCacheLocal];
    UIImage* img = [UIImage imageNamed:@"test-image.png"]; // 3.1 MB as PNG
    int itterations = size/3.1*4;
    for (int i = 0; i < itterations; ++i) {
        NSString* key = [NSString stringWithFormat:@"image-%d",i];
        [FZCache cacheItem:UIImagePNGRepresentation(img)
                    forKey:key];
    }
    CGFloat localSize = [self folderSize];
    
    XCTAssert(localSize <= size, @"FZCacher local size reducer FAILED.");
}

vm_size_t memoryUsage(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        return info.resident_size;
    } else {
        return 0;
    }
}

- (void)testRAMCacheLimit
{
    [FZCache cleanCache:kFZCacheRAM|kFZCacheLocal];
    
    vm_size_t startMemory = memoryUsage();
    float size = 20;
    [FZCache setCacheSize:size forCacheType:kFZCacheRAM];
    UIImage* img = [UIImage imageNamed:@"test-image.png"]; // 3.1 MB as PNG
    int itterations = size/3.1*2;
    for (int i = 0; i < itterations; ++i) {
        @autoreleasepool {
            NSString* key = [NSString stringWithFormat:@"image-%d",i];
            [FZCache cacheItem:UIImagePNGRepresentation(img)
                        forKey:key];
            
        }
    }
    vm_size_t endMemory = memoryUsage();
    vm_size_t diff = endMemory - startMemory;
    XCTAssert((float)diff <= size*1000000, @"FZCacher local size reducer FAILED.");
}

#pragma mark - Helper methods
- (CGFloat)folderSize
{
    NSArray *tmpImageArray = [self arrayOfCachedFilesSortedByNSURLFileKey:NSURLCreationDateKey];
    NSInteger tmpBytesInCache = 0;
    
    for (NSURL *tmpFileURL in tmpImageArray)
    {
        NSNumber *tmpFileSize = nil;
        [tmpFileURL getResourceValue:&tmpFileSize forKey:NSURLFileSizeKey error:nil];
        tmpBytesInCache += [tmpFileSize longValue];
    }
    return tmpBytesInCache/1000000.0;
}

- (NSArray *)arrayOfCachedFilesSortedByNSURLFileKey:(NSString *)inNSURLFileKey
{
    NSArray *rtnImageArray =  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[FZCache cacheStoragePath]] includingPropertiesForKeys:@[NSFileCreationDate,NSFileSize] options:0 error:nil];
    
    rtnImageArray = [rtnImageArray sortedArrayUsingComparator:
                     ^NSComparisonResult(id obj1, id obj2)
                     {
                         NSDate *tmpFileDate1 = nil;
                         [obj1 getResourceValue:&tmpFileDate1 forKey:inNSURLFileKey error:nil];
                         
                         NSDate *tmpFileDate2 = nil;
                         [obj2 getResourceValue:&tmpFileDate2 forKey:inNSURLFileKey error:nil];
                         
                         return [tmpFileDate2 compare:tmpFileDate1];
                     }];
    
    return rtnImageArray;
}
@end
