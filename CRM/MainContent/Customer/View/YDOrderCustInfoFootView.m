//
//  YDOrderCustInfoFootView.m
//  CRM
//
//  Created by ios on 16/11/4.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDOrderCustInfoFootView.h"

@interface YDOrderCustInfoFootView ()

@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation YDOrderCustInfoFootView

- (instancetype)init
{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIView *topLineView = [[UIView alloc] init];
    topLineView.frame = CGRectMake(0, 0, kScreenWidth, 5.0f);
    topLineView.backgroundColor = kViewControllerBackgroundColor;
    [self addSubview:topLineView];
    
    UIView *infoBGView = [[UIView alloc] init];
    infoBGView.frame = CGRectMake(0, 5.0f, kScreenWidth, 75.0f);
    infoBGView.backgroundColor = [UIColor whiteColor];
    [self addSubview:infoBGView];
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.size = CGSizeMake(32.0f, 32.0f);
    _stateLabel.center = CGPointMake(16.0f + 25.0f, 40.0f);
    _stateLabel.layer.cornerRadius = 16.0f;
    _stateLabel.layer.masksToBounds = YES;
    _stateLabel.font = [UIFont systemFontOfSize:18.0f];
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_stateLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 100.0f - 25.0f, 15.0f, 100.0f, 20.0f)];
    _timeLabel.textColor = kTwoTextColor;
    _timeLabel.text = @"2016-11-1";
    _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLabel];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stateLabel.maxX + 25.0f, 35.0f, kScreenWidth - _stateLabel.maxX - 50.0f, 40.0f)];
    _subTitleLabel.textAlignment = NSTextAlignmentRight;
    _subTitleLabel.numberOfLines = 0;
    _subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_subTitleLabel];
}

- (void)setFootType:(NSInteger)footType
{
    _footType = footType;
    
    if (footType == 1) {
        //交车
        _stateLabel.text = @"交";
        _stateLabel.backgroundColor = kGreenButtonBackgroundColor;
    } else {
        //取消订单
        _stateLabel.text = @"取";
        _stateLabel.backgroundColor = kRedButtonBackgroundColor;
    }
}

@end
