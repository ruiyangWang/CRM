//
//  NSDate+YDConvenience.h
//  calendar
//
//  Created by YD_iOS on 16/8/12.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//  日历处理需要  

#import <Foundation/Foundation.h>

typedef enum
{
    YDDateCompareSmaller = -1,
    YDDateCompareEqual = 0,
    YDDateComparePlurality
}YDDateCompare;

@interface NSDate (YDConvenience)

- (NSInteger)year;

- (NSInteger)month;

- (NSInteger)day;

- (NSInteger)hours;

- (NSInteger)week;

- (NSInteger)countOfDaysInMonth;

- (NSInteger)countOfWeeksInMonth;

- (NSInteger)firstWeekDayInMonth;

- (NSInteger)weekInMonth;

- (NSInteger)weekInYear;

- (NSDate *)offsetMonth:(NSInteger)numMonths;

- (NSDate *)offsetDay:(NSInteger)numDays;

- (BOOL)isEqualToDate: (NSDate *)aDate;

- (NSInteger)compareWithDate: (NSDate *)aDate;

- (NSDate *)firstDayOfMonth;

@end
