//
//  YDCalendarPickerDaysOwner.m
//  calendar
//
//  Created by YD_iOS on 16/8/12.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCalendarPickerDaysOwner.h"
#import "NSDate+YDConvenience.h"

static YDCalendarPickerDaysOwner *daysOwner = nil;

@implementation YDCalendarPickerDaysOwner

- (id)init
{
    self = [super init];
    if (self)
    {
        _selectedDate = [[NSDate date] copy];
        [self workBeginDateBy:nil];
        [self workEndDateBy:nil];
    }
    return self;
}

+ (YDCalendarPickerDaysOwner *)sharedDaysOwner
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        daysOwner = [[YDCalendarPickerDaysOwner alloc] init];
    });
    return daysOwner;
}

#pragma mark - set methods

#pragma mark - public

- (void)workBeginDateBy:(NSDate *)aDate
{
    if (aDate == nil) {
        
        NSDate *nowDate = [NSDate date];
        
        NSDate *theDate;
        
        NSTimeInterval oneDay = 24 * 60 * 60 * 1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow:oneDay * (-91)];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
        
        aDate = theDate;
    }
    
    NSDate *tmpDate = [aDate firstDayOfMonth];
    NSInteger dayWeek = [tmpDate firstWeekDayInMonth];
    if (dayWeek > 1) {
        self.beginDate = [tmpDate offsetDay:-(dayWeek - 1)];
    }
    else{
        self.beginDate = tmpDate;
    }
}

- (void)workEndDateBy:(NSDate *)aDate
{
    if (aDate == nil) {
        aDate = [NSDate date];
    }
    
    self.endDate = [[[aDate offsetMonth:1] firstDayOfMonth] offsetDay:-1];
}


@end
