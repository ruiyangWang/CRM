//
//  YDCalendarPickerCell.m
//  calendar
//
//  Created by YD_iOS on 16/8/12.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCalendarPickerCell.h"
#import "YDCalendarPickerDaysOwner.h"
#import "YDDayButton.h"
#import "NSDate+YDConvenience.h"
#import "YDLocalDefine.h"

@interface YDCalendarPickerCell()

@property (nonatomic, retain) NSMutableArray *blocks;

@end

@implementation YDCalendarPickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _blocks = [[NSMutableArray alloc] init];
        for (int i = 0; i < 7; i++) {
            YDDayButton *block = [[YDDayButton alloc] initWithFrame:CGRectMake(kCalendarDayBlockWidth * i, 0, kCalendarDayBlockWidth, kCalendarDayBlockHeight)];
            block.tag = self.tag;
            [self.contentView addSubview:block];
            [_blocks addObject:block];
            
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    return self;
}

#pragma mark - set methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setEditing:(BOOL)editing
{
    [super setEditing:editing];
    
    if (editing) {
        [self setBlocksMoving];
    }
    else{
        [self setBlocksNormal];
    }
}
-(void)setBeginDate:(NSDate *)beginDate{
    _beginDate = beginDate;
    
    NSDate *selectedDate = [[YDCalendarPickerDaysOwner sharedDaysOwner] selectedDate];
    for (int i = 0; i < 7; i++) {
        YDDayButton *block = [_blocks objectAtIndex:i];
        NSDate *date = [_beginDate offsetDay:i];
        block.blockDate = date;
        
        if ([date compareWithDate:selectedDate] == YDDateCompareEqual) {
            //block.blockState = YDDayBlockStateSelected;
        }
        else{
            block.blockState = YDDayBlockStateNoraml;
        }
        //记录选中的日期
        if ([self isEqualWithDate:self.selectDateString date:date]) {
            block.isSelect = YES;
        } else {
            block.isSelect = NO;
        }
    }
}

#pragma mark - private

- (void)setBlocksNormal
{
    NSDate *selectedDate = [[YDCalendarPickerDaysOwner sharedDaysOwner] selectedDate];
    for (int i = 0; i < 7; i++) {
        YDDayButton *block = [_blocks objectAtIndex:i];
        NSDate *date = block.blockDate;
        if ([date compareWithDate:selectedDate] == YDDateCompareEqual) {
            //block.blockState = YDDayBlockStateSelected;
        }
        else{
            block.blockState = YDDayBlockStateNoraml;
        }
        //记录选中的日期
        if ([self isEqualWithDate:self.selectDateString date:date]) {
            block.isSelect = YES;
        } else {
            block.isSelect = NO;
        }
    }
}

- (void)setBlocksMoving
{
    for (int i = 0; i < 7; i++) {
        YDDayButton *block = [_blocks objectAtIndex:i];
        block.blockState = YDDayBlockStateMoving;
    }
}

- (BOOL)isEqualWithDate:(NSString *)date1 date:(NSDate *)date2
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString2 = [formatter stringFromDate:date2];
    if (date1.length > 10) {
        date1 = [date1 substringToIndex:10];
    }
    return [date1 isEqualToString:dateString2];
}

@end
