//
//  FZFacebookHandler.m
//  FZModuleLibrary
//
//  Created by Christopher Luu on 7/21/12.
//  Copyright (c) 2012 Fuzz Productions. All rights reserved.
//

#import "FZFacebookHandler.h"
#import <FacebookSDK/FacebookSDK.h>
//#import <FZCacheHandler/FZCacheHandler.h>
#import <FZCacheHandler.h>
#import "Fuzz.h"
@implementation FZFacebookHandler




static NSString *FZFacebookHandlerAppID = nil;
static NSArray *FZFacebookHandlerReadPermissionArray = nil;
static NSArray *FZFacebookHandlerPublishPermissionArray = nil;



#pragma mark -
#pragma mark FZFacebookHandler public functions
+ (void)setUpHandlerWithAppId:(NSString*)inAppId
{
  
  [self setUpHandlerWithAppId:inAppId readPermissions:[NSArray arrayWithObjects:@"email", @"user_photos", nil] publishPermissions:nil];
}


+ (void)setUpHandlerWithAppId:(NSString*)inAppId
              readPermissions:(NSArray*)inReadPermissions
           publishPermissions:(NSArray*)inPublishPermissions
{
  
  FZFacebookHandlerAppID = [inAppId copy];
  
  if(inReadPermissions)
    FZFacebookHandlerReadPermissionArray = [inReadPermissions copy];
  
  if(inPublishPermissions)
    FZFacebookHandlerPublishPermissionArray = [inPublishPermissions copy];
  
  [FBSettings setDefaultAppID:FZFacebookHandlerAppID];
  
  if ([[FBSession activeSession] state] == FBSessionStateCreatedTokenLoaded)
    [[FBSession activeSession] openWithCompletionHandler:nil];
}

+ (BOOL)handleOpenURL:(NSURL *)inURL
{
  return [[FBSession activeSession] handleOpenURL:inURL];
}

+ (void)handleDidBecomeActive
{
  [[FBSession activeSession] handleDidBecomeActive];
}

+ (BOOL)isLoggedIn
{
  
  return [[FBSession activeSession] isOpen];
}

+ (NSString *)accessToken
{
  if ([self isLoggedIn])
    return [[FBSession activeSession] accessTokenData].accessToken;
  
  return nil;
}


//Only here to avoid the warning for a missing selector
-(void)setLoginHandler:(id)thing{}

+ (void)loginWithCompletionBlock:(void (^)(BOOL inSuccess, NSError *inError))inCompletionBlock
{
  
  
  if ([self isLoggedIn])
  {
    if (inCompletionBlock)
      inCompletionBlock(YES, nil);
    return;
  }
  
  [FBSession openActiveSessionWithReadPermissions:FZFacebookHandlerReadPermissionArray
                                     allowLoginUI:YES
                                completionHandler:
   ^(FBSession *session, FBSessionState status, NSError *error)
   {
     if(error)
       [self handleAuthenticationError:error];
     
     // Hack to prevent the same block to be called upon every session state change
     [session performSelector:@selector(setLoginHandler:) withObject:nil];
     if ([session isOpen])
     {
       if (inCompletionBlock)
         inCompletionBlock(YES, nil);
     }
     else if (inCompletionBlock)
     {
       inCompletionBlock(NO, error);
     }
   }];
}

+ (void)logout
{
  [[FBSession activeSession] closeAndClearTokenInformation];
}

#pragma mark -
#pragma mark Requests

#pragma mark -
#pragma mark Generalized request
+ (FBRequestConnection *)connectionForRequestWithGraphPath:(NSString *)inGraphPath parameters:(NSDictionary *)inParameters HTTPMethod:(NSString *)inHTTPMethod completionHandler:(FBRequestHandler)inCompletionHandler
{
  if (![self isLoggedIn])
    return nil;
  
  return [FBRequestConnection startWithGraphPath:inGraphPath
                                      parameters:inParameters
                                      HTTPMethod:inHTTPMethod
                               completionHandler:
          ^(FBRequestConnection *connection, id result, NSError *error)
          {
            if (!error)
            {
              if (inCompletionHandler)
                inCompletionHandler(connection, result, error);
            }
            else if ([inHTTPMethod isEqualToString:@"GET"] &&
                     ([[error userInfo][FBErrorParsedJSONResponseKey][@"body"][@"error"][@"code"] compare:@200] == NSOrderedSame))
            {
              [[FBSession activeSession] requestNewReadPermissions:FZFacebookHandlerReadPermissionArray
                                                 completionHandler:
               ^(FBSession *session, NSError *sessionError)
               {
                 if (!sessionError)
                 {
                   [self connectionForRequestWithGraphPath:inGraphPath
                                                parameters:inParameters
                                                HTTPMethod:inHTTPMethod
                                         completionHandler:inCompletionHandler];
                 }
                 else
                 {
                   inCompletionHandler(connection, result, error);
                 }
               }];
            }
            else if ([inHTTPMethod isEqualToString:@"POST"] &&
                     ([[error userInfo][FBErrorParsedJSONResponseKey][@"body"][@"error"][@"code"] compare:@200] == NSOrderedSame))
            {
              BOOL tmpAllPermissionsFound = YES;
              for (NSString *tmpString in FZFacebookHandlerPublishPermissionArray)
              {
                if (![[[FBSession activeSession] permissions] containsObject:tmpString])
                {
                  tmpAllPermissionsFound = NO;
                  break;
                }
              }
              
              if (tmpAllPermissionsFound)
              {
                if (inCompletionHandler)
                  inCompletionHandler(connection, result, error);
                return;
              }
              
              
              [[FBSession activeSession] requestNewPublishPermissions:FZFacebookHandlerPublishPermissionArray
                                                      defaultAudience:FBSessionDefaultAudienceEveryone
                                                    completionHandler:
               ^(FBSession *session, NSError *sessionError)
               {
                 if (!sessionError)
                 {
                   
                   BOOL tmpHasDeclinedPermissions = false;
                   for (NSString *tmpString in FZFacebookHandlerPublishPermissionArray)
                   {
                     if ([[[FBSession activeSession] declinedPermissions] containsObject:tmpString])
                     {
                       tmpHasDeclinedPermissions = YES;
                       break;
                     }
                   }
                   
                   if (!tmpHasDeclinedPermissions)
                   {
                     [self connectionForRequestWithGraphPath:inGraphPath
                                                  parameters:inParameters
                                                  HTTPMethod:inHTTPMethod
                                           completionHandler:inCompletionHandler];
                   }
                   
                 }
                 else
                 {
                   inCompletionHandler(connection, result, error);
                 }
               }];
            }
            else if (inCompletionHandler)
            {
              inCompletionHandler(connection, result, error);
            }
          }];
}

#pragma mark -
#pragma mark Post to feed
+ (void)postFeedItemWithName:(NSString *)inName caption:(NSString *)inCaption description:(NSString *)inDescription link:(NSString *)inLink imageURL:(NSString *)inImageURL completionHandler:(FBRequestHandler)inCompletionHandler
{
  [self connectionForRequestWithGraphPath:@"/me/feed"
                               parameters:@{
                                            @"name": inName ? : @"",
                                            @"caption" : inCaption ? : @"",
                                            @"description" : inDescription ? : @"",
                                            @"link" : inLink ? : @"",
                                            @"picture" : inImageURL ? : @""
                                            }
                               HTTPMethod:@"POST"
                        completionHandler:inCompletionHandler];
}


#pragma mark -
#pragma mark Permissions
+ (void)requestPublishPermissionsWithCompletionHandler:(void (^)(NSError *inError))inCompletionHandler
{
  // First, check to see if we have publication permission.
  __block NSMutableArray	*permissionsToRequestArray = [[NSMutableArray alloc] initWithArray:@[]];
  [self userHasPermissionsInArray:@[FZFacebookPermissionKeyPublishActions] withResults:^(NSMutableArray *resultsArray, NSError *error)
   {
     if (error)
     {
       NSLog(@"Error getting current permissions %@",error);
     }
     else
     {
       permissionsToRequestArray = resultsArray;
     }
     
   }];
  
  if (permissionsToRequestArray.count > 0)
  {
    // Permission has not yet been granted. Request it.
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceFriends
                                        completionHandler:
     ^(FBSession *session, NSError *error)
     {
       __block NSString *alertText;
       __block NSString *alertTitle;
       // No error. Check to see if permission was granted.
       if (!error)
       {
         // Permission was granted. Return no error.
         if ([self userHasPermissionForKey:FZFacebookPermissionKeyPublishActions])
         {
           if (inCompletionHandler)
             inCompletionHandler(nil);
         }
         else
         {
           // Permission was not granted, tell the user we will not publish content, return an error.
           alertTitle = @"Permission not granted";
           alertText = @"Your actions will not be published to Facebook.";
           [[[UIAlertView alloc] initWithTitle:alertTitle
                                       message:alertText
                                      delegate:self
                             cancelButtonTitle:@"OK!"
                             otherButtonTitles:nil] show];
           NSError *tmpError = [NSError errorWithDomain:@"FZPublishPermissionNotGranted" code:3018 userInfo:nil];
           
           if (inCompletionHandler)
             inCompletionHandler(tmpError);
         }
       }
       else
       {
         if (inCompletionHandler)
           inCompletionHandler(error);
       }
     }];
  }
}


+ (void)requestPermissionsWithArray:(NSArray *)permissionsNeededArray andCompletionHandler:(void (^)(NSError *inError))inCompletionHandler
{
  __block NSMutableArray	*permissionsToRequestArray = [[NSMutableArray alloc] initWithArray:@[]];
  //Double check current user permissions
  [self userHasPermissionsInArray:permissionsNeededArray withResults:^(NSMutableArray *resultsArray, NSError *error)
   {
     if (error)
     {
       NSLog(@"Error getting current permissions %@",error);
     }
     else
     {
       permissionsToRequestArray = resultsArray;
     }
   }];
  
  //If the requested permissions are not in current users permissions ask for access
  if ([permissionsToRequestArray count] > 0)
  {
    [FBSession.activeSession requestNewReadPermissions:permissionsToRequestArray completionHandler:^(FBSession *session, NSError *error)
     {
       if (!error)
       {
         // Permission granted
         inCompletionHandler(nil);
       }
       else
       {
         // Error See: https://developers.facebook.com/docs/ios/errors
         inCompletionHandler(error);
       }
     }];
  }
  else
  {
    // Permissions are already present
    inCompletionHandler(nil);
  }
}

+ (void)userHasPermissionsInArray:(NSArray *)permissionsNeededArray withResults:(void (^)(NSMutableArray *resultsArray,NSError *error))inResultsHandler
{
  [FBRequestConnection startWithGraphPath:@"/me/permissions"
                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
   {
     if (!error)
     {
       // These are the current permissions the user has:
       NSDictionary	*currentPermissions = [(NSArray *)[result data] objectAtIndex:0];
       
       NSMutableArray	*requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
       //Check if the permissions needed are not available in the current permissions
       for (NSString *permission in permissionsNeededArray)
       {
         if (![currentPermissions objectForKey:permission])
         {
           [requestPermissions addObject:permission];
         }
       }
       inResultsHandler(requestPermissions, nil);
     }
     else
     {
       inResultsHandler(nil,error);
     }
   }];
}
+ (BOOL)userHasPermissionForKey:(NSString *)inKey
{
  NSInteger tmpIndex = [FBSession.activeSession.permissions indexOfObject:inKey];
  return (tmpIndex != NSNotFound);
}

+ (void)showFacebookDialogForAction:(NSString *)inAction parameters:(NSMutableDictionary *)inParameters
{
  /*
   [[self sharedFacebook] dialog:inAction
   andParams:inParameters
   andDelegate:nil];
   */
}


#pragma mark -
#pragma mark Error Handling

+ (void)handleAuthenticationError:(NSError *)error
{
  NSString *alertText;
  NSString *alertTitle;
  if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
    // Error requires people using you app to make an action outside your app to recover
    alertTitle = @"Something went wrong";
    alertText = [FBErrorUtility userMessageForError:error];
    [self showMessage:alertText withTitle:alertTitle];
    
  } else {
    // You need to find more information to handle the error within your app
    if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
      //The user refused to log in into your app, either ignore or...
      alertTitle = @"Login cancelled";
      alertText = @"You need to login to access this part of the app";
      [self showMessage:alertText withTitle:alertTitle];
      
    } else {
      // All other errors that can happen need retries
      // Show the user a generic error message
      alertTitle = @"Something went wrong";
      alertText = @"Please retry";
      [self showMessage:alertText withTitle:alertTitle];
    }
  }
}

+ (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
  [[[UIAlertView alloc] initWithTitle:title
                              message:text
                             delegate:self
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil] show];
}

@end
