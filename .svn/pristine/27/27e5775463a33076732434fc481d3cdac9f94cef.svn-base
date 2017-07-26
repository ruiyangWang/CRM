//
//  YDPickView.m
//  CRM
//
//  Created by YD_iOS on 16/8/3.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDPickView.h"

@interface YDPickView()

@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)UIToolbar *toolBar;

@end

@implementation YDPickView


- (instancetype )initWithView:(UITextField *)tView type:(YDPickType)t{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)]) {
        
        //
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 200)];
        
        // 设置可以选择的时间区域
//        NSTimeInterval timeInterval=60*60*24*365;
//        NSDate *oneYearFromToday = [[NSDate date] dateByAddingTimeInterval:timeInterval];
//        NSDate *twoYearsFromToday = [[NSDate date] dateByAddingTimeInterval:2 * timeInterval];
//        [_datePicker setMinimumDate:oneYearFromToday];
//        [_datePicker setMaximumDate:twoYearsFromToday];
        
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
        [_datePicker setDate:[NSDate new] animated:NO];
        [self addSubview:_datePicker];
        
        //
        _toolBar = [[UIToolbar alloc]init];
        _toolBar.bounds = CGRectMake(0, 0, kScreenWidth, 40);
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickFinishButton)];
        _toolBar.items = @[flexSpace,finish];
        tView.inputAccessoryView = _toolBar;
        
    }
    
    return self;
}

-(void)clickFinishButton{
    
    if (_ClickFinishButtonBlock != nil) {
        _ClickFinishButtonBlock(@"", _datePicker.date);
    }
}

-(void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{
    if ([paramDatePicker isEqual:_datePicker]){
        NSLog(@"Selected date = %@", paramDatePicker.date);
    }
}

@end
