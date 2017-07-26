//
//  YDFollowApplyCell.m
//  CRM
//
//  Created by ios on 16/10/21.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDFollowApplyCell.h"
#import "YDFollowApplyModel.h"


@interface YDFollowApplyCell ()
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventResultLabel;

@end

@implementation YDFollowApplyCell


- (void)setFollowApplyModel:(YDFollowApplyModel *)followApplyModel
{
    _followApplyModel = followApplyModel;
    
    //时间
    NSString *createTime = followApplyModel.createTime;
    self.monthLabel.text = [createTime substringWithRange:NSMakeRange(5, 2)];
    self.dayLabel.text = [createTime substringWithRange:NSMakeRange(8, 2)];
    
    self.monthLabel.text = [NSString stringWithFormat:@"%@月", self.monthLabel.text];
    
    //事件类型
    NSInteger type = [followApplyModel.type integerValue];
    self.eventTypeLabel.text = type == 0 ? @"申诉申请" : @"战败申请";
    
    //申请人
    self.applyPersonLabel.text = followApplyModel.applyMemberName;
    
    //事件结果
    self.eventResultLabel.text = followApplyModel.result;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
