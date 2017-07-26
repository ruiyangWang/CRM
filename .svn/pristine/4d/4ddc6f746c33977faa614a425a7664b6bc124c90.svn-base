//
//  YDSalesCell.m
//  CRM
//
//  Created by YD_iOS on 16/8/24.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDSalesCell.h"

@interface YDSalesCell()

@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIButton *badgeButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameInfo;

@end

@implementation YDSalesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setM:(YDSalesModel *)m{
    _m = m;
    
    [_titleButton setTitle:@"头" forState:(UIControlStateNormal)];
    [_badgeButton setTitle:m.badge forState:(UIControlStateNormal)];
    
    if ([m.badge integerValue] >3) {
        _badgeButton.hidden = YES;
    }else{
        _badgeButton.hidden = NO;
    }
        
    
    _nameLabel.text = m.memberName;
    _nameInfo.text = @"销售顾问";
    
    
}

@end
