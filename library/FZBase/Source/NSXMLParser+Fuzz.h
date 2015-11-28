//
//  NSXMLParser+Fuzz.h
//  FZModuleLibrary
//
//  Created by Sean Orelli on 8/22/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSXMLParser (Fuzz)
+ (NSDictionary*)parseData:(NSData*)inData;
+ (NSDictionary*)parseString:(NSString*)inString;
@end
