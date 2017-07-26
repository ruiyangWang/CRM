//
//  YDSearchCarModelCell.m
//  CRM
//
//  Created by YD_iOS on 16/8/2.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDSearchCarModelCell.h"

@interface YDSearchCarModelCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *shadowImageView; //阴影图片
@end
@implementation YDSearchCarModelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 48.5f, kScreenWidth, 0.5f)];
    _lineView.backgroundColor = kTableViewLineColor;
    [self.contentView addSubview:_lineView];
    
    _shadowImageView = [[UIImageView alloc] init];
    _shadowImageView.image = [UIImage imageNamed:@"shadow_chooseCar_cell"];
    _shadowImageView.frame = CGRectMake(0, 0, kScreenWidth, 49.0f);
    _shadowImageView.hidden = YES;
    [self.contentView addSubview:_shadowImageView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setT:(NSString *)t{
    _t = t;
    _title.text = t;
}
-(void)setSubT:(NSString *)subT{
    _subT = subT;
    _subTitle.text = subT;
    
    if ([subT isEqualToString:@"品牌"]) {
        _title.font = [UIFont boldSystemFontOfSize:16.0f];
        _title.textColor = kNavigationBackgroundColor;
        _subTitle.textColor = kNavigationBackgroundColor;
        self.backgroundColor = [UIColor whiteColor];
        _titleLeft.constant = 17.0f;
        _lineView.frame = CGRectMake(0, 48.5f, kScreenWidth, 0.5f);
    } else if ([subT isEqualToString:@"车系"]) {
        _title.font = [UIFont systemFontOfSize:14.0f];
        _title.textColor = kNavigationBackgroundColor;
        _subTitle.textColor = kNavigationBackgroundColor;
        self.backgroundColor = [UIColor whiteColor];
        _titleLeft.constant = 22.0f;
        _lineView.frame = CGRectMake(0, 48.5f, kScreenWidth, 0.5f);
    } else if ([subT isEqualToString:@"车型"]) {
        _title.font = [UIFont systemFontOfSize:13.0f];
        _title.textColor = kTwoTextColor;
        _subTitle.textColor = kTwoTextColor;
        self.backgroundColor = [UIColor colorWithHexString:@"F6FAFF"];
        _titleLeft.constant = 22.0f;
        _lineView.frame = CGRectMake(0, 44.5f, kScreenWidth, 0.5f);
    }
    
    [_title layoutIfNeeded];
}

- (void)setIsShowShadow:(BOOL)isShowShadow
{
    _isShowShadow = isShowShadow;
    
    _shadowImageView.hidden = !isShowShadow;
}

@end
