//
//  NSString+Fuzz.h
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//
// ARC_YES
#import "Fuzz.h"
#import <UIKit/UIKit.h>

@interface NSString (Fuzz) 

+ (NSString *)loremIpsum;
+ (NSString *)loremIpsumWithWords:(NSInteger)words;
+ (NSString *)loremIpsumWithSentences:(NSInteger)sentences;
+ (NSString *)loremIpsumWithParagraphs:(NSInteger)paragraphs;



+ (NSString*)randomCharacter;
+ (NSString*)randomStringWithRange:(NSRange)inRange;
+ (NSString*)randomStringWithMaxLength:(NSInteger)inLength;

+ (NSString*)base64forData:(NSData*)inData;

- (NSString *)md5;
- (NSString *)base64;
- (NSString *)urlEncodedString;


- (BOOL)isEmailAddress;

- (BOOL)isFilePath;

- (BOOL)isDirectoryPath;


/**
 *  Returns an object by using NSJSONSerialization
 *  to parse this instance of NSString. Errors are 
 *  logged to the console.
 *  @return An NSArray, NSDictionary, or nil
 */
- (id)jsonValue;

- (NSDictionary *)xmlValue;

#ifdef __IPHONE_7_0

/**
 * @description Returns an attributed HTML string for a given font.
 * @param font The desired base font attribute.
 * @return An attributed string formatted for HTML.
 *
 */
- (NSAttributedString *)attributedHTMLStringWithFont:(UIFont *)font;

/**
 * @description asynchroniously returns a mutable attributed HTML string for a given font.
 * @param font The desired base font attribute.
 * @param completion block to recieve the output
 * @return void
 *
 * Some Notes: this can take a while... so we have built this block verison to simplify the usage
 *  Also this doesn't always work, so the object returned by the completion block may be an error that was encountered
 */
- (void)attributedHTMLStringWithFont:(UIFont *)font withCompletion:(FZBlockWithObject)inCompletionBlock;


/**
 * @description asynchroniously returns a mutable attributed HTML string for a given font.
 * @param font The desired defualt font attribute.
 * @param color The desired defualt color attribute.
 * @param completion block to recieve the output
 * @return void
 *
 * Some Notes: this can take a while... so we have built this block verison to simplify the usage
 *  Also this doesn't always work, so the object returned by the completion block may be an error that was encountered
 */
- (void)attributedHTMLStringWithFont:(UIFont *)inFont color:(UIColor*)inColor withCompletion:(FZBlockWithObject)inCompletionBlock;



#endif
/**
 * @description A method for stripping HTML tags from a string.
 * @return The sender, stripped of HTML tags.
 *
 */
- (NSString *)stringByStrippingHTMLAttributes;




/**
 * @description A Convenience method for writing a string to a file 
 * at the given path and log errors to the console
 *
 */
- (void)writeToFile:(NSString*)inFilePath;



/**
 * @description A Convenience method for reading a string from a file
 * at the given path and log errors to the console.
 * @return contents of the file, nil of the file doesnt exist.
 */
+ (NSString*)stringFromFile:(NSString*)inFilePath;

@end
