//
//  NSDate+Fuzz.h
//  
//
//  Created by Fuzz Productions on 11/6/13.
//
//
// ARC_NO

/*
 
 This assumes gregorian calendar
 12 hour time
 Shares date formatter
 
 
 Common Format Specifiers
 day short      E
 day long       EE
 month short    MMMM
 month long     MMM
 
 Date Formatter is not thread safe
 needs to use @sync
 
 */

#import <UIKit/UIKit.h>

@interface NSDate (Fuzz)

// Constructors
+ (instancetype)dateFromString:(NSString *)inString withFormat:(NSString *)inDateFormat;
+ (instancetype)dateWithMonth:(NSInteger)inMonth day:(NSInteger)inDay year:(NSInteger)inYear;
+ (instancetype)dateWithSecond:(NSInteger)inSecond minute:(NSInteger)inMinute hour:(NSInteger)inHour day:(NSInteger)inDay month:(NSInteger)inMonth year:(NSInteger)inYear;

// Date to string conversion functions
- (NSString *)stringWithFormat:(NSString *)inDateFormat;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)inStyle;
- (NSString *)stringWithTimeStyle:(NSDateFormatterStyle)inStyle;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)inDateStyle andTimeStyle:(NSDateFormatterStyle)inTimeStyle;
- (NSString *)graduatedTimeSinceString;

// Date component strings
- (NSString*)dayString;
- (NSString*)dayShortString;
- (NSString*)monthString;
- (NSString*)monthShortString;
- (NSString*)timeString;

// Date component integers
- (NSInteger)second;
- (NSInteger)minute;
- (NSInteger)hour;
- (NSInteger)day;
- (NSInteger)weekDayInteger;
- (NSInteger)daysInMonth;
- (NSInteger)weekOfMonth;
- (NSInteger)weekOfYear;
- (NSInteger)year;
- (NSInteger)month;

// Date component "setters." These methods return a copy of the receiver with a singular component update.
- (NSDate *)dateWithDay:(NSInteger)inDay;
- (NSDate *)dateWithMonth:(NSInteger)inMonth;
- (NSDate *)dateWithWeekOfMonth:(NSInteger)inWeekOfMonth;
- (NSDate *)dateWithWeekOfYear:(NSInteger)inWeekOfYear;
- (NSDate *)dateWithYear:(NSInteger)inYear;
- (NSDate *)dateWithHour:(NSInteger)inHour;
- (NSDate *)dateWithMinute:(NSInteger)inMinute;
- (NSDate *)dateWithSecond:(NSInteger)inSecond;

// Date positioning
- (instancetype)dateByAddingSeconds:(NSInteger)inSeconds;
- (instancetype)dateByAddingMinutes:(NSInteger)inMinutes;
- (instancetype)dateByAddingHours:(NSInteger)inHours;
- (instancetype)dateByAddingDays:(NSInteger)inDays;
- (instancetype)dateByAddingWeeks:(NSInteger)inWeeks;
- (instancetype)dateByAddingMonths:(NSInteger)inMonths;
- (instancetype)dateByAddingYears:(NSInteger)inYears;

// Determine the difference in time between from another date with a given unit
- (NSInteger)secondsSinceDate:(NSDate*)inDate;
- (NSInteger)minuteSinceDate:(NSDate*)inDate;
- (NSInteger)hoursSinceDate:(NSDate*)inDate;
- (NSInteger)daysSinceDate:(NSDate*)inDate;
- (NSInteger)weeksSinceDate:(NSDate*)inDate;
- (NSInteger)monthsSinceDate:(NSDate*)inDate;
- (NSInteger)yearsSinceDate:(NSDate*)inDate;

// Basic determinations of the relationship between a given date and today.
- (BOOL)isYesterday;
- (BOOL)isToday;
- (BOOL)isTomorrow;

@end
