//
//  NSXMLParser+Fuzz.m
//  FZModuleLibrary
//
//  Created by Sean Orelli on 8/22/14.
//  Adapted from https://github.com/simhanature/SHXMLParser under the MIT license

#import "NSXMLParser+Fuzz.h"
@interface FZDefaultXMLParser : NSObject <NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableString		*parsedString;
@property (nonatomic, strong) NSMutableArray		*currentDepth;
@property (nonatomic, strong) NSMutableDictionary	*xmlDictionary;

@property (nonatomic, assign) BOOL	foundCharacters;
@property (nonatomic, assign) BOOL	elementStarted;

@end

@implementation FZDefaultXMLParser

+ (NSDictionary*)parse:(NSData*)inData
{
	FZDefaultXMLParser *fuzzParser = [FZDefaultXMLParser new];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:inData];
	[parser setDelegate:fuzzParser];
	if ([parser parse] == YES)
		return fuzzParser.xmlDictionary;
	return nil;
}

-(id)init
{
	self = [super init];
	self.currentDepth	= [NSMutableArray array];
	self.xmlDictionary	= [NSMutableDictionary dictionary];

	return self;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	[self.currentDepth addObject:elementName];
	
	if ([self.currentDepth count] > 1)
	{
		NSString *arrayPath = [NSString stringWithFormat:@"%@[]", [self.currentDepth componentsJoinedByString:@"."]];
		
		if ([self.xmlDictionary objectForKey:arrayPath] == nil)
			[self.xmlDictionary setObject:[NSMutableArray array] forKey:arrayPath];
	}
	
	NSString *objectPath = [self.currentDepth componentsJoinedByString:@"."];
	[self.xmlDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:attributeDict] forKey:objectPath];
	
	self.parsedString = [NSMutableString string];
	//
	self.elementStarted		= TRUE;
	self.foundCharacters	= FALSE;
}



- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if (self.foundCharacters && self.elementStarted)
	{
        NSString *objectPath = [self.currentDepth componentsJoinedByString:@"."];
		
		if([[self.xmlDictionary objectForKey:objectPath] isKindOfClass:[NSDictionary class]] && [(NSDictionary*)[self.xmlDictionary objectForKey:objectPath] count]>0)
        {
            NSMutableDictionary *tempDict = [[self.xmlDictionary objectForKey:objectPath] mutableCopy];
            [tempDict setObject:[self.parsedString copy] forKey:@"leafContent"];
            [self.xmlDictionary setObject:tempDict forKey:objectPath];
        }
        else if ([[self.xmlDictionary objectForKey:objectPath] isKindOfClass:[NSDictionary class]] && [(NSDictionary*)[self.xmlDictionary objectForKey:objectPath] count]==0)
        {
            [self.xmlDictionary removeObjectForKey:objectPath];
            [self.xmlDictionary setObject:[self.parsedString copy] forKey:objectPath];
        }
	}
	
	NSString			*arrayPath		= [NSString stringWithFormat:@"%@[]", [self.currentDepth componentsJoinedByString:@"."]];
	NSMutableArray		*currentArray	= [self.xmlDictionary objectForKey:arrayPath];
	NSMutableDictionary *currentDict	= [self.xmlDictionary objectForKey:[self.currentDepth componentsJoinedByString:@"."]];
	
	if (currentDict != nil)
		[currentArray addObject:[currentDict copy]];
	
    //adding the ended nodes to current node starts here
	if (self.currentDepth != nil)
	{
		NSMutableArray *endedNodes = [NSMutableArray array];
		
		for (NSString *key in self.xmlDictionary)
		{
			NSString *trimmedPath = [key stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
			
			if ([self.currentDepth count] < [[trimmedPath componentsSeparatedByString:@"."] count])
			{
				NSMutableArray *keyArray = [[trimmedPath componentsSeparatedByString:@"."] mutableCopy];
				
				if (![endedNodes containsObject:[keyArray lastObject]])
					[endedNodes addObject:[keyArray lastObject]];
			}
		}
		
		for (NSString *endedNode in endedNodes)
		{
			NSMutableArray *endedDepth = [NSMutableArray arrayWithArray:self.currentDepth];
			[endedDepth addObject:endedNode];
			
			NSMutableDictionary *endedObject			= [self.xmlDictionary objectForKey:[endedDepth componentsJoinedByString:@"."]];
			NSMutableArray		*endedObjectArray	= [self.xmlDictionary objectForKey:[NSString stringWithFormat:@"%@[]", [endedDepth componentsJoinedByString:@"."]]];
			
			NSString			*objectPath		= [self.currentDepth componentsJoinedByString:@"."];
			NSMutableDictionary *currentDict	= [self.xmlDictionary objectForKey:objectPath];
			
			NSString			*objectArrayPath	= [NSString stringWithFormat:@"%@[]", [self.currentDepth componentsJoinedByString:@"."]];
			NSMutableArray		*currentArray		= [self.xmlDictionary objectForKey:objectArrayPath];
			NSMutableDictionary *currentArrayDict	= [[currentArray lastObject] mutableCopy];
			
			// link temporary objects on inner node to their parent node
			if ((endedObjectArray != nil) && ([endedObjectArray count] > 1))
			{
				[currentDict setObject:[endedObjectArray copy] forKey:endedNode];
				[currentArrayDict setObject:[endedObjectArray copy] forKey:endedNode];
			}
			else if (endedObject != nil)
			{
				[currentDict setObject:[endedObject copy] forKey:endedNode];
				[currentArrayDict setObject:[endedObject copy] forKey:endedNode];
			}
			// Add inner nodes to items in a array
			[currentArray removeLastObject];
			[currentArray addObject:currentArrayDict];
			
			// removing temporary objects on inner node while ending their parent node
			[self.xmlDictionary removeObjectForKey:[NSString stringWithFormat:@"%@[]", [endedDepth componentsJoinedByString:@"."]]];
			[self.xmlDictionary removeObjectForKey:[NSString stringWithString:[endedDepth componentsJoinedByString:@"."]]];
		}
	}
    //adding the ended nodes to current node ends here
	
	[self.currentDepth removeLastObject];
	
    //Writing current element values below
    
    //We are checking for repeated elements with string values so that they can be converted to array
	NSString			*objectPath			= [self.currentDepth componentsJoinedByString:@"."];
	NSMutableDictionary *currentDictObject	= [self.xmlDictionary objectForKey:objectPath];
    if([currentDictObject objectForKey:elementName] == nil)
	{
        [currentDictObject setObject:[self.parsedString copy] forKey:elementName];
    }
    else
		if([[currentDictObject objectForKey:elementName] isKindOfClass:[NSArray class]] || [[currentDictObject objectForKey:elementName] isKindOfClass:[NSMutableArray class]])
		{
			NSMutableArray *tempArray = [[currentDictObject objectForKey:elementName] mutableCopy];
			[tempArray addObject:[self.parsedString copy]];
			[currentDictObject setObject:tempArray forKey:elementName];
		}
		else
			if ([[currentDictObject objectForKey:elementName] isKindOfClass:[NSString class]])
			{
				NSMutableArray *tempArray = [NSMutableArray array];
				[tempArray addObject:[currentDictObject objectForKey:elementName]];
				[tempArray addObject:[self.parsedString copy]];
				[currentDictObject setObject:tempArray forKey:elementName];
			}
	self.parsedString = [NSMutableString string];
	self.elementStarted = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	self.foundCharacters = YES;
	[self.parsedString appendString:string];
}


@end


@implementation NSXMLParser (Fuzz)
+ (NSDictionary*)parseString:(NSString*)inString
{
	return [self parseData:[inString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (NSDictionary*)parseData:(NSData*)inData
{
	return [FZDefaultXMLParser parse:inData];
}
@end
