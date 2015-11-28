//
//  NSString+Fuzz.m
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//

#import "NSString+Fuzz.h"
#import <CommonCrypto/CommonDigest.h>
#import "Fuzz.h"
#import "NSFileManager+Fuzz.h"
#import "NSXMLParser+Fuzz.h"
#import "NSError+Fuzz.h"
#import "UIColor+Fuzz.h"

@implementation NSString (Fuzz)
//-------------------------------- NSString+LoremIpsum
/*
 NSString+LoremIpsum Gracefully borrowed from Timothy Donnelly. Thanks Tim!
 Created by Timothy Donnelly on 1/18/13.
 This source code is licenced under The MIT License:
 */
+ (NSString *)loremIpsum
{
	return [[self class] loremIpsumWithParagraphs:1];
}

+ (NSString *)loremIpsumWithWords:(NSInteger)words
{
	return [[self class] loremIpsumWithWords:words insertComma:NO];
}
+ (NSString *)loremIpsumWithWords:(NSInteger)words insertComma:(BOOL)insertComma
{
	static NSArray *loremIpsumWords;
	if (!loremIpsumWords)
	{
		
		loremIpsumWords =
		@[ @"duis",@"mollis",@"est",@"non",@"commodo",@"luctus",@"nisi",@"erat",
		   @"porttitor",@"ligula",@"eget",@"lacinia",@"odio",@"sem",@"nec",@"elit",
		   @"consectetur",@"adipiscing",@"elit",@"nulla",@"vitae",@"elit",@"libero",@"a",
		   @"pharetra",@"augue",@"aenean",@"lacinia",@"bibendum",@"nulla",@"sed",@"consectetur",
		   @"nullam",@"id",@"dolor",@"nibh",@"ultricies",@"vehicula",@"ut",@"id",@"elit",
		   ];
	}
	NSMutableString *str = [[NSMutableString alloc] init];
	
	NSInteger commaIndex = words/2;
	
	for (int i=0; i < words; i++)
	{
		NSInteger wordIndex = arc4random() % [loremIpsumWords count];
		NSString *word = [loremIpsumWords objectAtIndex:wordIndex];
		[str appendString:word];
		
		if (insertComma && commaIndex == i)
		{
			[str appendString:@","];
		}
		
		if (i < words-1)
		{
			[str appendString:@" "];
		}
	}
	[str replaceCharactersInRange:NSMakeRange(0,1) withString:[[str substringToIndex:1] uppercaseString]];
	return str;
}

+ (NSString *)loremIpsumWithSentences:(NSInteger)sentences useDefaultFirstSentence:(BOOL)useDefaultFirstSentence
{
	static NSString *firstSentence;
	if (!firstSentence)
	{
		firstSentence = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit.";
	}
	NSMutableString *str = [[NSMutableString alloc] init];
	
	if (useDefaultFirstSentence)
	{
		[str appendString:firstSentence];
		if (sentences > 1)
		{
			[str appendString:@" "];
			sentences -= 1;
		}
	}
	
	for (int i=0; i < sentences; i++)
	{
		int sentenceLength = 8 + (arc4random() % 12);
		[str appendString:[self loremIpsumWithWords:sentenceLength insertComma:(sentenceLength > 14)]];
		[str appendString:@"."];
		if (i < sentences - 1)
		{
			[str appendString:@" "];
		}
	}
	return str;
}

+ (NSString *)loremIpsumWithSentences:(NSInteger)sentences
{
	return [self loremIpsumWithSentences:sentences useDefaultFirstSentence:YES];
}

+ (NSString *)loremIpsumWithParagraphs:(NSInteger)paragraphs
{
	NSMutableString *str = [[NSMutableString alloc] init];
	for (int i=0; i<paragraphs; i++)
	{
		int paragraphLength = 3 + (arc4random() % 3);
		[str appendString:[self loremIpsumWithSentences:paragraphLength useDefaultFirstSentence:(i == 0 ? YES : NO)]];
		if (i < paragraphs-1 || YES)
		{
			[str appendString:@"\r\n"];
		}
	}
	return str;
}
//-------------------------------- NSString+LoremIpsum



+(NSString*)randomCharacter
{
    return [NSString stringWithFormat:@"%c" , (48 +rand() % 80)];
}

+ (NSString*)randomStringWithMaxLength:(NSInteger)inLength
{
    return [self randomStringWithRange:NSMakeRange(0, inLength)];
}

+ (NSString*)randomStringWithRange:(NSRange)inRange
{
    NSInteger length = (NSInteger)(rand() % inRange.length);
    NSMutableString *newstring = [[NSMutableString alloc] init];
    
    for(int i=0; i<inRange.location; i++)
        [newstring appendString:[NSString randomCharacter]];
    
    for(int i=0; i<length; i++)
        [newstring appendString:[NSString randomCharacter]];
    
    NSString *final = [NSString stringWithString:newstring];
    
    return final;
}


/*
 Base 64
 Should also have one that is base64ForString
 */
+ (NSString*)base64forData:(NSData*)inData
{
    const uint8_t* input = (const uint8_t*)[inData bytes];
    NSInteger length = [inData length];
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
			
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

-(NSString*)base64
{
    return [NSString base64forData:[self dataUsingEncoding:NSUTF8StringEncoding]];
}

/*
    Is Email Address
*/
- (BOOL)isEmailAddress
{
    BOOL rtnStatus = NO; // default to no.
	
	// Simple Regex
	//NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    // Complex Regex, according to RFC 5322
    // As describe in http://www.cocoawithlove.com/2009/06/verifying-that-string-is-email-address.html
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
	// check ourself with it
	if ( ![regExPredicate evaluateWithObject:self] )
	{	// is not email
		rtnStatus = NO;
	}
	else
	{	// is email
		rtnStatus = YES;
	}
    
	return rtnStatus;
}




-(NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    unsigned int length = (unsigned int)strlen(cStr);
    CC_MD5(cStr, length, result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding forCharacterString:(NSString*)characters
{
	
	CFStringRef tmp = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL,
															  (CFStringRef)characters,CFStringConvertNSStringEncodingToEncoding(encoding));
	
	NSString *newString = [(__bridge NSString *)tmp copy];
	CFRelease(tmp);
    return newString;
}




- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return [self urlEncodeUsingEncoding:encoding forCharacterString:@"!*'\"();:@&=+$,/?%#[]% "];
}



- (NSString *)urlEncodedString
{
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}



- (BOOL)isFilePath
{
	return [NSFileManager fileExistsAtPath:self];
}


- (BOOL)isDirectoryPath
{
	return [NSFileManager directoryExistsAtPath:self];
}


- (id)jsonValue
{
	NSError *error = nil;
	id json = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
	ELog( error );
	return json;
}


- (NSDictionary *)xmlValue
{
	return [NSXMLParser parseString:self];
}



#ifdef __IPHONE_7_0
- (NSAttributedString *)attributedHTMLStringWithFont:(UIFont *)font
{
    NSError * tmpCreationError = nil;
    NSMutableAttributedString *tmpString = [[NSMutableAttributedString alloc] initWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                                                   options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                             NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                        documentAttributes:nil
                                                                                     error:&tmpCreationError];
    
   	ELog(tmpCreationError);
    
    if(font){
        [tmpString addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, tmpString.length)];
    }
    if(tmpString == nil){
        return nil;
    }
    return [[NSAttributedString alloc] initWithAttributedString:tmpString];
}


- (void)attributedHTMLStringWithFont:(UIFont *)font withCompletion:(FZBlockWithObject)inCompletionBlock
{
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        NSError * tmpCreationError = nil;
        NSMutableAttributedString * tmpString = [[NSMutableAttributedString alloc] initWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                                                        options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                                  NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                             documentAttributes:nil
                                                                                          error:&tmpCreationError];
        if(tmpCreationError){
            if(inCompletionBlock){
                inCompletionBlock(tmpCreationError);
            }
            ELog(tmpCreationError);
            return;
        }
        
        if(font){
            [tmpString addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, tmpString.length)];
        }
        
        
        if(inCompletionBlock){
            inCompletionBlock(tmpString);
        }
        
        
    });
}


- (void)attributedHTMLStringWithFont:(UIFont *)inFont color:(UIColor*)inColor withCompletion:(FZBlockWithObject)inCompletionBlock
{
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        NSString * html = self;
        if(inFont || inColor){
            html = [NSString stringWithFormat:@"<font "];
            if(inFont ){
                html = [html stringByAppendingFormat:@" face='%@' font='%@' style=\"font-size:%0.2fpx\" " ,inFont.fontName,inFont.fontName,  inFont.pointSize];
            }
            if(inColor){
                NSString * tmpHexString = [[inColor hexString] substringToIndex:5];
                html = [html stringByAppendingFormat:@" color=\"#%@\" ",  tmpHexString];
            }
            html = [html stringByAppendingFormat:@" >%@</font>", self];
        }
        
        NSError * tmpCreationError = nil;
        NSMutableAttributedString * tmpString = [[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                                                                        options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                                  NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                             documentAttributes:nil
                                                                                          error:&tmpCreationError];
        if(tmpCreationError){
            if(inCompletionBlock){
                inCompletionBlock(tmpCreationError);
            }
            ELog(tmpCreationError);
            return;
        }
        
        if(inCompletionBlock){
            inCompletionBlock(tmpString);
        }
        
        
    });
}



#endif

- (NSString *)stringByStrippingHTMLAttributes
{
	NSRange tmpRange;
    NSString *rtnString = self;
	
    while ((tmpRange = [rtnString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
	{
        rtnString = [rtnString stringByReplacingCharactersInRange:tmpRange withString:@""];
	}
    return rtnString;
}

-(void)writeToFile:(NSString*)inFilePath
{
	NSError *error = nil;
	[self writeToFile:inFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    ELog(error);
}

+(NSString*)stringFromFile:(NSString*)inFilePath
{
	//check for the file
	if(![inFilePath isFilePath])
	{
		DLog(@"Not a valid file path");
		return nil;
	}
	
	NSError *error = nil;
	NSString *tmp = [NSString stringWithContentsOfFile:inFilePath encoding:NSUTF8StringEncoding error:&error];
    ELog(error);
  	return tmp;
}

@end
