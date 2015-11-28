//
//  NSDictionary+Fuzz.h
//  Pods
//
//  Created by Sean Orelli on 12/5/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Fuzz)
- (NSString *)urlQueryString;

/**
 
 Fetch a localized or default value for a key in a dictionary conforming to Nick's Localized JSON Format.
 https://confluence.fuzzhq.com/display/FUZZ/Localized+JSON?showComments=true&focusedCommentId=12913560#comment-12913560
 
 
 
 Sample
 http://plop.s3.amazonaws.com/versions/NYPost_handset.json
 
 @prarms inKey a localize in this dictionary
 */
-(NSString*)localizedStringValueForKey:(NSString*)inKey;

@end