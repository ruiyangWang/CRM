//
//  YDImportCustCell.m
//  CRM
//
//  Created by ios on 16/8/1.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDImportCustCell.h"
#import "YDImportCustModel.h"


@interface YDImportCustCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *selectView;

@property (nonatomic, strong) UILabel *nameLabel;

@end
@implementation YDImportCustCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"YDImportCustCell";
    YDImportCustCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[YDImportCustCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _bgView = [[UIView alloc] init];
    _bgView.frame = CGRectMake(0, 0, kScreenWidth, 49.0f);
    [self addSubview:_bgView];
    
    _selectView = [[UIImageView alloc] init];
    _selectView.frame = CGRectMake(25.0f, (49.0f - 12.0f) / 2, 12.0f, 12.0f);
    [_bgView addSubview:_selectView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(_selectView.maxX + 7.0f, 0, 250.0f, 49.0f);
    _nameLabel.font = [UIFont systemFontOfSize:14.0f];
    [_bgView addSubview:_nameLabel];
    
    _lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(0, 48.5f, kScreenWidth, 0.5f);
    _lineView.backgroundColor = kTableViewLineColor;
    [_bgView addSubview:_lineView];
}

- (void)setCustModel:(YDImportCustModel *)custModel
{
    _custModel = custModel;
    
    _nameLabel.text = custModel.name;
    
    if (custModel.isSelected) {
        //选中状态
        _bgView.backgroundColor = kNavigationBackgroundColor;
        _selectView.image = [UIImage imageNamed:@"selected_status_button"];
        _nameLabel.textColor = [UIColor whiteColor];
    } else {
        //未选中状态
        _bgView.backgroundColor = [UIColor whiteColor];
        _selectView.image = [UIImage imageNamed:@"not_selected_stutas_button"];
        _nameLabel.textColor = [UIColor blackColor];
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
