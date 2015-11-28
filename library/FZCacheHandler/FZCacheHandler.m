//
//  FZCacheHandler.m
//  FZModuleLibrary
//
//  Created by Christopher Luu on 3/16/12.
//  Copyright (c) 2012 Fuzz Productions. All rights reserved.
//

#import "FZCacheHandler.h"

static NSCache *sharedCache;

@implementation FZCacheHandler

#pragma mark -
#pragma mark Instance methods
+ (NSCache *)sharedCache
{
	@synchronized (self)
	{
		if (!sharedCache)
			sharedCache = [[NSCache alloc] init];
		return sharedCache;
	}
}

+ (void)destroyCache
{
	@synchronized (self)
	{
		sharedCache = nil;
	}
}

#pragma mark -
#pragma mark Convienence methods
+ (void)setObject:(id)inObject forKey:(id)inKey
{
	[[self sharedCache] setObject:inObject forKey:inKey];
}

+ (void)removeObjectForKey:(id)inKey
{
	[[self sharedCache] removeObjectForKey:inKey];
}

+ (void)removeAllObjects
{
	[[self sharedCache] removeAllObjects];
}

+ (id)objectForKey:(id)inKey
{
	return [[self sharedCache] objectForKey:inKey];
}

@end
