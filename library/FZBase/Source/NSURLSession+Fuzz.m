//
//  NSURLSession+Fuzz.m
//  Demo
//
//  Created by Fuzz Productions on 12/3/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "NSURLSession+Fuzz.h"
#import "NSObject+Fuzz.h"
#import "NSString+Fuzz.h"
#import "NSError+Fuzz.h"
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

#import <CoreFoundation/CoreFoundation.h>

#import "NSData+Fuzz.h"
#import "NSDictionary+Fuzz.h"
#import "NSURLRequest+Fuzz.h"

/* Frameworks */
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <MobileCoreServices/MobileCoreServices.h>

NSString * mimeTypeForPath(NSString *path)
{
	// get a mime type for an extension using MobileCoreServices.framework
	
	CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
	CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
	assert(UTI != NULL);
	
	NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
	assert(mimetype != NULL);
	
	CFRelease(UTI);
	
	return mimetype;
}



@interface FZURLSessionDefaultDelegate : NSObject <NSURLSessionDelegate>
+ (instancetype)shared;
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error;
@end



@implementation FZURLSessionDefaultDelegate
static FZURLSessionDefaultDelegate *singleton = nil;
+ (instancetype)shared
{
	Once(^ { singleton = [[FZURLSessionDefaultDelegate alloc] init]; });
	return singleton;
}
/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly invalidated, in which case the error parameter will be nil.
 */

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
	ELog(error);
}
/* If implemented, when a connection level authentication challenge
 * has occurred, this delegate will be given the opportunity to
 * provide authentication credentials to the underlying
 * connection. Some types of authentication will apply to more than
 * one request on a given connection to a server (SSL Server Trust
 * challenges).  If this delegate message is not implemented, the
 * behavior will be to use the default handling, which may involve user
 * interaction.
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
	completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}


/* If an application has received an
 * -application:handleEventsForBackgroundURLSession:completionHandler:
 * message, the session delegate will receive this message to indicate
 * that all messages previously enqueued for this session have been
 * delivered.  At this time it is safe to invoke the previously stored
 * completion handler, or to begin any internal updates that will
 * result in invoking the completion handler.
 */

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
	
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
	totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
	FZProgressBlock progress = [task getAssociatedObjectForKey:@"Fuzz_Progress_Block"];
	if(progress)
		progress(totalBytesSent, totalBytesExpectedToSend);
}


@end










/*___________________________________________________
 
            FZURLSession Reachability
___________________________________________________*/
@interface FZURLSessionReachability : NSObject
+(void)reachabilityStatusChanged;
@end




#pragma mark - Supporting functions

#define kShouldPrintReachabilityFlags 0

static void PrintReachabilityFlags(SCNetworkReachabilityFlags flags, const char* comment)
{
#if kShouldPrintReachabilityFlags
    
    NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
          (flags & kSCNetworkReachabilityFlagsIsWWAN)				? 'W' : '-',
          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
          
          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
          comment
          );
#endif
}


static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
    NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
    NSCAssert([(__bridge NSObject*) info isKindOfClass: [FZURLSessionReachability class]], @"info was wrong class in ReachabilityCallback");
    [FZURLSessionReachability reachabilityStatusChanged];
}

typedef enum : NSInteger
{
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN
} NetworkStatus;




@interface FZURLSessionReachability ()
/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

/*!
 * Checks whether a local WiFi connection is available.
 */
+ (instancetype)reachabilityForLocalWiFi;

/*!
 * Start listening for reachability notifications on the current run loop.
 */
- (BOOL)startNotifier;
- (void)stopNotifier;

- (NetworkStatus)currentReachabilityStatus;

/*!
 * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
 */
- (BOOL)connectionRequired;

@end

#pragma mark - Reachability implementation

@implementation FZURLSessionReachability
{
    BOOL localWiFiRef;
    SCNetworkReachabilityRef reachabilityRef;
}


static FZURLSessionReachability *hostReachability;
static FZURLSessionReachability *internetReachability;
static FZURLSessionReachability *wifiReachability;

+ (void)startReachability
{
    Once(^
	{
		NSString *remoteHostName = @"www.apple.com";
		hostReachability = [FZURLSessionReachability reachabilityWithHostName:remoteHostName];
		[hostReachability startNotifier];
             
		internetReachability = [FZURLSessionReachability reachabilityForInternetConnection];
		[internetReachability startNotifier];
		
		wifiReachability = [FZURLSessionReachability reachabilityForLocalWiFi];
		[wifiReachability startNotifier];
	});

}

+ (bool)connectedToInternet
{
    [self startReachability];
    if(internetReachability.currentReachabilityStatus != NotReachable)
        return YES;
    
    return NO;
}

+ (bool)connectedToWifi
{
    [self startReachability];
    if(wifiReachability.currentReachabilityStatus == ReachableViaWiFi)
        return YES;

    return NO;
    
}

+ (bool)connectedToWWAN
{
    [self startReachability];
    if(internetReachability.currentReachabilityStatus == ReachableViaWWAN)
        return YES;
    
    return NO;
}

+ (void)reachabilityStatusChanged
{

    [[NSURLSession sharedSession] sendNotification:(NSString*)FUZZ_INTERNET_STATUS_CHANGED];
	
	if (![self connectedToInternet] && ![self connectedToWWAN] && ![self connectedToWifi])
		[[NSURLSession sharedSession] sendNotification:(NSString *)FUZZ_INTERNET_STATUS_LOST];

	if ([self connectedToInternet] || [self connectedToWWAN] || [self connectedToWifi])
		[[NSURLSession sharedSession] sendNotification:(NSString *)FUZZ_INTERNET_STATUS_FOUND];
}

+ (instancetype)reachabilityWithHostName:(NSString *)hostName;
{
    FZURLSessionReachability* returnValue = NULL;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    if (reachability != NULL)
    {
        returnValue= [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->reachabilityRef = reachability;
            returnValue->localWiFiRef = NO;
        }
    }
    return returnValue;
}


+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);
    
    FZURLSessionReachability* returnValue = NULL;
    
    if (reachability != NULL)
    {
        returnValue = [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->reachabilityRef = reachability;
            returnValue->localWiFiRef = NO;
        }
    }
    return returnValue;
}



+ (instancetype)reachabilityForInternetConnection;
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    return [self reachabilityWithAddress:&zeroAddress];
}


+ (instancetype)reachabilityForLocalWiFi;
{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    
    // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0.
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    
    FZURLSessionReachability* returnValue = [self reachabilityWithAddress: &localWifiAddress];
    if (returnValue != NULL)
        returnValue->localWiFiRef = YES;
	
    return returnValue;
}


#pragma mark - Start and stop notifier

- (BOOL)startNotifier
{
    BOOL returnValue = NO;
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    if (SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context))
        if (SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
            returnValue = YES;
	
    return returnValue;
}


- (void)stopNotifier
{
    if (reachabilityRef != NULL)
        SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
}


- (void)dealloc
{
    [self stopNotifier];
    if (reachabilityRef != NULL)
        CFRelease(reachabilityRef);
}


#pragma mark - Network Flag Handling

- (NetworkStatus)localWiFiStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    PrintReachabilityFlags(flags, "localWiFiStatusForFlags");
    BOOL returnValue = NotReachable;
    
    if ((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
        returnValue = ReachableViaWiFi;
	
    return returnValue;
}


- (NetworkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    PrintReachabilityFlags(flags, "networkStatusForFlags");
	// The target host is not reachable.
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
        return NotReachable;
	
    BOOL returnValue = NotReachable;

	/*If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...*/
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
        returnValue = ReachableViaWiFi;

	/*... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...*/
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
		/*... and no [user] intervention is needed...*/
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
            returnValue = ReachableViaWiFi;
    }

	/* ... but WWAN connections are OK if the calling application is using the CFNetwork APIs. */
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
        returnValue = ReachableViaWWAN;
	
    return returnValue;
}


- (BOOL)connectionRequired
{
    NSAssert(reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
	
    return NO;
}


- (NetworkStatus)currentReachabilityStatus
{
    NSAssert(reachabilityRef != NULL, @"currentNetworkStatus called with NULL reachabilityRef");
    NetworkStatus returnValue = NotReachable;
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
        if (localWiFiRef)
            returnValue = [self localWiFiStatusForFlags:flags];
        else
            returnValue = [self networkStatusForFlags:flags];
    }
    
    return returnValue;
}


@end




#pragma mark - NSURLSession Functions

@implementation NSURLSession (Fuzz)

static NSString *token = nil;
static NSString *tokenIdentifier = nil;
static NSString *baseURLString = nil;

+ (bool)connectedToWifi
{
    return [FZURLSessionReachability connectedToWifi];
}

+ (bool)connectedToInternet
{
    return [FZURLSessionReachability connectedToInternet];
}

+ (bool)connectedToWWAN
{
    return [FZURLSessionReachability connectedToWWAN];
}

+ (void)setAccessToken:(NSString*)inToken andIdentifier:(NSString*)inTokenIdentifier
{
    token = [inToken copy];
    tokenIdentifier = [inTokenIdentifier copy];
}

+ (void)setBaseURLString:(NSString*)inURLString
{
    baseURLString = [inURLString copy];
}
+ (NSURLRequest*)requestWithURLString:(NSString*)inURLString method:(NSString*)inMethod query:(NSDictionary*)inParameters
{
    inURLString = [self relativeURLString:inURLString];
    NSURLRequest *request = [NSURLRequest requestWithURLString:inURLString method:inMethod query:inParameters];
    return request;
}
+ (NSString*)relativeURLString:(NSString*)inURLString
{
    if([baseURLString isKindOfClass:[NSString class]] && [inURLString isKindOfClass:[NSString class]])
    {
        
        if([baseURLString hasSuffix:@"/"] && [inURLString hasPrefix:@"/"])
        {
            if(inURLString.length>1)
                return [baseURLString stringByAppendingString:[inURLString substringFromIndex:1]];
            
            if(baseURLString.length>1)
                return [[baseURLString substringToIndex:baseURLString.length-2] stringByAppendingString:inURLString];
        }
        
        
        if((![inURLString hasPrefix:@"/"]) && (![baseURLString hasSuffix:@"/"]))
        {
            return [baseURLString stringByAppendingFormat:@"/%@",inURLString];
        }
        
        return [baseURLString stringByAppendingString:inURLString];
    }
    
    return inURLString;
}


+ (NSURLSession*)fuzzDefaultSession
{
    [FZURLSessionReachability startReachability];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    if(exists(token) && exists(tokenIdentifier))
        if([token isKindOfClass:[NSString class]] && [tokenIdentifier isKindOfClass:[NSString class]])
            configuration.HTTPAdditionalHeaders = @{tokenIdentifier:token};
    
    FZURLSessionDefaultDelegate *delegate = [FZURLSessionDefaultDelegate shared];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:delegate delegateQueue:nil];
    return session;
}



+ (NSURLSessionDataTask *)HEAD:(NSString*)inURLString query:(NSDictionary*)inParameters
                       success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure
{
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLRequest *request = [self requestWithURLString:inURLString method:@"HEAD" query:inParameters];
    NSURLSession *session = [self fuzzDefaultSession];

    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         if(error)  inFailure(response, error);
         else       inSuccess(response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],[data jsonValue]);
     }];
    [dataTask resume];
    
    return dataTask;
}
+ (NSURLSessionDataTask *)GET:(NSString*)inURLString query:(NSDictionary*)inParameters
                      success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure
{
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLRequest *request = [self requestWithURLString:inURLString method:@"GET" query:inParameters];
    NSURLSession *session = [self fuzzDefaultSession];
    
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         if(error)  inFailure(response, error);
         else       inSuccess(response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [data jsonValue]);
     }];
    [dataTask resume];
    
    return dataTask;
    
}




+ (NSURLSessionDataTask*)POST:(NSString*)inURLString query:(NSDictionary*)inParameters
                      success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure
{
    NSURLRequest *request = [self requestWithURLString:inURLString method:@"POST" query:inParameters];
    //Session Task
    NSURLSession *session = [self fuzzDefaultSession];
    NSURLSessionDataTask *postDataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         if(error)  inFailure(response, error);
         else       inSuccess(response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [data jsonValue]);
    }];
    
    [postDataTask resume];
    return postDataTask;
}

+ (NSURLSessionDataTask*)PUT:(NSString*)inURLString query:(NSDictionary*)inParameters
                      success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure
{
    NSURLRequest *request = [self requestWithURLString:inURLString method:@"PUT" query:inParameters];
    NSURLSession *session = [self fuzzDefaultSession];
    
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         if(error)  inFailure(response, error);
         else       inSuccess(response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [data jsonValue]);
     }];
    [dataTask resume];
    
    return dataTask;
}
+ (NSURLSessionDataTask*)PATCH:(NSString*)inURLString query:(NSDictionary*)inParameters
                      success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure
{
    NSURLRequest *request = [self requestWithURLString:inURLString method:@"PATCH" query:inParameters];
    NSURLSession *session = [self fuzzDefaultSession];
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         if(error)  inFailure(response, error);
         else       inSuccess(response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [data jsonValue]);
     }];
    [dataTask resume];
    
    return dataTask;
}


+ (NSURLSessionDataTask*)DELETE:(NSString*)inURLString query:(NSDictionary*)inParameters
                      success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure
{
    NSURLRequest *request = [self requestWithURLString:inURLString method:@"DELETE" query:inParameters];
    NSURLSession *session = [self fuzzDefaultSession];
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         if(error)  inFailure(response, error);
         else       inSuccess(response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [data jsonValue]);
     }];
    [dataTask resume];
    
    return dataTask;
}

+ (NSURLSessionDataTask*)OPTIONS:(NSString*)inURLString query:(NSDictionary*)inParameters
                      success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure
{
    NSURLRequest *request = [self requestWithURLString:inURLString method:@"OPTIONS" query:inParameters];
    NSURLSession *session = [self fuzzDefaultSession];
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         if(error)  inFailure(response, error);
         else       inSuccess(response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [data jsonValue]);
     }];
    [dataTask resume];
    return dataTask;
}


/*********** Implement and test these functions to fulfill the HTTP SPecification   **************************************
+ (NSURLSessionDataTask*)TRACE:(NSString*)inURLString query:(NSDictionary*)inParameters completionHandler:(FZRequestBlock)inBlock
{
    inURLString = [self relativeURLString:inURLString];
    NSURLRequest *request = [NSURLRequest requestWithURLString:inURLString method:@"TRACE" query:inParameters];
    NSURLSession *session = [self fuzzDefaultSession];
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         
         inBlock([data jsonValue], response, error);
     }];
    [dataTask resume];
    return dataTask;
}





+ (NSURLSessionDataTask*)CONNECT:(NSString*)inURLString query:(NSDictionary*)inParameters completionHandler:(FZRequestBlock)inBlock
{
    inURLString = [self relativeURLString:inURLString];
    NSURLRequest *request = [NSURLRequest requestWithURLString:inURLString method:@"CONNECT" query:inParameters];
    NSURLSession *session = [self fuzzDefaultSession];
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         
         inBlock([data jsonValue], response, error);
     }];
    [dataTask resume];
    return dataTask;
}
 *****************************************************************************************************************************************/

+ (NSURLSessionDownloadTask*)download:(NSString*)inURLString filePath:(NSString*)inFilePath
                    progressBlock:(FZBlock)inProgress
                     success:(FZDownloadSuccessBlock)inSuccess failure:(FZDownloadFailureBlock)inFailure;
{
    
    NSURLSession *session = [self fuzzDefaultSession];
    NSURLSessionDownloadTask *downloadTask =
    [session downloadTaskWithURL:[NSURL URLWithString:inURLString] completionHandler:^(NSURL *location,NSURLResponse *response,NSError *error)
     {
         //inBlock(location, response, error);
         if(error)  inFailure(response, error);
         else       inSuccess(response, location);
     }];
    

    [downloadTask resume];
    return downloadTask;
}


+ (NSURLSessionDataTask*)upload:(NSString*)inURLString filePath:(NSString*)inFilePath
                  progressBlock:(FZBlock)inProgress success:(FZRequestSuccessBlock)inSuccess failure:(FZRequestFailureBlock)inFailure
{
    NSURL *url = [NSURL fileURLWithPath:inURLString];
    __block NSDictionary *parameters = @{@"mything":@"superduper"};
    
    NSURLRequest *request = [self requestWithURLString:inURLString method:@"POST" query:parameters];
    NSURLSession *session = [self fuzzDefaultSession];
    
    NSURLSessionUploadTask *uploadTask =
    [session uploadTaskWithRequest:request fromFile:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {

         if(error)  inFailure(response, error);
         else       inSuccess(response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [data jsonValue]);
         
     }];
    
    
    [uploadTask resume];
    return uploadTask;
    
}

+ (id)responseObjectForData:(NSData*)inData
{
    return [[NSString alloc] initWithData:inData encoding:NSUTF8StringEncoding];
}



+ (NSURLSessionDataTask *)multipartFormUpload:(NSString *)URLString
								   parameters:(id)parameters
									  fileKey:(NSString*)inFileKey
									 filePath:(NSString*)inFileName
									 progress:(FZProgressBlock)progress
									  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
									  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
	// Build the request body
	NSString *boundary = @"Fuzz-Multipart-Form-Boundary-------------------------------";
	
	NSMutableData *body = [NSMutableData data];
	
	for(NSString *key in [parameters allKeys]) {
		
		NSString *val = parameters[key];
		
		if([val isKindOfClass:[NSString class]] || [val isKindOfClass:[NSNumber class]]  )
		{
			[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"%@\r\n", val] dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	
	
	
	// Body part for the attachament. This is an image.
	// NSData *imageData = UIImagePNGRepresentation(inImage);
	NSString    *mimeType = mimeTypeForPath(inFileName);//@"image/jpg";//use ending of filename
	NSData      *inData = [NSData dataWithContentsOfFile:inFileName];//readFrom File, if (png) use pngrepresentation
	if (inData)
	{
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", inFileKey, inFileName.lastPathComponent] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:inData];
		[body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// Create the session
	
	NSURLSession *session = nil;
	if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)//iOS 7.1 and under fix. Fuzz default session would overwrite HTTPHeaderFields that were neccessary to complete the upload task
	{
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		if(exists(token) && exists(tokenIdentifier))
			if([token isKindOfClass:[NSString class]] && [tokenIdentifier isKindOfClass:[NSString class]]) {
				configuration.HTTPAdditionalHeaders = @{tokenIdentifier:token,@"Content-Type": [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
														};
			}
		
		session = [NSURLSession sessionWithConfiguration:configuration];
	}
	else
 {
		// We can use the delegate to track upload progress
		NSURLSession *session = [self fuzzDefaultSession];
		NSMutableDictionary *D = [NSMutableDictionary dictionaryWithDictionary:session.configuration.HTTPAdditionalHeaders];
		[D setObject:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forKey:@"Content-Type"];
		session.configuration.HTTPAdditionalHeaders =  [NSDictionary dictionaryWithDictionary:D];
	}
	
	// Data uploading task. We could use NSURLSessionUploadTask instead of NSURLSessionDataTask if we needed to support uploads in the background
	NSURL *url = [NSURL URLWithString:URLString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	request.HTTPMethod = @"POST";
	request.HTTPBody = body;

	__block NSURLSessionUploadTask *uploadTask =
	[session uploadTaskWithRequest:request fromData:body
				 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
	 {
		 if(error)
		 {
			 ELog(error);
			 failure(nil, error);
		 }else
		 {
			 NSDictionary *JSONObject = [data jsonValue];
			 success(uploadTask, JSONObject);
		 }
	 }];
	
	if(progress)
		[uploadTask setAssociatedObject:progress forKey:@"Fuzz_Progress_Block"];
	
	[uploadTask resume];
	return uploadTask;
	
}


+ (NSURLSessionDataTask *)multipartFormUpload:(NSString *)URLString
								   parameters:(id)parameters
									  fileKey:(NSString*)inFileKey
									filePaths:(NSArray*)inFilePathArray
									 progress:(FZProgressBlock)progress
									  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
									  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
	
	// Build the request body
	NSString		*boundary = @"Fuzz-Multipart-Form-Boundary-------------------------------";
	NSMutableData	*body = [NSMutableData data];
	
	for(NSString *key in [parameters allKeys]) {
		
		id val = parameters[key];
		if([val isKindOfClass:[NSString class]] || [val isKindOfClass:[NSNumber class]]) {
			[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"%@\r\n", val] dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	
	NSString *formattedFileKey = [inFileKey stringByAppendingString:@"[]"];
								  
	//handle image paths and append image data
	for (NSString *inFileName in inFilePathArray) {
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", formattedFileKey] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"%@\r\n", inFileName.lastPathComponent] dataUsingEncoding:NSUTF8StringEncoding]];  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", formattedFileKey] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"%@\r\n", inFileName.lastPathComponent] dataUsingEncoding:NSUTF8StringEncoding]];
		
		NSString    *mimeType	= mimeTypeForPath(inFileName);//@"image/jpg";//use ending of filename
		NSData      *inData		= [NSData dataWithContentsOfFile:inFileName];//readFrom File, if (png) use pngrepresentation
		
		if (inData) {
			[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", formattedFileKey, inFileName.lastPathComponent] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:inData];
			[body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		}

	}
	
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// Create the session
	// We can use the delegate to track upload progress
	NSURLSession *session = nil;
	if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)//iOS 7.1 and under fix. Fuzz default session would overwrite HTTPHeaderFields that were neccessary to complete the upload task
	{
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		if(exists(token) && exists(tokenIdentifier))
			if([token isKindOfClass:[NSString class]] && [tokenIdentifier isKindOfClass:[NSString class]]) {
				configuration.HTTPAdditionalHeaders = @{tokenIdentifier:token,@"Content-Type": [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
														};
			}
		
		session = [NSURLSession sessionWithConfiguration:configuration];
	}
	else
	{
		// We can use the delegate to track upload progress
		NSURLSession *session = [self fuzzDefaultSession];
		NSMutableDictionary *D = [NSMutableDictionary dictionaryWithDictionary:session.configuration.HTTPAdditionalHeaders];
		[D setObject:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forKey:@"Content-Type"];
		session.configuration.HTTPAdditionalHeaders =  [NSDictionary dictionaryWithDictionary:D];
	}

	// Data uploading task. We could use NSURLSessionUploadTask instead of NSURLSessionDataTask if we needed to support uploads in the background
	NSURL *url = [NSURL URLWithString:URLString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	request.HTTPMethod = @"POST";
	request.HTTPBody = body;
	
	__block NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:body
				 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)  {
					 
		 if(error) {
			 ELog(error);
			 failure(nil, error);
			 
		 } else {
			 NSDictionary *JSONObject = [data jsonValue];
			 success(uploadTask, JSONObject);
		 }
	 }];
	
	if(progress)
		[uploadTask setAssociatedObject:progress forKey:@"Fuzz_Progress_Block"];
	
	[uploadTask resume];
	return uploadTask;
}


@end