//
//  FZViewController.m
//  FZCacheDemo
//
//  Created by Anton Remizov on 6/12/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "FZViewController.h"
#import <FZCache.h>
#import <UIImage+FZCache.h>
#import <mach/mach.h>
#import <NSFileManager+Fuzz.h>

@interface FZViewController ()

@property (nonatomic, weak) IBOutlet UILabel* ramSize;
@property (nonatomic, weak) IBOutlet UILabel* localSize;

@end

@implementation FZViewController

/*
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
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self refreshRamSize:nil];
    [self refreshDiskSize:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshDiskSize:(id)sender {
    self.localSize.text = [NSString stringWithFormat:@"Docs Disk Size: %.4f MB", [[self getDiskSpace] intValue]/1000000.0];
}

- (IBAction)refreshRamSize:(id)sender
{
    self.ramSize.text = [NSString stringWithFormat:@"Total Ram Size: %.4f MB", (double)memoryUsage()/1000000.0];
}

- (IBAction)cleanRam:(id)sender
{
    [FZCache cleanCache:kFZCacheRAM];
    [self refreshRamSize:nil];
}

- (IBAction)cleanDrive:(id)sender
{
    [FZCache cleanCache:kFZCacheLocal];
    [self refreshDiskSize:nil];
}

- (IBAction)loadToRam:(id)sender
{
    float size = 25;
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"test-image" ofType:@"jpg"];
    UIImage* img = [[UIImage alloc] initWithContentsOfFile:imagePath]; // 0.179834 MB as PNG - [UIImagePNGRepresentation(img) length]
    int iterations = size/0.179834;
    for (int i = 0; i < iterations; ++i) {
        @autoreleasepool {
            NSString* key = [NSString stringWithFormat:@"image-%d",i];
            [FZCache cacheItem:img forKey:key inCache:kFZCacheRAM];
            [self refreshRamSize:nil];
            [self refreshDiskSize:nil];
        }
    }

}

- (IBAction)loadToRamAndLocal:(id)sender
{
    float numOfImages = 1000;
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"test-image" ofType:@"jpg"];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:imagePath];
    for (int i = 0; i < numOfImages; ++i) {
        @autoreleasepool {
            NSString* key = [NSString stringWithFormat:@"image-%d",i];
            [FZCache cacheItem:img forKey:key];
            
            [self refreshRamSize:nil];
            [self refreshDiskSize:nil];
        }
    }
}

- (IBAction)setDiskLimit:(id)sender
{
    float size = 10.0;
    [FZCache setCacheSize:size forCacheType:kFZCacheLocal];
}

- (IBAction)setDefaultDiskLimit:(id)sender
{
    float size = 200.0;
    [FZCache setCacheSize:size forCacheType:kFZCacheLocal];
}

- (IBAction)setRamLimit:(id)sender
{
    float size = 10.0;
    [FZCache setCacheSize:size forCacheType:kFZCacheRAM];
}

- (IBAction)setDefaultRamLimit:(id)sender
{
    float size = 100.0;
    [FZCache setCacheSize:size forCacheType:kFZCacheRAM];
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


- (NSNumber *)getDiskSpace
{
    NSString *source = [NSFileManager documentDirectoryPath];
    
    NSArray * contents;
    unsigned long long size = 0;
    NSEnumerator * enumerator;
    NSString * path;
    BOOL isDirectory;
    NSError *error = nil;
    
    // Determine Paths to Add
    if ([[NSFileManager defaultManager] fileExistsAtPath:source isDirectory:&isDirectory] && isDirectory)
    {
        contents = [[NSFileManager defaultManager] subpathsAtPath:source];
    }
    else
    {
        contents = [NSArray array];
    }
    // Add Size Of All Paths
    enumerator = [contents objectEnumerator];
    while (path = [enumerator nextObject])
    {
        NSDictionary * fattrs = [[NSFileManager defaultManager] attributesOfItemAtPath: [ source stringByAppendingPathComponent:path ] error:&error];
        size += [[fattrs objectForKey:NSFileSize] unsignedLongLongValue];
    }
    
    // Return Total Size in Bytes
    return [NSNumber numberWithUnsignedLongLong:size];
}


@end
