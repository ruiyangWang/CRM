//
//  NSDate+YDConvenience.m
//  calendar
//
//  Created by YD_iOS on 16/8/12.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "NSDate+YDConvenience.h"

static NSCalendar *_calendar = nil;
static NSDateComponents *_components = nil;
static NSDateComponents *_offsetComponents = nil;

@implementation NSDate (YDConvenience)

- (NSCalendar *)calendar
{
    if (_calendar == nil) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        /*
         设定每周的第一天从星期几开始，比如:
         .  如需设定从星期日开始，则value传入1
         .  如需设定从星期一开始，则value传入2
         */
        [_calendar setFirstWeekday:2];
    }
    
    return _calendar;
}

- (NSDateComponents *)offsetComponents
{
    _offsetComponents = [[NSDateComponents alloc] init];
    return _offsetComponents;
}

- (void)setComponents:(NSInteger)unitFlags
{
    _components = [[self calendar] components:unitFlags fromDate: self];
}

- (NSInteger)year
{
    [self setComponents:NSCalendarUnitYear];
    return [_components year];
}

- (NSInteger)month
{
    [self setComponents:NSCalendarUnitMonth];
    return [_components month];
}

- (NSInteger)day
{
    [self setComponents:NSCalendarUnitDay];
    return [_components day];
}

-(NSInteger)hours
{
    [self setComponents:NSCalendarUnitHour];
    return [_components hour];
}

- (NSInteger)week
{
    [self setComponents:NSCalendarUnitWeekday ];
    return [_components weekday];
}

- (NSInteger)countOfDaysInMonth
{
    NSRange rng = [[self calendar] rangeOfUnit: NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate: self];
    NSUInteger number = rng.length;
    return number;
}


- (NSInteger)countOfWeeksInMonth
{
    NSRange rng = [[self calendar] rangeOfUnit: NSCalendarUnitWeekOfYear inUnit: NSCalendarUnitMonth forDate: self];
    NSUInteger number = rng.length;
    return number;
}

- (NSInteger)firstWeekDayInMonth
{
    //Set date to first of month
    [self setComponents: NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay];
    [_components setDay:1];
    NSDate *newDate = [_calendar dateFromComponents:_components];
    
    return [_calendar ordinalityOfUnit: NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:newDate];
}

- (NSInteger)weekInMonth
{
    [self setComponents:NSCalendarUnitWeekOfMonth];
    NSInteger weekdayOrdinal = [_components weekOfMonth];
    return weekdayOrdinal;
}

- (NSInteger)weekInYear
{
    [self setComponents:NSCalendarUnitWeekOfYear];
    NSInteger weekdayOrdinal = [_components week];
    return weekdayOrdinal;
}

- (NSDate *)offsetMonth:(NSInteger)numMonths
{
    [[self offsetComponents] setMonth: numMonths];
    
    return [_calendar dateByAddingComponents:_offsetComponents toDate:self options:0];
}

-(NSDate *)offsetDay:(NSInteger)numDays
{
    [[self offsetComponents] setDay:numDays];
    
    return [_calendar dateByAddingComponents:_offsetComponents toDate:self options:0];
}

- (BOOL)isEqualToDate: (NSDate *)aDate
{
    if ([self year] == [aDate year] && [self month] == [aDate month] && [self day] == [aDate day])
    {
        return YES;
    }
    else{
        return NO;
    }
}

- (NSInteger)compareWithDate: (NSDate *)aDate
{
    NSInteger cYear = [self year];
    NSInteger aYear = [aDate year];
    if (cYear > aYear)
    {
        return YDDateComparePlurality;
    }
    else if (cYear < aYear)
    {
        return YDDateCompareSmaller;
    }
    else{
        NSInteger cMonth = [self month];
        NSInteger aMonth = [aDate month];
        
        if (cMonth > aMonth)
        {
            return YDDateComparePlurality;
        }
        else if (cMonth < aMonth)
        {
            return YDDateCompareSmaller;
        }
        else{
            NSInteger cDay = [self day];
            NSInteger aDay = [aDate day];
            if (cDay > aDay)
            {
                return YDDateComparePlurality;
            }
            else if (cDay < aDay)
            {
                return YDDateCompareSmaller;
            }
            else{
                return YDDateCompareEqual;
            }
        }
    }
}

- (NSDate *)firstDayOfMonth
{
    NSTimeInterval endDate;
    NSDate *firstDay = nil;
    [[self calendar] rangeOfUnit:NSCalendarUnitMonth startDate:&firstDay interval:&endDate forDate: self];
    
    return firstDay;
}


@end
