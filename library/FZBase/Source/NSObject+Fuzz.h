//
//  NSObject+Fuzz.h
//
//  Created by Fuzz Productions on 11/6/13.

#import <Foundation/Foundation.h>
#import "Fuzz.h"
/**
 *  NSObject
 *  The Fuzz category on NSObject, this adds convenience methods for
 *  handling NSNotifications,Key Value Observing, 
 *  exposes methods for associating objects. 
 *  The Notifications and KVO methods are designed to handle cases where 
 *  either the sender or receiver objects are deallocated before
 *	the observation relationship is terminated and the notificatio or kvo is triggered.
 *	This situation will crash using standard techniques, this aims to be like ARC
 *  for Notification and KVO.
 */

// ARC_NO

@interface NSObject (Fuzz)
#pragma mark -Notifications
/*------------------------------------------------------------------------
 
                            Notifications
 
 --------------------------------------------------------------------------*/
/**
 *  Register to receive a notification and respond with a selector
 *
 *  @param notification The notification
 *  @param selector     The response method
 */
- (void)observeNotification:(NSString*)notification withSelector:(SEL)selector;

/**
 *  Register to receive a notification and respond with a block
 *
 *  @param notification The notification
 *  @param selector     The response block
 */
- (void)observeNotification:(NSString*)notificationName withBlock:(FZBlockWithNotification)inBlock;


/**
 *  Unregister all notifications
 */
- (void)stopObservingNotifications;

/**
 *  Unregister notifications from all objects with the provided name
 *
 *  @param notification the notification being observed
 */
- (void)stopObservingNotification:(NSString*)inNotification;

/**
 *  Distribute an NSNotification through the default NSNotificationCenter
 *
 *  @param notification the notification to send
 */
- (void)sendNotification:(NSString *)notification;

/**
 *  Distribute an NSNotification through the default NSNotificationCenter
 *
 *  @param notification the notification to send
 *  @param inInfo       the related info dictionary
 */
- (void)sendNotification:(NSString *)notification withInfo:(NSDictionary *)inInfo;


/**
 *  Print to the console a list of currently registered notifications
 */
- (void)logNotifications;


#pragma mark -Key Value Observing
/*------------------------------------------------------------------------

                        Key Value Observing
 
--------------------------------------------------------------------------*/
/**
 *  Register to observe a property of the given object and respond with a selector
 *
 *  @param inObject   The object to be observed
 *  @param inKeyPath  the property of the object to observe
 *  @param inSelector the method to reponse with
 */
- (void)observeObject:(NSObject*)inObject forKeyPath:(NSString*)inKeyPath withSelector:(SEL)inSelector;

/**
 *  Register to observe a property of the given object and respond with a selector
 *
 *  @param inObject   The object to be observed
 *  @param inKeyPath  The property of the object to observe
 *  @param inBlock    the block to reponse with
 */
- (void)observeObject:(NSObject*)inObject forKeyPath:(NSString*)inKeyPath withBlock:(FZBlockWithDictionary)inBlock;

/**
 *  Remove all KVO relationships
 */
- (void)stopObservingObjectKeyPaths;

/**
 *  Remove KVO relationships with the given object
 */
- (void)stopObservingObject:(NSObject*)inObject;

/**
 *  Remove all KVO relationships with the given object and the property at the keypath
 */
- (void)stopObservingObject:(NSObject*)inObject forKeyPath:(NSString*)keyPath;

/**
 *  Print to the console a list of currently registered KVO properties
 */
- (void)logObservations;


#pragma mark -Instrospection
/*------------------------------------------------------------------------
 
                            Instrospection
 
 --------------------------------------------------------------------------*/

/**
 *  Log to the console the classes variables and properties
 */
+ (void)logIVarsPropertiesAndMethods;

/**
 *  @return A dictionary of instance variables for a class
 */
+ (NSDictionary *)ivarDictionary;

/**
 *  @return the instance variables and values
 */
+ (NSDictionary *)propertyDictionary;

/**
 *  @return A dictionary of properties for the instance
 */
- (NSDictionary *)propertyDictionary;


#pragma mark -Associated Objects
/*------------------------------------------------------------------------
 
                            Associated Objects
 
 --------------------------------------------------------------------------*/
/**
 *  Set Associated Object For Key
 *  The associated object will be retained automatically and released when this object is deallocated.
 *  This is similar to a collection, and all blocks should be copied before being associated. 
 *  Keys must be unique.
 *  @param inObject the object to be associated
 *  @param inKey    a unique identifier
 */
- (void)setAssociatedObject:(id)inObject forKey:(NSString*)inKey;


/**
 *  Get an associated object
 *
 *  @param inKey the unique identifier of the object
 *
 *  @return the object associated with the given key
 */
- (id)getAssociatedObjectForKey:(NSString*)inKey;


/**
 *  Remove an indivisual associated object
 *
 *  @param inKey The unique idetifier of the object
 */
- (void)removeAssociatedObjectForKey:(NSString*)inKey;

/**
 *  Remove all associated Objects
 */
- (void)removeAssociatedObjects;

@end
