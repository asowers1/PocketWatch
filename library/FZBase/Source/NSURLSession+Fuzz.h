//
//  NSURLSession+Fuzz.h
//  Demo
//
//  Created by Fuzz Productions 12/3/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Fuzz.h"

typedef void (^FZProgressBlock)(CGFloat inBytesComplete, CGFloat inTotalBytes);

// Notifications of Interent Connectivity changes
static const NSString *FUZZ_INTERNET_STATUS_LOST	= @"FUZZ_INTERNET_LOST";
static const NSString *FUZZ_INTERNET_STATUS_FOUND	= @"FUZZ_INTERNET_FOUND";
static const NSString *FUZZ_INTERNET_STATUS_CHANGED = @"FUZZ_INTERNET_CHANGED";

typedef void (^FZRequestSuccessBlock)(NSURLResponse *response, NSString *stringData, id objectData);
typedef void (^FZRequestFailureBlock)(NSURLResponse *response, NSError *error);

typedef void (^FZDownloadSuccessBlock)(NSURLResponse *response, NSURL *location);
typedef void (^FZDownloadFailureBlock)(NSURLResponse *response, NSError *error);

/*___________________________________
    
        NSURLSession + Fuzz
___________________________________*/
@interface NSURLSession (Fuzz) 

#pragma mark -
#pragma mark Internet "Reachability"

+ (bool)connectedToInternet;

+ (bool)connectedToWifi;

+ (bool)connectedToWWAN;

#pragma mark -
#pragma mark HTTP Headers

//**** TODO
//+ (void)setAcceptsType:(NSString*)inURLString;
//+ (NSURLSession*)fuzzDefaultSession
//+ (NSURLSession*)fuzzImageSession


+ (void)setBaseURLString:(NSString*)inURLString;

+ (void)setAccessToken:(NSString*)inToken andIdentifier:(NSString*)tokenIdentifier;

#pragma mark -
#pragma mark HTTP Methods
+ (NSURLSessionDataTask*)GET:(NSString*)inURLString query:(NSDictionary*)inParameters
                     success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure;
+ (NSURLSessionDataTask*)HEAD:(NSString*)inURLString query:(NSDictionary*)inParameters
                     success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure;
+ (NSURLSessionDataTask*)POST:(NSString*)inURLString query:(NSDictionary*)inParameters
                     success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure;
+ (NSURLSessionDataTask*)PUT:(NSString*)inURLString query:(NSDictionary*)inParameters
                     success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure;
+ (NSURLSessionDataTask*)DELETE:(NSString*)inURLString query:(NSDictionary*)inParameters
                     success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure;
+ (NSURLSessionDataTask*)OPTIONS:(NSString*)inURLString query:(NSDictionary*)inParameters
                     success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure;


/* ******************* TODO - Implement these functions to fulfill the HTTP Specification
+ (NSURLSessionDataTask*)PATCH:(NSString*)inURLString query:(NSDictionary*)inParameters completionHandler:(FZRequestBlock)inBlock;
+ (NSURLSessionDataTask*)TRACE:(NSString*)inURLString query:(NSDictionary*)inParameters completionHandler:(FZRequestBlock)inBlock;
+ (NSURLSessionDataTask*)CONNECT:(NSString*)inURLString query:(NSDictionary*)inParameters completionHandler:(FZRequestBlock)inBlock;
*/


#pragma mark -

#pragma mark File Upload / Download
+ (NSURLSessionUploadTask*)upload:(NSString*)inURLString filePath:(NSString*)inFilePath progressBlock:(FZBlock)inProgress
                                     success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure;

+ (NSURLSessionDownloadTask*)download:(NSString*)inURLString filePath:(NSString*)inFilePath progressBlock:(FZBlock)inProgress
                              success:(FZDownloadSuccessBlock)inSuccess failure:(FZDownloadFailureBlock)inFailure;

+ (NSURLSessionDataTask *)multipartFormUpload:(NSString *)URLString
								   parameters:(id)parameters
									  fileKey:(NSString*)inFileKey
									 filePath:(NSString*)inFileName
									 progress:(FZProgressBlock)progress
									  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
									  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


+ (NSURLSessionDataTask *)multipartFormUpload:(NSString *)URLString
								   parameters:(id)parameters
									  fileKey:(NSString*)inFileKey
									 filePaths:(NSArray*)inFilePathArray
									 progress:(FZProgressBlock)progress
									  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
									  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
#pragma mark -
@end




