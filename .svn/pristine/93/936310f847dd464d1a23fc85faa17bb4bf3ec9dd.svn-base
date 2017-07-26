//
//  YDBuyCarOptionCell.m
//  CRM
//
//  Created by ios on 16/10/29.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDBuyCarOptionCell.h"


@interface YDBuyCarOptionCell ()

@property (nonatomic, strong) UIImageView *selectImageView;

@end

@implementation YDBuyCarOptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self cretaeUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"YDBuyCarOptionCellID";
    YDBuyCarOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if(cell == nil) {
        cell = [[YDBuyCarOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

- (void)cretaeUI
{
    _selectImageView = [[UIImageView alloc] init];
    _selectImageView.image = [UIImage imageNamed:@"followupOver_h"];
    _selectImageView.hidden = YES;
    _selectImageView.frame = CGRectMake(kScreenWidth - 40.0f, 20.0f, 14.0f, 10.0f);
    [self addSubview:_selectImageView];
    
    //cell的分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 48.5f, kScreenWidth, 0.5f)];
    lineView.backgroundColor = kTableViewLineColor;
    [self addSubview:lineView];
    
    self.textLabel.font = [UIFont systemFontOfSize:14.0f];
}

- (void)setIsSelectCell:(BOOL)isSelectCell
{
    if (isSelectCell) {
        
        _selectImageView.hidden = NO;
        self.textLabel.textColor = kNavigationBackgroundColor;
        
    } else {
        _selectImageView.hidden = YES;
        self.textLabel.textColor = [UIColor blackColor];
    }
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
