//
//  YDTimeButton.m
//  CRM
//
//  Created by ios on 2016/12/13.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDTimeButton.h"
#import "YDLocalDefine.h"

@interface YDTimeButton ()

@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;

@end

@implementation YDTimeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"FBFBFB"];
        self.layer.borderColor = kTableViewLineColor.CGColor;
        self.layer.borderWidth = 0.2f;
        
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.font = [UIFont systemFontOfSize:12.0f];
        _hourLabel.frame = CGRectMake(0, 0, (kScreenWidth + 10.0f)/7/2, kTimeButtonHeight);
        _hourLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_hourLabel];
        
        _minuteLabel = [[UILabel alloc] init];
        _minuteLabel.frame = CGRectMake(_hourLabel.maxX, 4.0f, _hourLabel.width, _hourLabel.height - 4.0f);
        _minuteLabel.font = [UIFont systemFontOfSize:8.0f];
        _minuteLabel.text = @"00";
        _minuteLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_minuteLabel];
    }
    return self;
}

- (void)setHour:(NSInteger)hour
{
    _hour = hour;
    
    _hourLabel.text = [NSString stringWithFormat:@"%.2ld:", hour];
}

- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    
    if (isSelect) {
        self.backgroundColor = kNavigationBackgroundColor;
        _hourLabel.textColor = [UIColor whiteColor];
        _minuteLabel.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor colorWithHexString:@"FBFBFB"];
        _hourLabel.textColor = [UIColor blackColor];
        _minuteLabel.textColor = [UIColor blackColor];
    }
}

@end
