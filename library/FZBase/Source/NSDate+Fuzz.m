//
//  NSDate+Fuzz.m
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//

#import "NSDate+Fuzz.h"
#import "NSObject+Fuzz.h"

@interface FZDateFormatter : NSDateFormatter
@end


#pragma mark - Private date formatter
@implementation FZDateFormatter
-(id)init
{
    self = [super init];
    if(self)
    {
        [self observeNotification:NSCurrentLocaleDidChangeNotification withSelector:@selector(didChangeLocale)];
    }
    return self;
}


-(void)didChangeLocale
{
    //Here we should update the locale of the current user
    //to best match there current time zone
}

-(void)dealloc
{
    [self stopObservingNotifications];
}

@end

@implementation NSDate (Fuzz)
static FZDateFormatter *_dateFormatter = nil;

#pragma mark - Date formatter access
+(FZDateFormatter*)sharedDateFormatter
{
    //NSDate formatter is not thread safe
    //This prevents multiple threads from accesssing
    //Possibly this directive should be used
    //for all functions below
    @synchronized(self)
    {
        if(_dateFormatter == nil)
            _dateFormatter = [[FZDateFormatter alloc] init];
        
        //Here we should put the object in FZCache
        //Allow it to be removed when mem is low
        
        return _dateFormatter;
    }
 }

#pragma mark - Class constructors
+ (instancetype)dateWithMonth:(NSInteger)inMonth day:(NSInteger)inDay year:(NSInteger)inYear
{
	return [self dateWithSecond:0 minute:0 hour:0 day:inDay month:inMonth year:inYear];
}

+ (instancetype)dateWithSecond:(NSInteger)inSecond minute:(NSInteger)inMinute hour:(NSInteger)inHour day:(NSInteger)inDay month:(NSInteger)inMonth year:(NSInteger)inYear
{
	NSDateComponents *tmpComponents = [self dateComponentsWithSecond:inSecond minute:inMinute hour:inHour day:inDay month:inMonth year:inYear];
	NSDate *rtnDate = [tmpComponents.calendar dateFromComponents:tmpComponents];
	
	return rtnDate;
}

+ (NSDateComponents *)dateComponentsWithSecond:(NSInteger)inSecond minute:(NSInteger)inMinute hour:(NSInteger)inHour day:(NSInteger)inDay month:(NSInteger)inMonth year:(NSInteger)inYear
{
	NSDateComponents *rtnComponents = [NSDateComponents new];
	rtnComponents.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	rtnComponents.second = inSecond;
	rtnComponents.minute = inMinute;
	rtnComponents.hour = inHour;
	rtnComponents.day = inDay;
	rtnComponents.month = inMonth;
	rtnComponents.year = inYear;
	
	return rtnComponents;
}

+ (instancetype)dateFromString:(NSString *)inString withFormat:(NSString *)inDateFormat
{
	[[NSDate sharedDateFormatter] setDateFormat:inDateFormat];
	return [[NSDate sharedDateFormatter] dateFromString:inString];
}

#pragma mark - Date to string conversion methods
- (NSString *)stringWithFormat:(NSString *)inDateFormat
{
	[[NSDate sharedDateFormatter] setDateFormat:inDateFormat];
    return [[NSDate sharedDateFormatter] stringFromDate:self];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)inStyle
{
    return [self stringWithDateStyle:inStyle andTimeStyle:NSDateFormatterNoStyle];
}

- (NSString *)stringWithTimeStyle:(NSDateFormatterStyle)inStyle
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle andTimeStyle:inStyle];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)inDateStyle andTimeStyle:(NSDateFormatterStyle)inTimeStyle
{
	[[NSDate sharedDateFormatter] setDateStyle:inDateStyle];
	[[NSDate sharedDateFormatter] setTimeStyle:inTimeStyle];
	return [[NSDate sharedDateFormatter] stringFromDate:self];
}

- (NSString *)graduatedTimeSinceString
{
	NSDate *tmpDate = [NSDate date];
	NSInteger tmpMinutesAgo = -[self minuteSinceDate:tmpDate];
	NSInteger tmpMinutesInADay = (24 * 60);
	NSString *rtnString = nil;
	if (tmpMinutesAgo < 2)
	{
		rtnString = @"Just now";
	}
	else if (tmpMinutesAgo < 60)
	{
		rtnString = [NSString stringWithFormat:@"%i minutes ago", (int)-[self minuteSinceDate:tmpDate]];
	}
	else if (tmpMinutesAgo < 120)
	{
		rtnString = [NSString stringWithFormat:@"1 hour ago"];
	}
	else if (tmpMinutesAgo < tmpMinutesInADay)
	{
		rtnString = [NSString stringWithFormat:@"%i hours ago", (int)-[self hoursSinceDate:tmpDate]];
	}
	else if (tmpMinutesAgo < tmpMinutesInADay * 2)
	{
		rtnString = [NSString stringWithFormat:@"1 day ago"];
	}
	else if (tmpMinutesAgo < tmpMinutesInADay * 7)
	{
		rtnString = [NSString stringWithFormat:@"1 week ago"];
	}
	else if (tmpMinutesAgo < tmpMinutesInADay * 31)
	{
		rtnString = [NSString stringWithFormat:@"%i weeks ago", (int)-[self weeksSinceDate:tmpDate]];
	}
	else if (tmpMinutesAgo < tmpMinutesInADay * 61)
	{
		rtnString = [NSString stringWithFormat:@"1 month ago"];
	}
	else
	{
		rtnString = [NSString stringWithFormat:@"%i months ago", (int)-[self monthsSinceDate:tmpDate]];
	}
	return rtnString;
}

#pragma mark - Date component strings
- (NSString*)dayString
{
	[[NSDate sharedDateFormatter] setDateFormat:@"EEEE"];
    return [[NSDate sharedDateFormatter] stringFromDate:self];
}

- (NSString*)dayShortString
{
	[[NSDate sharedDateFormatter] setDateFormat:@"EEE"];
    return [[NSDate sharedDateFormatter] stringFromDate:self];
}

- (NSString*)monthString
{
	[[NSDate sharedDateFormatter] setDateFormat:@"MMMM"];
    return [[NSDate sharedDateFormatter] stringFromDate:self];
}

- (NSString*)monthShortString
{
	[[NSDate sharedDateFormatter] setDateFormat:@"MMM"];
    return [[NSDate sharedDateFormatter] stringFromDate:self];
}


- (NSString*)timeString
{
    
	[[NSDate sharedDateFormatter] setDateFormat:@"HH:mm"];
    return [[NSDate sharedDateFormatter] stringFromDate:self];
}

#pragma mark - Date component integers
- (NSDateComponents*)componentWithType:(NSCalendarUnit)inUnit
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comps = [gregorian components:inUnit fromDate:self];
    return comps; // Sunday is 1, Monday is 2 ... Saturday is 7
}

- (NSInteger)second
{
	return [[self componentWithType:NSCalendarUnitSecond] second];
}

- (NSInteger)minute
{
	return [[self componentWithType:NSCalendarUnitMinute] minute];
}

- (NSInteger)hour
{
	return [[self componentWithType:NSCalendarUnitHour] hour];
}

- (NSInteger)day
{
	return [[self componentWithType:NSCalendarUnitDay] day];
}

- (NSInteger)weekDayInteger
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:self];
	NSInteger weekday = [comps weekday]; // Sunday is 1, Monday is 2 ... Saturday is 7
	return weekday;
}
					 
- (NSInteger)daysInMonth
{
	NSInteger rtnDayCount;
	NSRange tmpDayRange = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
	rtnDayCount = tmpDayRange.length;
	return rtnDayCount;
}

- (NSInteger)weekOfMonth
{
	return [[self componentWithType:NSCalendarUnitWeekOfMonth] weekOfMonth];
}

- (NSInteger)weekOfYear
{
	return [[self componentWithType:NSCalendarUnitWeekOfYear] weekOfYear];
}

- (NSInteger)month
{
	return [[self componentWithType:NSCalendarUnitMonth] month];
}

- (NSInteger)year
{
	return [[self componentWithType:NSCalendarUnitYear] year];
}

#pragma mark - Date component setters
- (NSDate *)dateWithSecond:(NSInteger)inSecond
{
	return [[self class] dateWithSecond:inSecond minute:self.minute hour:self.hour day:self.day month:self.month year:self.year];
}

- (NSDate *)dateWithMinute:(NSInteger)inMinute
{
	return [[self class] dateWithSecond:self.second minute:inMinute hour:self.hour day:self.day month:self.month year:self.year];
}

- (NSDate *)dateWithHour:(NSInteger)inHour
{
	return [[self class] dateWithSecond:self.second minute:self.minute hour:inHour day:self.day month:self.month year:self.year];
}

- (NSDate *)dateWithDay:(NSInteger)inDay
{
	return [[self class] dateWithSecond:self.second minute:self.minute hour:self.hour day:inDay month:self.month year:self.year];
}

- (NSDate *)dateWithWeekOfMonth:(NSInteger)inWeekOfMonth
{
	NSDateComponents *tmpDateComponents = [NSDateComponents new];
	tmpDateComponents.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	tmpDateComponents.second = self.second;
	tmpDateComponents.minute = self.minute;
	tmpDateComponents.weekOfMonth = inWeekOfMonth;
	tmpDateComponents.month = self.month;
	tmpDateComponents.year = self.year;
	
	return [tmpDateComponents.calendar dateFromComponents:tmpDateComponents];
}

- (NSDate *)dateWithWeekOfYear:(NSInteger)inWeekOfYear
{
	NSDateComponents *tmpDateComponents = [NSDateComponents new];
	tmpDateComponents.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	tmpDateComponents.second = self.second;
	tmpDateComponents.minute = self.minute;
	tmpDateComponents.weekOfYear = inWeekOfYear;
	tmpDateComponents.year = self.year;
	
	return [tmpDateComponents.calendar dateFromComponents:tmpDateComponents];
}

- (NSDate *)dateWithMonth:(NSInteger)inMonth
{
	return [[self class] dateWithSecond:self.second minute:self.minute hour:self.hour day:self.day month:inMonth year:self.year];
}

- (NSDate *)dateWithYear:(NSInteger)inYear
{
	return [[self class] dateWithSecond:self.second minute:self.minute hour:self.hour day:self.day month:self.month year:inYear];
}

#pragma mark - Date positioning
- (instancetype)dateByAddingSeconds:(NSInteger)inSeconds
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setSecond:inSeconds];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    
    return newDate;
}

- (instancetype)dateByAddingMinutes:(NSInteger)inMinutes
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMinute:inMinutes];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    
    return newDate;
}
 
- (instancetype)dateByAddingHours:(NSInteger)inHours
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setHour:inHours];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    
    return newDate;
}

- (instancetype)dateByAddingDays:(NSInteger)inDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:inDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    
    return newDate;
}

- (instancetype)dateByAddingWeeks:(NSInteger)inWeeks
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setWeekOfYear:inWeeks];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    
    return newDate;
}

- (instancetype)dateByAddingMonths:(NSInteger)inMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:inMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    
    return newDate;
}

- (instancetype)dateByAddingYears:(NSInteger)inDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:inDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    
    return newDate;
}

#pragma mark - Date difference calculations
-(NSDateComponents*)differenceInUnit:(NSCalendarUnit)inUnit sinceDate:(NSDate*)inDate
{
    NSDate *tmpSourceDate = nil;
    NSDate *tmpDestinationDate = nil;
    
    NSCalendar *tmpCalendar = [NSCalendar currentCalendar];
    [tmpCalendar rangeOfUnit:inUnit startDate:&tmpSourceDate interval:NULL forDate:inDate];
    [tmpCalendar rangeOfUnit:inUnit startDate:&tmpDestinationDate interval:NULL forDate:self];
    
    NSDateComponents *rtnDifference = [tmpCalendar components:inUnit fromDate:tmpSourceDate toDate:tmpDestinationDate options:0];
    return rtnDifference;
}

- (NSInteger)secondsSinceDate:(NSDate*)inDate
{
    return [[self differenceInUnit:NSCalendarUnitSecond sinceDate:inDate] second];
}


- (NSInteger)minuteSinceDate:(NSDate*)inDate
{
    return [[self differenceInUnit:NSCalendarUnitMinute sinceDate:inDate] minute];
}



- (NSInteger)hoursSinceDate:(NSDate*)inDate
{
    return [[self differenceInUnit:NSCalendarUnitHour sinceDate:inDate] hour];
}


- (NSInteger)daysSinceDate:(NSDate*)inDate
{
    return [[self differenceInUnit:NSCalendarUnitDay sinceDate:inDate] day];
}



- (NSInteger)weeksSinceDate:(NSDate*)inDate
{
    return [[self differenceInUnit:NSCalendarUnitDay sinceDate:inDate] weekOfYear];
}


- (NSInteger)monthsSinceDate:(NSDate*)inDate
{
	return [[self differenceInUnit:NSCalendarUnitMonth sinceDate:inDate] month];
}


- (NSInteger)yearsSinceDate:(NSDate*)inDate
{
    return [[self differenceInUnit:NSCalendarUnitYear sinceDate:inDate] year];
}

#pragma mark - Basic date differences
- (BOOL)isYesterday
{
	NSDate *tmpYesterday = [[NSDate date] dateByAddingDays:-1];
	return  ([self dateComponentHash] == [tmpYesterday dateComponentHash]);
}

- (BOOL)isToday
{
	return  ([self dateComponentHash] == [[NSDate date] dateComponentHash]);
}

- (BOOL)isTomorrow
{
	NSDate *tmpTomorrow = [[NSDate date] dateByAddingDays:1];
	return  ([self dateComponentHash] == [tmpTomorrow dateComponentHash]);
}

#pragma mark - Private helper methods
- (NSInteger)dateComponentHash
{
	NSInteger tmpCurrentDay = [self day];
	NSInteger tmpCurrentYear = [self month];
	NSInteger tmpCurrentMonth = [self year];
	
	return  tmpCurrentDay + (tmpCurrentMonth * 100) + ( tmpCurrentYear *10000);
}

@end
