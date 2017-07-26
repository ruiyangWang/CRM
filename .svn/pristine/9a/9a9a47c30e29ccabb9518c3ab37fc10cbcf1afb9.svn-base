//
//  YDMessageCell.m
//  CRM
//
//  Created by YD_iOS on 16/7/13.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDMessageCell.h"
#import "YDMessageModel.h"

@interface YDMessageCell ()

@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;


@end

@implementation YDMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = kViewControllerBackgroundColor;
    self.backgroundColor = kViewControllerBackgroundColor;
    
    _BGView.backgroundColor = [UIColor whiteColor];
    
    
    _lineView.backgroundColor = kTableViewLineColor;
    _lineView.height = 0.5f;
    
    _titleLabel.textColor = kNavigationBackgroundColor;
}

- (void)setMessageModel:(YDMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    NSDate *date = [NSDate dateWithString:_messageModel.createdAtString format:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [NSDate stringWithDate:date format:@"yyyy年 MM月dd日 HH:mm"];
    
    NSArray *array = [_messageModel.content componentsSeparatedByString:@"]"];
    
    NSString *titleString = [array firstObject];
    self.titleLabel.text = [titleString substringFromIndex:1];
    
    self.subTitleLabel.text = array.count > 1 ? array[1] : @"";
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
