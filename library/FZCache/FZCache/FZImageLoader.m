//
//  ImageLoader.m
//  FZModuleLibrary
//
//  Created by Anton Remizov on 10/2/13.
//  Copyright (c) 2013 Fuzz Productions. All rights reserved.
//

#import "FZImageLoader.h"
#import "AFHTTPRequestOperation.h"

static NSInteger FZImageLoaderConcurrentOperationsCount = NSOperationQueueDefaultMaxConcurrentOperationCount;

@interface FZImageLoader()

@end


@implementation FZImageLoader

+ (void) setCocurrentCount:(NSInteger)count
{
    FZImageLoaderConcurrentOperationsCount = count;
    [[self af_sharedImageRequestOperationQueue] setMaxConcurrentOperationCount:FZImageLoaderConcurrentOperationsCount];
}

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_imageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_af_imageRequestOperationQueue setMaxConcurrentOperationCount:FZImageLoaderConcurrentOperationsCount];
    });
    
    return _af_imageRequestOperationQueue;
}

- (void) loadImageFromURL:(NSString*)path onSuccess:(void(^)(UIImage* img))success onFailure:(void(^)(NSError* error))failure
{
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];

    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
#ifdef _AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_
    requestOperation.allowsInvalidSSLCertificate = YES;
#endif
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage* img = responseObject;
        success(img);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [[[self class] af_sharedImageRequestOperationQueue] addOperation:requestOperation];
}

@end
