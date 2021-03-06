//
//  YDCalendarPicker.m
//  calendar
//
//  Created by YD_iOS on 16/8/12.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCalendarPicker.h"
#import "YDCalendarPickerDaysOwner.h"
#import "YDCalendarPickerCell.h"
#import "YDDayButton.h"
#import "NSDate+YDConvenience.h"
#import "YDManagerTool.h"
#import "YDLocalDefine.h"
#import "YDTimeButton.h"

@interface YDCalendarPicker ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *signView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSDate *beginDate;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightRecognizer;


@property (nonatomic, strong) UIButton *dateButton; //日期选择按钮
@property (nonatomic, strong) UIButton *timeButton; //时间选择按钮

@property (nonatomic, strong) NSDate *oldDate;

@property (nonatomic, strong) UIView *dateBGView; //日期选择背景
@property (nonatomic, strong) UIView *timeBGView; //时间选择背景

@property (nonatomic, copy) NSString *selectTime; //选中的小时

@end

@implementation YDCalendarPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //背景颜色kViewControllerBackgroundColor
        self.backgroundColor = [UIColor clearColor];
        
        _dateBGView = [[UIView alloc] initWithFrame:self.bounds];
        _dateBGView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_dateBGView];
        
        _dataSource = [[NSMutableArray alloc] init];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(kScreenWidth - kCalendarDayBlockWidth, 0, kCalendarDayBlockWidth, kSignViewHeight);
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        doneButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [doneButton setTitleColor:[UIColor colorWithRed:0 green:122 blue:255] forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_dateBGView addSubview:doneButton];
        
        _signView = [[UIView alloc] initWithFrame:CGRectMake(0, kSignViewHeight, kScreenWidth, kSignViewHeight)];
        _signView.backgroundColor = [UIColor clearColor];
        NSArray *weekSymbol = [[NSArray alloc] initWithObjects: @"一", @"二", @"三", @"四", @"五", @"六", @"日", nil];
        for (int i = 0; i < weekSymbol.count; i++)
        {
            NSString *daySymbol = (NSString *)[weekSymbol objectAtIndex: i];
            UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(kCalendarDayBlockWidth * i, 0, kCalendarDayBlockWidth, kSignViewHeight)];
            label.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize: 12.0];;
            label.text = daySymbol;
            if ([daySymbol isEqualToString:@"六"] || [daySymbol isEqualToString:@"日"])
            {
                label.textColor = [UIColor redColor];
            }
            else
            {
                label.textColor = [UIColor colorWithHexString:@"444444"];
            }
            
            label.textAlignment = KTextAlignmentCenter;
            
            UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, label.width, 0.4f)];
            topLineView.backgroundColor = kTableViewLineColor;
            [label addSubview:topLineView];
            
            [_signView addSubview: label];
        }
        [_dateBGView addSubview:_signView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSignViewHeight * 2, frame.size.width, frame.size.height - kSignViewHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = kCalendarDayBlockHeight;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        CGFloat yOffset = 44.0f * 14 + kSignViewHeight;
        _tableView.contentOffset = CGPointMake(0, yOffset);
        [_dateBGView addSubview:_tableView];
        
        [YDCalendarPickerDaysOwner sharedDaysOwner];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(selectedDayAction:) name: kNotificationSelectedDay object: nil];
        
        _leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
        [_leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        _rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
        [_rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        
        [self createTimeChooseView];
    }
    return self;
}

#pragma mark - 创建时间选择部分
- (void)createTimeChooseView
{
    CGFloat dateButtonY = kScreenWidth / 7 * 4 + 30.0f;
    
    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dateButton.frame = CGRectMake(0, dateButtonY, kScreenWidth / 2, 45.0f);
    _dateButton.backgroundColor = kNavigationBackgroundColor;
    [_dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_dateButton setTitle:@"日期" forState:UIControlStateNormal];
    _dateButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_dateButton addTarget:self action:@selector(dateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dateButton];
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButton.frame = CGRectMake(kScreenWidth / 2, dateButtonY, kScreenWidth / 2, 45.0f);
    _timeButton.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    [_timeButton setTitleColor:[UIColor colorWithHexString:@"797979"] forState:UIControlStateNormal];
    [_timeButton setTitle:@"时间" forState:UIControlStateNormal];
    _timeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_timeButton addTarget:self action:@selector(timeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_timeButton];
    
    
    //时间选择控件部分
    CGFloat timeBGViewY = _dateBGView.y + (_dateBGView.height - kTimeButtonHeight * 2) - 5.0f;
    _timeBGView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, timeBGViewY, kScreenWidth, kTimeButtonHeight * 2 + kSignViewHeight)];
    _timeBGView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_timeBGView];
    
    UIButton *tiemDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tiemDoneButton.frame = CGRectMake(kScreenWidth - kCalendarDayBlockWidth, 0, kCalendarDayBlockWidth, kSignViewHeight);
    [tiemDoneButton setTitle:@"完成" forState:UIControlStateNormal];
    tiemDoneButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [tiemDoneButton setTitleColor:[UIColor colorWithRed:0 green:122 blue:255] forState:UIControlStateNormal];
    [tiemDoneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_timeBGView addSubview:tiemDoneButton];
    
    for (int i = 0; i < 14; i++) {
        YDTimeButton *timeButton = [[YDTimeButton alloc] initWithFrame:CGRectMake(i%7 * kCalendarDayBlockWidth, i/7 * kTimeButtonHeight + kSignViewHeight, kCalendarDayBlockWidth, kTimeButtonHeight)];
        timeButton.hour = i + 8;
        [timeButton addTarget:self action:@selector(timeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_timeBGView addSubview:timeButton];
    }
}

#pragma mark 点击时间选择
- (void)timeButtonClick:(YDTimeButton *)button
{
    button.isSelect = YES;
    
    self.selectTime = [NSString stringWithFormat:@"%ld", (long)button.hour];
}

#pragma mark 点击日期选择按钮
- (void)dateButtonClick
{
    _dateBGView.hidden = NO;
    _timeBGView.hidden = NO;
    
    //颜色变化
    _dateButton.backgroundColor = kNavigationBackgroundColor;
    [_dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _timeButton.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    [_timeButton setTitleColor:[UIColor colorWithHexString:@"797979"] forState:UIControlStateNormal];
    
    //位移
    [UIView animateWithDuration:0.25f animations:^{
        _dateBGView.x = 0;
        _timeBGView.x = kScreenWidth;
    } completion:^(BOOL finished) {
        _dateBGView.hidden = NO;
        _timeBGView.hidden = YES;
    }];
    
    
}

#pragma mark 点击时间选择按钮
- (void)timeButtonClick
{
    _dateBGView.hidden = NO;
    _timeBGView.hidden = NO;
    
    //颜色变化
    _dateButton.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    [_dateButton setTitleColor:[UIColor colorWithHexString:@"797979"] forState:UIControlStateNormal];
    _timeButton.backgroundColor = kNavigationBackgroundColor;
    [_timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //位移
    [UIView animateWithDuration:0.25f animations:^{
        _dateBGView.x = -kScreenWidth;
        _timeBGView.x = 0;
    } completion:^(BOOL finished) {
        _dateBGView.hidden = YES;
        _timeBGView.hidden = NO;
    }];
}

#pragma mark - 完成按钮点击
- (void)doneButtonClick
{
    //如果选择了时间
    if (self.selectedDate) {
        NSString *dateString = [NSDate stringWithDate:self.selectedDate format:@"yyyy-MM-dd"];
        NSString *newDateString = [NSString stringWithFormat:@"%@ %.2ld:00:00", dateString , [self.selectTime integerValue]];
        self.selectedDate = [NSDate dateWithString:newDateString format:@"yyyy-MM-dd HH:mm:SS"];
    }
    
    //本次跟进时间和下次跟进时间
    if (self.selectedDate == nil) {
        self.selectedDate = [NSDate dateWithString:self.selectDateString format:@"yyyy-MM-dd HH:mm:SS"];
    }
    
    //其他时间选择
    if (self.selectedDate == nil) {
        self.selectedDate = [NSDate dateWithString:self.selectDateString format:@"yyyy-MM-dd"];
    }
    
    
    if (_ClickDateButton != nil) {
        _ClickDateButton(self, self.selectedDate);
    }
}

#pragma mark - set methods
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect rect = _tableView.frame;
    _tableView.frame = CGRectMake(0, rect.origin.y, rect.size.width, frame.size.height - kSignViewHeight);
    
    if (frame.size.height == kCalendarPickerWeeksHeight) {
        [_tableView addGestureRecognizer:_leftRecognizer];
        [_tableView addGestureRecognizer:_rightRecognizer];
    }
    else{
        [_tableView removeGestureRecognizer:_leftRecognizer];
        [_tableView removeGestureRecognizer:_rightRecognizer];
    }
}

- (void)setBeginDate:(NSDate *)beginDate
{
    _beginDate = [beginDate copy];
}

#pragma mark 设置选中日期
- (void)setSelectDateString:(NSString *)selectDateString
{
    _selectDateString = selectDateString;
    
    self.selectedDate = [NSDate dateWithString:selectDateString format:@"yyyy-MM-dd HH:mm:SS"];
    
    if (selectDateString.length > 12) {
        self.selectTime = [selectDateString substringWithRange:NSMakeRange(11, 2)];
    }
    
}

#pragma mark 设置选中小时
- (void)setSelectTime:(NSString *)selectTime
{
    _selectTime = selectTime;
    
    for (UIView *subView in _timeBGView.subviews) {
        if ([subView isKindOfClass:[YDTimeButton class]]) {
            YDTimeButton *timeButton = (YDTimeButton *)subView;
            if (timeButton.hour == [selectTime integerValue]) {
                timeButton.isSelect = YES;
            } else {
                timeButton.isSelect = NO;
            }
        }
    }
}

#pragma mark - TableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.beginDate = [[YDCalendarPickerDaysOwner sharedDaysOwner] beginDate];
    NSDate *endDate = [[YDCalendarPickerDaysOwner sharedDaysOwner] endDate];
    NSTimeInterval interval = [endDate timeIntervalSinceDate: self.beginDate];
    int dayCount = interval / 86400;
    if(fmod(interval, 7) != 0)
    {
        return 46;
        return (dayCount / 7) + 1;
    }
    else{
        return 45;
        return dayCount / 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CalendarPickerCell";
    YDCalendarPickerCell *cell = (YDCalendarPickerCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[YDCalendarPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = indexPath.row;
    cell.tag = row;
    cell.selectDate = _oldDate;
    cell.selectDateString = self.selectDateString;
    cell.beginDate = [self.beginDate offsetDay:(7 * row)];
    cell.editing = tableView.editing;
    return cell;
}

#pragma mark - Scroll Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"注意这里-----WillBeginDragging");
    if (_tableView.frame.size.height == kCalendarDayBlockHeight) {
//        if ([_delegate respondsToSelector:@selector(calendarPicker:changeFromStyle:toStyle:changeToHeight:animated:)])
//        {
//            [_delegate calendarPicker:self changeFromStyle:YDCalendarPickerStyleWeeks toStyle:YDCalendarPickerStyleDays changeToHeight:kCalendarPickerDaysHeight animated:YES];
//        }
    }
    self.tableView.editing = YES;
    
    NSArray *visibles = [_tableView visibleCells];
    for (UITableViewCell *cell in visibles) {
        cell.editing = YES;
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!_tableView.decelerating && !_tableView.dragging) {
        NSLog(@"EndDragging");
        self.tableView.editing = NO;
        
        NSArray *visibles = [_tableView visibleCells];
        for (UITableViewCell *cell in visibles) {
            cell.editing = NO;
        }
    }
    [_tableView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViewSender
{
    NSLog(@"DidEndDecelerating");
    self.tableView.editing = NO;
    
    NSArray *visibles = [_tableView visibleCells];
    for (UITableViewCell *cell in visibles) {
        cell.editing = NO;
    }
    [_tableView reloadData];
}


#pragma mark - UIGestureRecognizer

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    CGRect rect = _tableView.frame;
    CGPoint location = [gestureRecognizer locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath.row != [_tableView numberOfRowsInSection:0]) {
        YDCalendarPickerCell *cell = (YDCalendarPickerCell *)[_tableView cellForRowAtIndexPath:indexPath];
        UIImageView *currentWeekImgView = [[UIImageView alloc] initWithImage: [YDManagerTool imageFromView:cell.contentView]];
        currentWeekImgView.frame = CGRectMake(0, rect.origin.y, kScreenWidth, rect.size.height);
        [self addSubview: currentWeekImgView];
        
        _tableView.frame = CGRectMake(323, rect.origin.y, kScreenWidth, rect.size.height);
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        [UIView animateWithDuration: .65
                         animations:^{
                             currentWeekImgView.frame = CGRectMake(-kScreenWidth, rect.origin.y, kScreenWidth, rect.size.height);
                             _tableView.frame = CGRectMake(0, rect.origin.y, kScreenWidth, rect.size.height);
                         }
                         completion:^(BOOL finished){
                             [currentWeekImgView removeFromSuperview];
                         }
         ];
    }
    

}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    CGRect rect = _tableView.frame;
    CGPoint location = [gestureRecognizer locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath.row == 0) {
        return;
    }
    
    YDCalendarPickerCell *cell = (YDCalendarPickerCell *)[_tableView cellForRowAtIndexPath:indexPath];
    UIImageView *currentWeekImgView = [[UIImageView alloc] initWithImage: [YDManagerTool imageFromView:cell.contentView]];
    currentWeekImgView.frame = CGRectMake(0, rect.origin.y, kScreenWidth, rect.size.height);
    [self addSubview: currentWeekImgView];
    
    _tableView.frame = CGRectMake(-kScreenWidth, rect.origin.y, kScreenWidth, rect.size.height);
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [UIView animateWithDuration: .65
                     animations:^{
                         currentWeekImgView.frame = CGRectMake(323, rect.origin.y, kScreenWidth, rect.size.height);
                         _tableView.frame = CGRectMake(0, rect.origin.y, kScreenWidth, rect.size.height);
                     }
                     completion:^(BOOL finished){
                         [currentWeekImgView removeFromSuperview];
                     }
     ];
}

#pragma mark - NSNotification

- (void)selectedDayAction:(NSNotification *)aNotification
{
    NSDate *selectedDate = nil;
    
    if (aNotification != nil) {
        YDDayButton *dayBlock = aNotification.object;
        
        YDDayButton *selectedBlock = [[YDCalendarPickerDaysOwner sharedDaysOwner] selectedBlock];
        if (selectedBlock != nil) {
            selectedBlock.blockState = YDDayBlockStateNoraml;
        }
        
        //2016.10.18,wry添加,点击后按钮变色
        dayBlock.isSelect = YES;
        _oldDate = dayBlock.blockDate;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.selectDateString = [dateFormatter stringFromDate:_oldDate];
        [self.tableView reloadData];
        
        [YDCalendarPickerDaysOwner sharedDaysOwner].selectedBlock = dayBlock;
        selectedDate = [[YDManagerTool sharedTool] ConvertToZeroInMorning:dayBlock.blockDate];
        [YDCalendarPickerDaysOwner sharedDaysOwner].selectedDate = selectedDate;
    }
    else{
        selectedDate = [NSDate date];
    }
    
    self.selectedDate = selectedDate;
#warning 选择的时间返回值小一天，在这加上一天 1016.12.13
    self.selectedDate = [NSDate dateWithTimeInterval:24*60*60*1 sinceDate:self.selectedDate];
}

@end
