//
//  FZCacheHandler.h
//  FZModuleLibrary
//
//  Created by Christopher Luu on 3/16/12.
//  Copyright (c) 2012 Fuzz Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `FZCacheHandler` is a wrapper for NSCache that uses a shared NSCache instance
 */

@interface FZCacheHandler : NSObject

///-------------------------------
/// @name Accessing The Shared Instance
///-------------------------------

/**
  Access the shared cache instance
 
  @return An `NSCache` shared instance
 */
+ (NSCache *)sharedCache;

/**
  Release the shared NSCache instance and set the reference to nil
 */
+ (void)destroyCache;

///-------------------------------
/// @name Convenience methods
///-------------------------------

/**
  Set the value of the specified key in the cache
 
  @param inObject The object to be stored in the cache
  @param inKey    The key with which to associate the value
 */
+ (void)setObject:(id)inObject forKey:(id)inKey;



/**
  Removes the value of the specified key in the cache.
 
  @param inKey The key identifying the value to be removed.
 */
+ (void)removeObjectForKey:(id)inKey;



/**
  Empties the cache.
 */
+ (void)removeAllObjects;

/**
  Returns the value associated with a given key.

  @param inKey An object identifying the value.

  @return The value associated with key, or NULL if no value is associated with key. The caller does not have to release the value returned to it.
 */
+ (id)objectForKey:(id)inKey;

@end
