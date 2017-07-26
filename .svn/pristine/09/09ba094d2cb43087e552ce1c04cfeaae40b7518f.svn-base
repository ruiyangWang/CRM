//
//  YDCustDetail2Cell.m
//  CRM
//
//  Created by ios on 16/7/27.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCustDetail2Cell.h"
#import "YDFollowInfoModel.h"


@interface YDCustDetail2Cell ()

/**
 *  跟进进度
 */
@property (weak, nonatomic) IBOutlet UILabel *fllowInfoLabel;

/**
 *  月份
 */
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

/**
 *  日
 */
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

/**
 *  跟进事件
 */
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;

/**
 *  客户等级标签
 */
@property (weak, nonatomic) IBOutlet UILabel *custGradeLabel;

/**
 *  客户进度标签
 */
@property (weak, nonatomic) IBOutlet UILabel *custEventLabel;

@end

@implementation YDCustDetail2Cell


- (void)setFollowInfoModel:(YDFollowInfoModel *)followInfoModel
{
    _followInfoModel = followInfoModel;
    
    //跟进方式
    if ([followInfoModel.followWay longLongValue] == 1) {
        self.fllowInfoLabel.text = @"客户到店";
    } else {
        self.fllowInfoLabel.text = @"电话／线上沟通";
    }
    
    //备注
    self.eventLabel.text = followInfoModel.remark.length > 0 ? followInfoModel.remark : @"无备注";
    
    //客户跟进进度 （1报价; 2试驾; 3下订）
    self.custEventLabel.hidden = NO;
    if ([followInfoModel.eventType isEqualToString:@"1"]) {
        self.custEventLabel.text = @"报价";
    } else if ([followInfoModel.eventType isEqualToString:@"2"]) {
        self.custEventLabel.text = @"试驾";
    } else if ([followInfoModel.eventType isEqualToString:@"3"]) {
        self.custEventLabel.text = @"下订";
    } else {
        self.custEventLabel.hidden = YES;
    }
    
    //客户意向等级
    self.custGradeLabel.text = [NSString stringWithFormat:@"%@级", followInfoModel.customerLevel];
    if ([followInfoModel.customerLevel isEqualToString:@"H"]) {
        self.custGradeLabel.backgroundColor = kHBackgroundColor;
    } else if ([followInfoModel.customerLevel isEqualToString:@"A"]) {
        self.custGradeLabel.backgroundColor = kABackgroundColor;
    } else if ([followInfoModel.customerLevel isEqualToString:@"B"]) {
        self.custGradeLabel.backgroundColor = kBBackgroundColor;
    } else if ([followInfoModel.customerLevel isEqualToString:@"C"]) {
        self.custGradeLabel.backgroundColor = kCBackgroundColor;
    } else {
        self.custGradeLabel.backgroundColor = kNavigationBackgroundColor;
    }
    
    //当前跟进时间
    NSString *currFollowTime = followInfoModel.currFollowTime;
    self.monthLabel.text = [NSString stringWithFormat:@"%@月", [currFollowTime substringWithRange:NSMakeRange(5, 2)]];
    self.dayLabel.text = [currFollowTime substringWithRange:NSMakeRange(8, 2)];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.fllowInfoLabel.text = @"线通的时间我企鹅";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
