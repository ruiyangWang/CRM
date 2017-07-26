//
//  NSDate+YDString.m
//  CRM
//
//  Created by YD_iOS on 16/7/13.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "NSDate+YDString.h"

#define kDaySecond (24*60*60)

@implementation NSDate (YDString)

+ (NSDateComponents *)_dateComponents:(NSInteger)count{
    NSDate *now = [NSDate date];
    
    NSInteger nowDateSecond = [now timeIntervalSince1970];
    NSInteger newDateSecond = nowDateSecond + kDaySecond*count;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:newDateSecond];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    return dateComponent;
}

+ (NSString *)dayWithDateOffset:(NSInteger)count{
    
    NSDateComponents *dateComponent = [NSDate _dateComponents:count];
    NSInteger day = [dateComponent day];
    
    return [NSString stringWithFormat:@"%ld",day];
}

+ (NSString *)monthWithDateOffset:(NSInteger)count{
    
    NSDateComponents *dateComponent = [NSDate _dateComponents:count];
    NSInteger day = [dateComponent month];
    
    return [NSString stringWithFormat:@"%ld",day];
}

+ (NSDate *)dateWithString:(NSString *)str format:(NSString*)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:str];
    return date;
}
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString*)format{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+(NSString *)compareDate:(NSDate *)date{
    
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: kDaySecond];
    yesterday = [today dateByAddingTimeInterval: -kDaySecond];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    //NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    NSString * dateString_eon = [NSDate stringWithDate:date format:@"M月d日"];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    } else
    {
        return dateString_eon;
    }
}

+ (NSArray *)nowAndAfter{
    
    NSMutableArray *mA = [NSMutableArray array ];
    for (int i = 0; i < 5; i++) {
        NSDate *d = [[NSDate new] dateByAddingTimeInterval:kDaySecond*i];
        NSString *s = [NSDate stringWithDate:d format:@"yyyy-MM-dd"];
        [mA addObject:s];
    }
    
    return mA;
}

+ (NSArray *)returnNewArray:(NSArray *)arr{

    NSMutableArray *p = [[NSMutableArray alloc] initWithArray:arr];
    
    [p sortUsingComparator:^NSComparisonResult(NSString *timeString1, NSString *timeString2) {
        
        NSDate *d1 = [NSDate dateWithString:timeString1 format:@"yyyy-MM-dd"];
        NSDate *d2 = [NSDate dateWithString:timeString2 format:@"yyyy-MM-dd"];
        
        NSTimeInterval timeBetween = [d1 timeIntervalSinceDate:d2];
        
        if (timeBetween < 0) {
            return NSOrderedDescending;
        }
        else if (timeBetween > 0){
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    
    return [NSArray arrayWithArray:p];
}


@end