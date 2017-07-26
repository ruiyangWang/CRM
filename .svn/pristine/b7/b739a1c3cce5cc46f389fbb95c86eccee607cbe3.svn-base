//
//  YDFollowArchivesCell.m
//  CRM
//
//  Created by ios on 16/10/21.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDFollowArchivesCell.h"
#import "YDFollowArchivesModel.h"
#import "NSString+Size.h"


@interface YDFollowArchivesCell ()

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIView *dateView;

@end

@implementation YDFollowArchivesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    //日期，放在一个view上（dateView）
    _dateView = [[UIView alloc] init];
    _dateView.frame = CGRectMake(0, 0, 70.0f, 40.0f);
    [self addSubview:_dateView];
    
    _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 37.0f, 21.0f)];
    _monthLabel.text = @"12月";
    _monthLabel.font = [UIFont systemFontOfSize:10.0f];
    _monthLabel.textAlignment = NSTextAlignmentRight;
    _monthLabel.textColor = [UIColor colorWithRed:80 green:106 blue:134];
    [_dateView addSubview:_monthLabel];
    
    UIImageView *dateLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(28.0f, 5.0f, 20.0f, 28.0f)];
    dateLineImageView.image = [UIImage imageNamed:@"tilt_line_date"];
    [_dateView addSubview:dateLineImageView];
    
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(37.0f, 21.0f, 32.0f, 18.0f)];
    _dayLabel.text = @"29";
    _dayLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _dayLabel.textColor = [UIColor colorWithRed:80 green:106 blue:134];
    [_dateView addSubview:_dayLabel];
    
}


- (void)setFollowArchivesModel:(YDFollowArchivesModel *)followArchivesModel
{
    _followArchivesModel = followArchivesModel;
    
    int i = 0;
    for (NSDictionary *changeDic in followArchivesModel.contentExt) {
        NSString *changeString = changeDic[@"val"];
        NSArray *valArray = [changeString componentsSeparatedByString:@"/"];
        UIView *view = [self changeViewWithTitle:changeDic[@"key"] value1:[valArray lastObject] value2:[valArray firstObject]];
        view.frame = CGRectMake(77.0f, kOnlyOneCellHeight * i++, kScreenWidth - 77.0f, kOnlyOneCellHeight);
        [self addSubview:view];
    }

    
    CGFloat dateViewY = ((followArchivesModel.contentExt.count * kOnlyOneCellHeight + 20.0f) - 40.0f) / 2;
    _dateView.frame = CGRectMake(0, dateViewY, 70.0f, 40.0f);
    self.monthLabel.text = [NSString stringWithFormat:@"%@月", [followArchivesModel.createdAt substringWithRange:NSMakeRange(5, 2)]];
    self.dayLabel.text = [followArchivesModel.createdAt substringWithRange:NSMakeRange(8, 2)];
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kTableViewLineColor;
    lineView.frame = CGRectMake(0, followArchivesModel.contentExt.count * kOnlyOneCellHeight + 20.0f - 0.5f, kScreenWidth, 0.5f);
    [self addSubview:lineView];
}


#pragma mark 创建跟进记录变更的view
- (UIView *)changeViewWithTitle:(NSString *)title value1:(NSString *)value1 value2:(NSString *)value2
{
    
    UIView *view = [[UIView alloc] init];
    
    //更改的子段名称
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15.0f, 100.0f, 20.0f)];
    titleLabel.text = [NSString stringWithFormat:@"%@:", title];
    titleLabel.font = [UIFont systemFontOfSize:12.0f];
    titleLabel.textColor = kTwoTextColor;
    [view addSubview:titleLabel];
    
    //旧值
    CGFloat oldLabelWidth = [value1 sizeWithWidth:100.0f andFont:12.0f].width + 5.0f;
    UILabel *oldValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35.0f, oldLabelWidth, 20.0f)];
    oldValueLabel.text = value1;
    oldValueLabel.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:oldValueLabel];
    
    //向右箭头
    UIImageView *rightArrow = [[UIImageView alloc] init];
    rightArrow.image = [UIImage imageNamed:@"follow_rightArrow"];
    rightArrow.frame = CGRectMake(oldLabelWidth + 3.0f, 42.0f, 47.0f, 6.0f);
    [view addSubview:rightArrow];
    
    //新值
    UILabel *newValueLabel = [[UILabel alloc] init];
    newValueLabel.text = value2;
    newValueLabel.font = [UIFont systemFontOfSize:12.0f];
    newValueLabel.frame = CGRectMake(oldLabelWidth + 47.0f + 10.0f, 35.0f, 100.0f, 20.0f);
    [view addSubview:newValueLabel];
    
    return view;
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
