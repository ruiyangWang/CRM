//
//  YDUpdateCustomersCell.m
//  CRM
//
//  Created by YD_iOS on 16/7/21.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDUpdateCustomersCell.h"
#import "NSDate+YDConvenience.h"

@interface YDUpdateCustomersCell()

@property (weak, nonatomic) IBOutlet UILabel *timeString;
@property (weak, nonatomic) IBOutlet UILabel *pCount;
@property (weak, nonatomic) IBOutlet UIView *priceBGView;

@end

@implementation YDUpdateCustomersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPModel:(YDPassengerModel *)pModel{
    _pModel = pModel;
    
    NSDate *cDate = [NSDate dateWithString:pModel.createTime format:@"yyy-MM-dd HH:mm:ss"];
  
    //把字符串转成时间再判断
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:pModel.createTime];
    
    if (date.hours < 12) {
        _timeString.text = [NSString stringWithFormat:@"%@ 上午 %@",[NSDate compareDate:cDate], [NSDate stringWithDate:cDate format:@"HH:mm"]];
    }else{
        _timeString.text = [NSString stringWithFormat:@"%@ 下午 %@",[NSDate compareDate:cDate], [NSDate stringWithDate:cDate format:@"HH:mm"]];
    }
    
    _pCount.text = [NSString stringWithFormat:@"%ld 人",(long)pModel.count];
    
    _priceBGView.hidden = !pModel.hasQuote;

}

@end
