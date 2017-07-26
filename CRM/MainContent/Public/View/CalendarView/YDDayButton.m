//
//  YDDayButton.m
//  calendar
//
//  Created by YD_iOS on 16/8/12.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDDayButton.h"
#import "NSDate+YDConvenience.h"
#import "YDCalendarPickerDaysOwner.h"
#import "YDLocalDefine.h"

@interface YDDayButton(){
    NSDateFormatter *_dayFormatter;
    NSDateFormatter *_monthFormatter;
}

@property (nonatomic, retain) UILabel *movingLabel;

@property (nonatomic, strong) UIView *coverView;

@end

@implementation YDDayButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _dayFormatter = [[NSDateFormatter alloc] init];
        _dayFormatter.dateFormat = @"d";
        
        _monthFormatter = [[NSDateFormatter alloc]init];
        _monthFormatter.dateFormat = @"M";
        
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.2f, self.height)];
        leftLineView.backgroundColor = kTableViewLineColor;
        [self addSubview:leftLineView];
        
        UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(self.maxX - 0.2f, 0, 0.2f, self.height)];
        rightLineView.backgroundColor = kTableViewLineColor;
        [self addSubview:rightLineView];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.2f)];
        topView.backgroundColor = kTableViewLineColor;
        [self addSubview:topView];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.maxY - 0.2f, self.width, 0.2f)];
        bottomLineView.backgroundColor = kTableViewLineColor;
        [self addSubview:bottomLineView];
        
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.alpha = 0.9f;
        _coverView.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
        [self addSubview:_coverView];
    }
    return self;
}

#pragma mark - get methods

- (UILabel *)movingLabel
{
    if (_movingLabel == nil) {
        _movingLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 35) / 2, 0, 35, self.bounds.size.height)];
        _movingLabel.numberOfLines = 0;
        _movingLabel.backgroundColor = [UIColor clearColor];
        _movingLabel.textAlignment = KTextAlignmentCenter;
        _movingLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _movingLabel;
}

#pragma mark - set methods

- (void)setBlockDate:(NSDate *)aDate
{
    _blockDate = aDate;
    [self setBlockInfo];
}

- (void)setBlockState:(YDDayBlockState)state
{
    _blockState = state;
    self.selected = NO;
    
    NSDate *selectedDate = nil;
    switch (_blockState) {
        case YDDayBlockStateNoraml:
            [self setBlocksStyleNormal];
            break;
        case YDDayBlockStateSelected:
            self.selected = YES;
            if ([YDCalendarPickerDaysOwner sharedDaysOwner].selectedBlock == nil) {
                selectedDate = [[YDCalendarPickerDaysOwner sharedDaysOwner] selectedDate];
                if ([_blockDate compareWithDate:selectedDate] == YDDateCompareEqual) {
                    [YDCalendarPickerDaysOwner sharedDaysOwner].selectedBlock = self;
                }
            }
            [self setBlocksStyleNormal];
            break;
        case YDDayBlockStateMoving:
            [self setBlockStyleMoving];
            break;
            
        default:
            break;
    }
}

#pragma mark - private: The block information

- (void)setBlockInfoToday
{
    //设置当天button
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"52CDB5"] size:self.size] forState:(UIControlStateNormal)];
    NSString *title_ = [NSString stringWithFormat:@"%@月\n%@",[_monthFormatter stringFromDate:_blockDate],[_dayFormatter stringFromDate:_blockDate]];
    [self setTitle:title_ forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _coverView.hidden = YES;
}
-(void)setBlockInfoLastDay{
    //设置过去的日期
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F9F9F9"] size:self.size] forState:(UIControlStateNormal)];
    self.userInteractionEnabled = YES;
}
- (void)setBlockInfoFirstDay{
    //设置每月1号
    NSString *title_ = [NSString stringWithFormat:@"%@月\n%@",[_monthFormatter stringFromDate:_blockDate],[_dayFormatter stringFromDate:_blockDate]];
    [self setTitle:title_ forState:UIControlStateNormal];
}

- (void)setBlockInfo
{
    [self setTitle:[_dayFormatter stringFromDate:_blockDate] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([[_monthFormatter stringFromDate:_blockDate] integerValue] % 2 == 1) {
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.size] forState:(UIControlStateNormal)];

    }else{
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F9F9F9"] size:self.size] forState:(UIControlStateNormal)];
    }

    if ([[_dayFormatter stringFromDate:_blockDate] isEqualToString:@"1"]){
        [self setBlockInfoFirstDay];
    }
    
    if ([_blockDate isEqualToDate:[NSDate date]]) {
        [self setBlockInfoToday];
    }else if ([_blockDate timeIntervalSinceNow] < 0){
        [self setBlockInfoLastDay];
    }
    _coverView.hidden = YES;
}

#pragma mark - private: The style of the block

- (void)setBlocksStyleNormal
{
    _coverView.hidden = YES;
    
    [self.movingLabel removeFromSuperview];
    self.titleLabel.alpha = 1.0;
    
    [self setBlockInfo];
}

//
- (void)setBlockStyleMoving
{

    _coverView.hidden = NO;
    
    [self.movingLabel removeFromSuperview];
    //self.titleLabel.alpha = 0;
    
    //[self setBlockInfo];
    
    NSDate *selectedDate = [[YDCalendarPickerDaysOwner sharedDaysOwner] selectedDate];
    if ([_blockDate compareWithDate:selectedDate] == YDDateCompareEqual) {
        [YDCalendarPickerDaysOwner sharedDaysOwner].selectedBlock = self;
        self.selected = YES;
    }
    
    NSInteger row = [_blockDate countOfWeeksInMonth] / 2 + 1;
    if ([_blockDate weekInMonth] == row && [_blockDate week] == 5) {
        self.movingLabel.text = [NSString stringWithFormat:@"%ld%ld月", (long)[_blockDate year], (long)[_blockDate month]];
        [self addSubview: self.movingLabel];
    }
}

- (void)setIsSelect:(BOOL)isSelect
{
    if (isSelect) {
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"528ECD"] size:self.size] forState:(UIControlStateNormal)];
        NSString *title_ = [NSString stringWithFormat:@"%@月\n%@",[_monthFormatter stringFromDate:_blockDate],[_dayFormatter stringFromDate:_blockDate]];
        [self setTitle:title_ forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _coverView.hidden = YES;
    }
}

#pragma mark - block click

- (void)clickAction:(id)sender
{
    if (!self.selected) {
        self.selected = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationSelectedDay object:self userInfo:nil];
    }
}


@end
