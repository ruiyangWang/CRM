//
//  YDCalendarPickerCell.h
//  calendar
//
//  Created by YD_iOS on 16/8/12.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDCalendarPickerCell : UITableViewCell

@property (nonatomic, strong) NSDate *beginDate;

@property (nonatomic, strong) NSDate *selectDate;

@property (nonatomic, copy) NSString *selectDateString;

@end
