//
//  YDCalendarPickerDaysOwner.h
//  calendar
//
//  Created by YD_iOS on 16/8/12.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDDayButton.h"

@interface YDCalendarPickerDaysOwner : NSObject

@property (nonatomic, copy) NSDate *beginDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSDate *selectedDate;

@property (nonatomic, strong) YDDayButton *selectedBlock;

+ (YDCalendarPickerDaysOwner *)sharedDaysOwner;

- (void)workBeginDateBy:(NSDate *)aDate;

- (void)workEndDateBy:(NSDate *)aDate;

@end
