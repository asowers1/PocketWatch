//
//  NSURLSessionDemoController.m
//  Demo
//
//  Created by Sean Orelli on 12/4/14.
//  Copyright (c) 2014 Sean Orelli. All rights reserved.
//

#import "NSURLSessionDemoController.h"
#import <NSURLSession+Fuzz.h>
#import <NSError+Fuzz.h>
#import <Fuzz.h>
#import <NSFileManager+Fuzz.h>
#import <UIView+Fuzz.h>
#import <UIImageView+Fuzz.h>
#import <UITableView+Fuzz.h>

@implementation NSURLSessionDemoController

static NSString *base_url = @"http://hintmddev.fuzzhq.com/api/1.0";

-(void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor darkGrayColor];
	
    UIImage *i = [UIImage imageNamed:@"sad-robot.jpg"];
    UIImageView *tmp = [[UIImageView alloc] initWithImage:i];
    
    [self.view addSubview:tmp];
    
    tmp.frame = CGRectMake(100, 100, 200, 200);
    tmp.backgroundColor = [UIColor redColor];
    [NSURLSession setBaseURLString:base_url];

    [tmp setImageWithURLString:@"http://influencepeople.com.au/wp-content/uploads/2014/05/robot.jpg"];
	
    //[self testHead];
    //[self testGet];   
	return;
    [self testPost];

    
	//tmp setImageW
    //[self testDownload];
   
	//[self testUpload];
    
    //[self testOptions];
    //[self testConnect];
    //[self testTrace];
}


-(void)testGet
{
    [NSURLSession setBaseURLString:@"http://hintmddev.fuzzhq.com/api/1.0"];
    NSString *myurl =@"treatment/types";
    NSDictionary *myparams = @{};
    
    [NSURLSession GET:myurl query:myparams success:^(NSURLResponse *response, NSString *stringData, id data)
    {
        DLog(@"%@", response);
    } failure:^(NSURLResponse *response, NSError *error)
    {
        ELog(error);
    }];
}

-(void)testHead
{
    [NSURLSession setBaseURLString:base_url];
    NSString *myurl =@"treatment/types";
    NSDictionary *myparams = @{};
    
    [NSURLSession HEAD:myurl query:myparams success:^(NSURLResponse *response, NSString *stringData, id data)
    {
        DLog(@"%@", response);
    }
    failure:^(NSURLResponse *response, NSError *error)
    {
        ELog(error);
    }];
    
    
}

/*
-(void)testTrace
{
    [NSURLSession setBaseURLString:base_url];
    NSString *myurl =@"treatment/types";
    NSDictionary *myparams = @{};
    [NSURLSession TRACE:myurl query:myparams completionHandler:^(id responseObject, NSURLResponse *response, NSError *error)
     {
         
         DLog(@"%@", response);
     }];
}
*/

-(void)testOptions
{
    [NSURLSession setBaseURLString:base_url];
    NSString *myurl =@"treatment/types";
    NSDictionary *myparams = @{};
    [NSURLSession OPTIONS:myurl query:myparams success:^(NSURLResponse *response, NSString *stringData, NSData *data)
    {
        DLog(@"%@", response);
    } failure:^(NSURLResponse *response, NSError *error)
    {
        ELog(error);
    }];
}




-(void)testPost
{
    WeakSelf me = self;
    [NSURLSession setBaseURLString:base_url];
    NSString *myurl =@"authenticate/login";
    NSDictionary *myparams = @{@"email":@"sean@fuzzproductions.com", @"password":@"password"};
    [NSURLSession POST:myurl query:myparams success:^(NSURLResponse *response, NSString *stringData, id data)
    {
        DLog(@"%@", response);
        NSDictionary *tmp = (NSDictionary*)data;
        NSString *token = tmp[@"data"][@"token"];
        
        [NSURLSession setAccessToken:token andIdentifier:@"X-Access-Token"];
        [me testPut];
        
    } failure:^(NSURLResponse *response, NSError *error)
    {

    }];
     
    
    
}


-(void)testPut
{
    [NSURLSession setBaseURLString:base_url];
    NSString *myurl =@"bookmark/article/1";
    NSDictionary *myparams = @{@"article_id":@"1"};
    
    WeakSelf me = self;
    [NSURLSession PUT:myurl query:myparams success:^(NSURLResponse *response, NSString *stringData, id data)
    {
        DLog(@"%@", response);
        [me testDelete];
        
    } failure:^(NSURLResponse *response, NSError *error)
    {
        ELog(error);
    }];
}

/*
-(void)testPatch
{
    [NSURLSession setBaseURLString:base_url];
    NSString *myurl =@"bookmark/article/1";
    NSDictionary *myparams = @{@"article_id":@"1"};
    
    [NSURLSession PATCH:myurl query:myparams completionHandler:^(id data, NSURLResponse *response, NSError *error)
     {
         DLog(@"%@", response);
         [self testDelete];
     }];
}*/


-(void)testConnect
{
    /*
    [NSURLSession setBaseURLString:base_url];
    NSString *myurl =@"treatment/types";
    NSDictionary *myparams = @{};
    [NSURLSession CONNECT:myurl query:myparams completionHandler:^(id responseObject, NSURLResponse *response, NSError *error)
     {
         DLog(@"%@", response);
     }];
     */
    
}



-(void)testDelete
{
    [NSURLSession setBaseURLString:base_url];
    NSString *myurl =@"bookmark/article/1";
    NSDictionary *myparams = @{@"article_id":@"1"};
    
    [NSURLSession DELETE:myurl query:myparams success:^(NSURLResponse *response, NSString *stringData, id data)
    {
         DLog(@"%@", response);
    } failure:^(NSURLResponse *response, NSError *error)
    {
         DLog(@"%@", response);
    }];
}

-(void)testDownload
{
    
    [NSURLSession setBaseURLString:nil];
    WeakSelf me = self;
    NSString *myurl =@"http://www.hdwallpapersimages.com/wp-content/uploads/2014/01/Winter-Tiger-Wild-Cat-Images.jpg";
    NSString *myfilepath =[[NSFileManager documentDirectoryPath] stringByAppendingPathComponent:@"download.jpg"];
    
    [NSURLSession download:myurl filePath:myfilepath progressBlock:^
    {

    } success:^(NSURLResponse *response, NSURL *location)
    {
        UIImage *i = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        UIImageView *iv = [[UIImageView alloc] initWithImage:i];
        [me.view addSubview:iv];
        [iv setSize:CGSizeMake(200, 200)];
    } failure:^(NSURLResponse *response, NSError *error)
    {
        
    }];
 
}

-(void)testUpload
{

    [NSURLSession setBaseURLString:nil];
    NSString *myurl =@"http://posttestserver.com/post.php";//@"bookmark/article/1";

    
    NSString *myFilePath = [[NSFileManager bundleDirectoryPath] stringByAppendingPathComponent:@"sad-robot.jpg"];
    [NSURLSession upload:myurl filePath:myFilePath progressBlock:^
    {

    } success:^(NSURLResponse *response, NSString *stringData, id data)
    {
        DLog(@"%@", response);

    } failure:^(NSURLResponse *response, NSError *error)
    {

        ELog(error);
    }];
}

@end
