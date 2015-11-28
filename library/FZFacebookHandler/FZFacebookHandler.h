//
//  FZFacebookHandler.h
//  FZModuleLibrary
//
//  Created by Christopher Luu on 7/21/12.
//  Copyright (c) 2012 Fuzz Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FacebookSDK/FBRequestConnection.h>

static NSString *const FZFacebookPermissionKeyEmail = @"email";
static NSString *const FZFacebookPermissionKeyInstalled = @"installed";
static NSString *const FZFacebookPermissionKeyPublishActions = @"publish_actions";
static NSString *const FZFacebookPermissionKeyUserFriends = @"user_friends";
static NSString *const FZFacebookPermissionKeyPublicProfile = @"public_profile";

/**
 `FZFacebookHandler` is a wrapper around the Facebook SDK that provides a standard interface to communicate with ever-changing Facebook SDK. Use it when you wish to login, share, and perform Facebook Graph API calls. Note that to use this handler, you must create a FZFacebookHandlerConfiguration.h file, the details of which are described in the FZFacebookHandler.h file.
 */

@interface FZFacebookHandler : NSObject

///---------------------------------------------
/// @name Facebook handler 
///---------------------------------------------


/**
 
 Initializes the handler for use in the current session.  The user must make sure that the proper credentials are entered into a file named FZFacebookHandlerConfiguration.h before calling this.
 
 @result The session is started and opened using the API key specified in FZFacebookHandlerConfiguration.h
 */

+ (void)setUpHandlerWithAppId:(NSString*)inAppId;

+ (void)setUpHandlerWithAppId:(NSString*)inAppId
			  readPermissions:(NSArray*)inReadpermissions
		   publishPermissions:(NSArray*)inPublishPermissions;

/*
 
 From the Facebook documentation:

 A helper method that is used to provide an implementation for
 [UIApplicationDelegate application:openURL:sourceApplication:annotation:]. It should be invoked during
 the Facebook Login flow and will update the session information based on the incoming URL.
 
 @param url The URL as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].
 */
+ (BOOL)handleOpenURL:(NSURL *)inURL;


/*
 
 From the Facebook documentation:
 
 A helper method that is used to provide an implementation for
 [UIApplicationDelegate applicationDidBecomeActive:] to properly resolve session state for
 the Facebook Login flow, specifically to support app-switch login.

 */
+ (void)handleDidBecomeActive;


/**
 
 Calls the isOpen method in the Facebook SDK's [FBSession activeSession] object.
 
 @return a Bool that indicates if the session has a logged-in user and is ready for use
 
 */
+ (BOOL)isLoggedIn;


/**
 
 If the user is logged-in, this will return the accessToken of the logged-in user's accessTokenData.  If the user is not logged-in, this function will return nil
 
 @return The logged-in user's access token as a string, and nil if there is no one logged-in
 */
+ (NSString *)accessToken;


/**
 
 Using the permission array stored in FZFacebookHandlerConfiguration.h, this method will attempt to open an active session that will allow the login UI to appear.  Once a response is received from Facebook, the supplied code block will be called with the results.  If the user is already logged in, the code block will be called immediately with a "yes" response.
 
 @param inCompletionBlock The block of code to be executed when the network request returns.  inSuccess will represent whether or not the session was successfully opened, and if needed, and error is passed as well.
 
 */
+ (void)loginWithCompletionBlock:(void (^)(BOOL inSuccess, NSError *inError))inCompletionBlock;

/**
 
 Logs the user out, closes the session, and clears any cached tokens
 
 */
+ (void)logout;


/**
 
 Handles GET and POST actions to Facebook.  The FZFacebookHandlerConfigurationReadPermissionArray and FZFacebookHandlerConfigurationPublishPermissionArray are used for GET and POST commands, respectfully.  These are located in the project-specific FZFacebookHandlerConfiguration.h file.  If the relevant permissions are not valid, then this handler will attempt to update them and, if successful, execute the original request.  If the user is not logged-in, this function returns nil immediately. The request uses
 the active session represented by `[FBSession activeSession]`.
 
 @param inGraphPath        The Graph API endpoint to use for the request, for example "me".
 
 @param inParameters       The parameters for the request. A value of nil sends only the automatically handled parameters, for example, the access token. The default is nil.
 
 @param inHTTPMethod       The HTTP method to use for the request. A nil value implies a GET.
 
 @param inCompletionHandler          The handler block to call when the request completes with a success, error, or cancel action.
 
 */
+ (FBRequestConnection *)connectionForRequestWithGraphPath:(NSString *)inGraphPath parameters:(NSDictionary *)inParameters HTTPMethod:(NSString *)inHTTPMethod completionHandler:(FBRequestHandler)inCompletionHandler;

/**
 * @description A method for requesting publication permissions. It is recommended to request permission before attempting to publish user content.
 * @param inCompletionHandler If an error has occured, it is returned. Otherwise, nil is returned.
 *
 */
+ (void)requestPublishPermissionsWithCompletionHandler:(void (^)(NSError *inError))inCompletionHandler;

/**
 * @description A method for requesting multiples permissions in an array. This first compares the permissions needed to current user permissions.
 * @param inCompletionHandler If an error has occured, it is returned. Otherwise, nil is returned.
 *
 */

+ (void)requestPermissionsWithArray:(NSArray *)permissionsNeeded andCompletionHandler:(void (^)(NSError *inError))inCompletionHandler;


/**
 * @description A method for performing a simple, client-side permission-check.
 * @param inKey A Facebook permission key. Constants are defined in FZFacebookHandler.h for reference.
 * @return BOOL YES if the user has permission for key, NO if user does not.
 *
 */
+ (BOOL)userHasPermissionForKey:(NSString *)inKey;


/**
 * @description A method wrapping a feed post. If the parameter is not required by the Facebook API, passing nil is acceptable.
 * @param inName The name of the post.
 * @param inDescription A description of the post.
 * @param inLink A link included in the post.
 * @param inImageURL The url of an image to be included in the post.
 * @param inCompletionHandler A block for responding to the results of the post.
 */
+ (void)postFeedItemWithName:(NSString *)inName caption:(NSString *)inCaption description:(NSString *)inDescription link:(NSString *)inLink imageURL:(NSString *)inImageURL completionHandler:(FBRequestHandler)inCompletionHandler;

+ (void)showFacebookDialogForAction:(NSString *)inAction parameters:(NSMutableDictionary *)inParameters;

@end
