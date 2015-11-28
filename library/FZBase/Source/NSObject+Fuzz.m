//
//  NSObject+Fuzz.m
//
//  Created by Fuzz Productions on 11/6/13.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "NSObject+Fuzz.h"
#import <objc/runtime.h>
#import "Fuzz.h"
/*
 
 notificationsDictionary
    reponseObjectsArray
 
 observatiobnsDictionary
    stateDic
 
 */
@class FZAssociatedObject;



@interface NSObject (FZAssociatedObject)
-(FZAssociatedObject*)associatedObject;
@end


/**
 *  Associated Object
 */
@interface FZAssociatedObject : NSObject
@property (nonatomic, assign)NSObject *owner;
@property (nonatomic, retain)NSMutableDictionary *notificationsDictionary;
@property (nonatomic, retain)NSMutableDictionary *observationsDictionary;
@property (nonatomic, retain)NSMutableDictionary *associationsDictionary;
@property  bool active;
@end


/**
 *  Associated Notification Observer
 *  An object representation of a KVO relationship,
 *  The observed object must have a property
 *  whose name is equal to the keypath
 *  the response object is either a selector or a block
 */
@interface FZAssociatedNotificationObserver : NSObject
@property (nonatomic, assign)NSString *notification;
@property (nonatomic, retain)id responseObject;
-(id)initWithNotification:(NSString*)inNotificaton responseObject:(id)inResponseObject;
@end
@implementation FZAssociatedNotificationObserver
-(id)initWithNotification:(NSString*)inNotification responseObject:(id)inResponseObject
{
    self = [super init];
    if(self)
    {
        self.notification = inNotification;
        if([inResponseObject isKindOfClass:NSClassFromString(@"NSBlock")])
            self.responseObject = [[inResponseObject copy] autorelease];
        else
            self.responseObject = inResponseObject;
    }
    return self;
}
@end


/**
 *  Associated Key Path Observer
 *  An object representation of a KVO relationship,
 *  The observed object must have a property
 *  whose name is equal to the keypath
 *  the response object is either a selector or a block
 */
@interface FZAssociatedKeyPathObserver : NSObject
@property (nonatomic, assign)NSObject *observedObject;
@property (nonatomic, assign)NSString *keypath;
@property (nonatomic, retain)id responseObject;
- (instancetype)initWithObject:(id)inObject keyPath:(NSString*)inKeyPath responseObject:(id)inResponseObject;
@end
@implementation FZAssociatedKeyPathObserver

- (instancetype)initWithObject:(id)inObject keyPath:(NSString*)inKeyPath responseObject:(id)inResponseObject
{
    self = [super init];
    if (self)
    {
        self.keypath = inKeyPath;
        self.observedObject = inObject;
        
        if([inResponseObject isKindOfClass:NSClassFromString(@"NSBlock")])
            self.responseObject = [[inResponseObject copy] autorelease];
        else
            self.responseObject = inResponseObject;

    }
    return self;
}
@end









@implementation FZAssociatedObject
/**
 *  Fuzz Associated Object Constructor
 *  sets the active flag to YES
 *  @return self, the instance created
 */
-(id)init
{
    self = [super init];
    _active = YES;
	self.associationsDictionary = [NSMutableDictionary dictionary];

    return self;
}

/**
 *  The destructor method
 *  Sets the active property to NO, and this triggers the KVO
 *  removal method on all objects that are observing the owner 
 *  of this associated object. All observation objects are removed
 *  from the local notifications and observations collections,
 *  the owner property is set to nil
 */
-(void)dealloc
{
    self.active = NO;
    
    if(self.observationsDictionary)
    {
        [self stopObservingObjectKeyPaths];
        self.observationsDictionary = nil;
    }
	
    if(self.notificationsDictionary)
    {
        [self stopObservingNotifications];
        self.observationsDictionary = nil;
    }
	
	if(self.associationsDictionary)
	{
		[self.associationsDictionary removeAllObjects];
		self.associationsDictionary = nil;
	}
    self.owner = nil;
    
	[super dealloc];
}
/**
 *  A generic logging method to be used for both Notifications and KVO logging to the console
 *  This can be used to list the current registered observations and their response objects, either
 *  a selector or a block. Currently the selectors are listed by their method name and the block 
 *  reponses are all listed as "Block"
 *
 *  @param inMessage The prefixed message
 *  @param inEvent   The event being logged
 *  @param inObject  the response object, either a selector or block
 */
-(void)logResponse:(NSString *)inMessage ForEvent:(NSString*)inEvent withObject:(id)inObject
{
    if (inObject == nil)
    {
        DLog(@"NIL %@: %@", inMessage, inEvent);
        return;
    }
    
    if([inObject isKindOfClass:[NSString class]])
    {
        DLog(@"%@ = %@:  %@",inMessage, inEvent, inObject);
    }
    

    if([inObject isKindOfClass:NSClassFromString(@"NSBlock")])
    {
        DLog(@"%@ = %@:  %@", inMessage, inEvent,@"Block");
    }
    
}




#pragma mark -
/**
 *  Use this method to get a collection of objects representing the
 *  current subscribed notifications for this NSObject
 *  @return The collection of FZAssociatedNotificationObjects
 */
-(NSMutableDictionary*)notificationsDictionary
{

    if(_notificationsDictionary == nil)
        self.notificationsDictionary = [NSMutableDictionary dictionary];
    
    return _notificationsDictionary;
}


/**
 *  Print to the console a list of currently subscribed Notifications
 *  and their response objects, either a selector or a block
 */
-(void)logNotifications
{
    if(_notificationsDictionary != nil)
    for(NSString *notification in [self.notificationsDictionary allKeys])
        for(FZAssociatedNotificationObserver *obj in self.notificationsDictionary[notification])
            [self logResponse:@"Notification " ForEvent:notification withObject:obj.responseObject];
 
}

//---------------------
-(void)observeNotification:(NSString*)notificationName withResponseObject:(id)inResponseObject
{
    FZAssociatedNotificationObserver *observer =
    [[FZAssociatedNotificationObserver alloc] initWithNotification:notificationName responseObject:inResponseObject];
    
    NSMutableArray *tmp = (NSMutableArray*)self.notificationsDictionary[notificationName];
    if(tmp == nil)
    {
        self.notificationsDictionary[notificationName] = [NSMutableArray array];
        tmp = self.notificationsDictionary[notificationName];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeNotification:) name:notificationName object:nil];
    }

    [tmp addObject:observer];
	[observer release];
}


//---------------------
-(void)observeNotification:(NSNotification*)inNotification
{
    id thing = self.notificationsDictionary[inNotification.name];
    if([thing isKindOfClass:[NSMutableArray class]])
        for(FZAssociatedNotificationObserver *observer in thing)
            [self respondToNotifcation:inNotification withObject:observer.responseObject];
}


//---------------------
-(void)respondToNotifcation:(NSNotification*)inNotification withObject:(id)inObject
{
    
    
    if (inObject == nil)
    {
        DLog(@"NIL response object for notification: %@", inNotification.name);
        return;
    }
    
    if([inObject isKindOfClass:[NSString class]])
    {
		mainQueue(^
		{
			SEL aSel = NSSelectorFromString(inObject);
			if([self.owner respondsToSelector:aSel])
				[self.owner performSelector:aSel withObject:inNotification];
		});
    }
    
    if([inObject isKindOfClass:NSClassFromString(@"NSBlock")])
    {
		mainQueue(^
		{
			void(^tmpBlock)(NSNotification*) = inObject;
			tmpBlock(inNotification);
		});
    }
    
}


//---------------------
-(void)stopObservingNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[self notificationsDictionary] removeAllObjects];
}

//---------------------
-(void)stopObservingNotification:(NSString*)inNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:inNotification object:nil];
    [self.notificationsDictionary removeObjectForKey:inNotification];
}

#pragma mark -
//---------------------
-(NSMutableDictionary*)observationsDictionary
{
    if(_observationsDictionary == nil)
        self.observationsDictionary = [NSMutableDictionary dictionary];
    
    return _observationsDictionary;
}


/**
 *  Print to the console a list of currently registered KVO relationships
 *  and their response objects, either a selector or a block
 */
-(void)logObservations
{
    if(_observationsDictionary != nil)
    for(NSString *observation in [self.observationsDictionary allKeys])
        for(FZAssociatedKeyPathObserver *observer in self.observationsDictionary[observation])
            [self logResponse:@"Observation " ForEvent:observation withObject:observer.responseObject];
}



//---------------------
-(bool)isObserving:(NSObject*)inObject forKeyPath:(NSString*)inKeyPath
{
    if(inObject == nil)
        return NO;
    
    if(inKeyPath == nil)
        return NO;
    
    if(_observationsDictionary == nil)
        return NO;
    
    NSMutableArray *tmp = (NSMutableArray*)self.observationsDictionary[inKeyPath];
    if(tmp == nil)
        return NO;

    for(FZAssociatedKeyPathObserver *observer in tmp)
        if(observer.observedObject == inObject)
            if([observer.keypath isEqualToString:inKeyPath])
                return YES;

    return NO;
}


//---------------------
- (void)observeObject:(NSObject*)inObject forKeyPath:(NSString*)inKeyPath withResponseObject:(id)inResponseObject
{
    
    FZAssociatedKeyPathObserver *observer =
    [[FZAssociatedKeyPathObserver alloc] initWithObject:inObject keyPath:inKeyPath responseObject:inResponseObject];


    
    if(![self isObserving:inObject forKeyPath:inKeyPath])
    {
        [inObject addObserver:self forKeyPath:inKeyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
 
        //if(![self isObserving:[inObject associatedObject] forKeyPath:@"active"])
        [[inObject associatedObject] addObserver:self forKeyPath:@"active" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];

    }
    
    
    NSMutableArray *tmp = self.observationsDictionary[inKeyPath];
    if(tmp == nil)
    {
        self.observationsDictionary[inKeyPath]= [NSMutableArray array];
        tmp = self.observationsDictionary[inKeyPath];
    }
    [tmp addObject:observer];

    [observer release];
}



//---------------------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([object isKindOfClass:[FZAssociatedObject class]])
    {
        if([keyPath isEqualToString:@"active"])
        {
            FZAssociatedObject *tmp = (FZAssociatedObject*)object;
            if(!tmp.active)
            {
                [self stopObservingObject:tmp.owner];
                [self removeSelfAsObserverOfObject:tmp forKeyPath:@"active"];
            }
        }
    }
    else
    {
        for(FZAssociatedKeyPathObserver *tmp in self.observationsDictionary[keyPath])
            [self respondToKVO:object forKeyPath:keyPath withObserver:tmp andValues:change];
    }
 }

//---------------------
-(void)respondToKVO:(NSObject*)inObject forKeyPath:(NSString*)inKeyPath withObserver:(FZAssociatedKeyPathObserver*)inObserverObject andValues:(NSDictionary*)inChangeDictionary
{
    
    if (inObserverObject == nil)
    {
        //DLog(@"NIL response object for keyPath: %@", inKeyPath);
        return;
    }
    
    if(inObserverObject.observedObject != inObject)
    {
        //DLog(@"NIL NIL NIL");
        return;
    }
    
    id responseObject = inObserverObject.responseObject;
    if (responseObject == nil)
    {
        DLog(@"NIL response object for keyPath: %@", inKeyPath);
        
        return;
    }
    
    
    
	NSMutableDictionary *responseDictionary = [NSMutableDictionary dictionaryWithDictionary:inChangeDictionary];
	responseDictionary[@"observed keypath" ] = inKeyPath;
    responseDictionary[@"observed object"] = inObserverObject.observedObject;

    if([responseObject isKindOfClass:[NSString class]])
    {
        mainQueue(^
		{
			SEL aSel = NSSelectorFromString(responseObject);
			if([self.owner respondsToSelector:aSel])
				[self.owner performSelector:aSel withObject:responseDictionary];
		});
    }
    
    if([responseObject isKindOfClass:NSClassFromString(@"NSBlock")])
    {
        mainQueue(^
		{
			void(^tmpBlock)(NSDictionary*) = responseObject;
			tmpBlock(responseDictionary);
		});
    }
    
}

-(void)removeSelfAsObserverOfObject:(NSObject*)inObject forKeyPath:(NSString*)inKeyPath
{
    if([inObject respondsToSelector:@selector(removeObserver:forKeyPath:)])
    {
        [inObject removeObserver:self forKeyPath:inKeyPath];
        
        NSMutableArray *observers = (NSMutableArray*)self.observationsDictionary[inKeyPath];
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        for(FZAssociatedKeyPathObserver *tmp in observers)
            if(tmp.observedObject != inObject)
                [tmpArray addObject:tmp];

        [self.observationsDictionary setObject:tmpArray forKey:inKeyPath];
    }
    else
        DLog(@"There was a problem removing the observer for keypath:%@", inKeyPath);
}
//---------------------
-(void)stopObservingObjectKeyPaths;
{
  
    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithCapacity:self.observationsDictionary.count];
    
    
    for(NSString *observation in [self.observationsDictionary allKeys])
    {
        NSMutableArray *observers = self.observationsDictionary[observation];
    
        NSMutableArray *tmpArray = [NSMutableArray array];
        tmp[observation] = tmpArray;
        for(FZAssociatedKeyPathObserver *observer in observers)
            if(![tmpArray containsObject:observer.observedObject])
                [tmpArray addObject:observer.observedObject];
 
        [observers removeAllObjects];
    }
    
    
    for(NSString *observation in [tmp allKeys])
        for(NSObject *observed in tmp[observation])
            [self removeSelfAsObserverOfObject:observed forKeyPath:observation];
    
    [self.observationsDictionary removeAllObjects];
}


- (void)stopObservingObject:(NSObject*)inObject
{
    
    
    if(inObject == nil)
        return;
    
    NSMutableDictionary *keyPaths = [NSMutableDictionary dictionary];
    
    for(NSString *key in self.observationsDictionary)
        for(FZAssociatedKeyPathObserver *tmp in self.observationsDictionary[key])
            if(tmp.observedObject == inObject)
                [keyPaths setValue:key forKey:key];
        
    
    for(NSString *key in [keyPaths allKeys])
        [self stopObservingObject:inObject forKeyPath:key];
    
}

//---------------------
- (void)stopObservingObject:(NSObject*)inObject forKeyPath:(NSString*)keyPath
{
    if(inObject == nil)
        return;
    
    if(keyPath == nil)
        return;
    
    NSMutableArray *observers = (NSMutableArray*)self.observationsDictionary[keyPath];
    NSMutableArray *tmpArray = [NSMutableArray array];
        
    for(FZAssociatedKeyPathObserver *tmp in observers)
        if(tmp.observedObject == inObject)
            [tmpArray addObject:tmp];

    for(FZAssociatedKeyPathObserver *observer in tmpArray)
        [observers removeObject:observer];
        

    if(tmpArray.count > 0)
        [self removeSelfAsObserverOfObject:inObject forKeyPath:keyPath];

    
}



@end




#pragma mark -

/**
 *  NSObject (Fuzz)
 */
@implementation NSObject(FZAssociatedObject)
-(FZAssociatedObject*)associatedObject
{
    FZAssociatedObject *tmp = (FZAssociatedObject*)objc_getAssociatedObject(self,@selector(associatedObject));
    if(tmp == nil)
    {
        tmp = [[FZAssociatedObject alloc] init];
        tmp.owner = self;
        tmp.observationsDictionary	= nil;
        tmp.notificationsDictionary = nil;
        tmp.associationsDictionary	= nil;
		objc_setAssociatedObject(self, @selector(associatedObject), tmp, OBJC_ASSOCIATION_RETAIN);
		
		[tmp release];
    }
    return tmp;
}
@end

/**
 *  Category on NSObject that adds convenience methods for
 *  NSNotifications and KVO observing
 *  An associated object is used to maintain
 *  a list of notifications and objects being observed
 *  calls to this cateogry are forwared to the 
 *  FZAssociatedObject
 */
@implementation NSObject (Fuzz)



#pragma mark Associated Objects
-(void)setAssociatedObject:(id)inObject forKey:(NSString*)inKey
{
	if([[self associatedObject] associationsDictionary] == nil)
		[self associatedObject].associationsDictionary = [NSMutableDictionary dictionary];

	[[[self associatedObject] associationsDictionary] setObject:inObject forKey:inKey];
}

-(id)getAssociatedObjectForKey:(NSString*)inKey
{
	return [[[self associatedObject] associationsDictionary] objectForKey:inKey];
}

-(void)removeAssociatedObjectForKey:(NSString*)inKey
{
	[[[self associatedObject] associationsDictionary] removeObjectForKey:inKey];

}
-(void)removeAssociatedObjects
{
	[[[self associatedObject] associationsDictionary] removeAllObjects];
}

#pragma mark - Notifications
-(void)observeNotification:(NSString*)notification withSelector:(SEL)selector
{
    [[self associatedObject] observeNotification:notification withResponseObject:NSStringFromSelector(selector)];
}
-(void)observeNotification:(NSString*)notification withBlock:(FZBlockWithNotification)inBlock
{
	[[self associatedObject] observeNotification:notification withResponseObject:inBlock];//[inBlock copy]];
}

-(void)logNotifications
{
    [[self associatedObject] logNotifications];
}


-(void)sendNotification:(NSString *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

-(void)sendNotification:(NSString *)notification withInfo:(NSDictionary *)inInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self userInfo:inInfo];
}

-(void)stopObservingNotifications
{
    [[self associatedObject] stopObservingNotifications];
}
-(void)stopObservingNotification:(NSString*)inNotification
{
    [[self associatedObject] stopObservingNotification:inNotification];
}


#pragma mark - KVO

- (void)observeObject:(NSObject*)inObject forKeyPath:(NSString*)inKeyPath withSelector:(SEL)inSelector
{
    [[self associatedObject] observeObject:inObject forKeyPath:inKeyPath withResponseObject:NSStringFromSelector(inSelector)];
}

- (void)observeObject:(NSObject*)inObject forKeyPath:(NSString*)inKeyPath withBlock:(FZBlockWithDictionary)inBlock
{
	[[self associatedObject] observeObject:inObject forKeyPath:inKeyPath withResponseObject:inBlock];//[inBlock copy]];
}
-(void)logObservations
{
    [[self associatedObject] logObservations];
}

-(void)stopObservingObjectKeyPaths;
{
    [[self associatedObject] stopObservingObjectKeyPaths];
}

- (void)stopObservingObject:(NSObject*)inObject
{
    [[self associatedObject] stopObservingObject:inObject];
}

- (void)stopObservingObject:(NSObject*)inObject forKeyPath:(NSString*)keyPath
{
    [[self associatedObject] stopObservingObject:inObject forKeyPath:keyPath];
}


#pragma mark - Introspection
/**
 *  Print to the console the 
 *  instance variables and
 *  methods of the class
 */
+ (void)logIVarsPropertiesAndMethods
{
    NSDictionary *tmpIVarsDict      = [[self class] ivarDictionary];
    NSDictionary *tmpMethodsDict    = [[self class] methodDictionary];
    NSDictionary *tmpPropertiesDict = [[self class] propertyDictionary];
    
    __unused NSDictionary *tmpClassDump = @{
                                   @"ivars" : [tmpIVarsDict allKeys],
                                   @"properties" : [tmpPropertiesDict allKeys],
                                   @"methods" : [tmpMethodsDict allKeys]
                                   };
    
    DLog(@"%@", tmpClassDump);
}




+ (NSDictionary *)ivarDictionary
{
    u_int tmpCount;
    
    Ivar *tmpIVars = class_copyIvarList([self class], &tmpCount);
    NSMutableDictionary *tmpIVarDictionary = [NSMutableDictionary dictionaryWithCapacity:tmpCount];
    for (int i = 0; i < tmpCount ; i++)
    {
        const char *tmpIVarName = ivar_getName(tmpIVars[i]);
        [tmpIVarDictionary setObject:[NSValue value:&tmpIVars[i] withObjCType:@encode(Ivar)] forKey:[NSString stringWithCString:tmpIVarName encoding:NSUTF8StringEncoding]];
    }
    free(tmpIVars);
    
    return [NSDictionary dictionaryWithDictionary:tmpIVarDictionary];
}



+ (NSDictionary *)propertyDictionary
{
    u_int tmpCount;
    
    objc_property_t *tmpProperties = class_copyPropertyList([self class], &tmpCount);
    NSMutableDictionary *tmpPropertyDictionary = [NSMutableDictionary dictionaryWithCapacity:tmpCount];
    for (int i = 0; i < tmpCount ; i++)
    {
        const char *tmpPropertyName = property_getName(tmpProperties[i]);
        [tmpPropertyDictionary setObject:[NSValue value:&tmpProperties[i] withObjCType:@encode(objc_property_t)] forKey:[NSString stringWithCString:tmpPropertyName encoding:NSUTF8StringEncoding]];
    }
    free(tmpProperties);
    
    return [NSDictionary dictionaryWithDictionary:tmpPropertyDictionary];
}



+ (NSDictionary *)methodDictionary
{
    u_int tmpCount;
    
    Method *tmpMethods = class_copyMethodList([self class], &tmpCount);
    NSMutableDictionary *tmpMethodDictionary = [NSMutableDictionary dictionaryWithCapacity:tmpCount];
    for (int i = 0; i < tmpCount ; i++)
    {
        SEL tmpSelector = method_getName(tmpMethods[i]);
        const char *tmpMethodName = sel_getName(tmpSelector);
        [tmpMethodDictionary setObject:[NSValue value:&tmpMethods[i] withObjCType:@encode(Method)] forKey:[NSString stringWithCString:tmpMethodName encoding:NSUTF8StringEncoding]];
    }
    free(tmpMethods);
    
    return [NSDictionary dictionaryWithDictionary:tmpMethodDictionary];
}


-(NSDictionary*)propertyDictionary
{
    NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
    for(NSString *k in [[[self class] propertyDictionary] allKeys])
        [tmp setValue:[self valueForKey:k] forKey:k];
    
    return tmp;

}




-(NSDictionary*)ivarDictionary
{
    u_int tmpCount;
    Ivar *tmpIVars = class_copyIvarList([self class], &tmpCount);
    NSMutableDictionary *tmpIVarDictionary = [NSMutableDictionary dictionaryWithCapacity:tmpCount];
    for (int i = 0; i < 3; i++)
    {
        const char *tmpIVarName = ivar_getName(tmpIVars[i]);
        
        NSString *key = [NSString stringWithCString:tmpIVarName encoding:NSUTF8StringEncoding];
        
        DLog(@"Key = %@", key);
        
        
        //Some useful functions
        //const char * ivar_getTypeEncoding(Ivar ivar)
        void *outValue=0;
        
        __unused Ivar tm = object_getInstanceVariable(self, tmpIVarName, outValue);
        id obj = nil;
        /*
         
         here we need to check the type of the Ivar
         then use the value pointer to cast the object
         
         obj = (NSNumber*)
         obj = (NSString*)
         etc.
         */
        
        if(obj == nil)
            obj = [NSNull null];
        
        [tmpIVarDictionary setObject:obj forKey:key];
        
    }
    free(tmpIVars);
    return [NSDictionary dictionaryWithDictionary:tmpIVarDictionary];
}


@end
