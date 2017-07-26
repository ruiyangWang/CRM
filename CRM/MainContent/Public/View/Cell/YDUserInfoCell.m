//
//  YDUserInfoCell.m
//  CRM
//
//  Created by YD_iOS on 16/7/19.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDUserInfoCell.h"

@interface YDUserInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *userLevel;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet UILabel *lastTime;//需要自己加上 上次跟进时间：  这几个字符串
@property (weak, nonatomic) IBOutlet UILabel *userState;// 报价 ...
@property (weak, nonatomic) IBOutlet UIButton *addInfoButton;
@property (weak, nonatomic) IBOutlet UIView *titleBGView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addInfoButton_w;

@end

@implementation YDUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCustListModel:(YDCustListModel *)custListModel{
    
    _custListModel = custListModel;
    
    _userLevel.text = custListModel.customerLevel;
    _userName.text = custListModel.customerName;
    
    _carName.text = [NSString stringWithFormat:@"%@", custListModel.carTypeName];
    if(custListModel.carTypeName.length == 0){
        _carName.text = @"没有";
    }
    
    if (custListModel.carTypeName.length > 26) {
        _carName.lineBreakMode = NSLineBreakByTruncatingTail;
    } else {
        _carName.lineBreakMode = NSLineBreakByCharWrapping;
    }
    
    //上次跟进时间
    if (custListModel.currFollowTime.length > 0) {
        NSString *d = [NSDate stringWithDate:[NSDate dateWithString:custListModel.currFollowTime format:@"yyyy-MM-dd HH:mm:ss"] format:@"yyyy-MM-dd"];
        _lastTime.text = [NSString stringWithFormat:@"上次跟进时间：%@",d];;
    } else {
        NSString *d = [NSDate stringWithDate:[NSDate dateWithString:custListModel.lastFollowTime format:@"yyyy-MM-dd HH:mm:ss"] format:@"yyyy-MM-dd"];
        _lastTime.text = [NSString stringWithFormat:@"上次跟进时间：%@",d];;
    }
    if (custListModel.custType == CustListCustTypeOrder && custListModel.lastFollowTime.length <= 0) {
        NSString *d = [NSDate stringWithDate:[NSDate dateWithString:custListModel.createTime format:@"yyyy-MM-dd HH:mm:ss"] format:@"yyyy-MM-dd"];
        _lastTime.text = [NSString stringWithFormat:@"上次跟进时间：%@",d];;
    }
    
    
//    if ([custListModel.eventType isEqualToString:@"100"]) {
//        _userState.text = @"报价";
//    }else if ([custListModel.eventType isEqualToString:@"010"]){
//        _userState.text = @"试驾";
//    }else if ([custListModel.eventType isEqualToString:@"001"]){
//        _userState.text = @"下订";
//    } else {
//        _userState.text = @"";
//    }
    
    _userState.text = custListModel.flag.length > 0 ? custListModel.flag : @"";
    
    _userLevel.font = [UIFont systemFontOfSize:24.0f];
    if ([custListModel.customerLevel isEqualToString:@"A"]) {
        _userLevel.backgroundColor = kABackgroundColor;
    } else if ([custListModel.customerLevel isEqualToString:@"B"]) {
        _userLevel.backgroundColor = kBBackgroundColor;
    } else if ([custListModel.customerLevel isEqualToString:@"C"]) {
        _userLevel.backgroundColor = kCBackgroundColor;
    } else if ([custListModel.customerLevel isEqualToString:@"H"]) {
        _userLevel.backgroundColor = kHBackgroundColor;
    } else if ([custListModel.customerLevel isEqualToString:@"Z"]) {
        _userLevel.text = @"败";
        _userLevel.backgroundColor = kDefeatBackgroundColor;
    }
    
    if ([custListModel.customerType integerValue] == 2) {
        //订单客户
        _userLevel.font = [UIFont systemFontOfSize:18.0f];
        if ([custListModel.customerStatus integerValue] == 3) {
            _userLevel.text = @"订";
            _userLevel.backgroundColor =  kNavigationBackgroundColor;
            
            NSString *d = [NSDate stringWithDate:[NSDate dateWithString:custListModel.underOrderTime format:@"yyyy-MM-dd HH:mm:ss"] format:@"yyyy-MM-dd"];
            _lastTime.text = [NSString stringWithFormat:@"下订时间：%@",d];
            
        } else if ([custListModel.customerStatus integerValue] == 4) {
            _userLevel.text = @"取";
            _userLevel.backgroundColor =  kGetBackgroundColor;
            
            NSString *d = [NSDate stringWithDate:[NSDate dateWithString:custListModel.cannelTime format:@"yyyy-MM-dd HH:mm:ss"] format:@"yyyy-MM-dd"];
            _lastTime.text = [NSString stringWithFormat:@"取消订单时间：%@",d];
        } else if ([custListModel.customerStatus integerValue] == 5) {
            _userLevel.text = @"交";
            _userLevel.backgroundColor =  kDeliveryBackgroundColor; 
            
            NSString *d = [NSDate stringWithDate:[NSDate dateWithString:custListModel.overTime format:@"yyyy-MM-dd HH:mm:ss"] format:@"yyyy-MM-dd"];
            _lastTime.text = [NSString stringWithFormat:@"交车时间：%@",d];
        }
    }
   
    if (custListModel.custType == CustListCustTypeDefault) {
        
        _addInfoButton.hidden = YES;
        _addInfoButton_w.constant = 0;
        _userState.hidden = NO;
        _lastTime.hidden = NO;
        _titleBGView.hidden = NO;
        
        
    } else if (custListModel.custType == CustListCustTypeOrder) {
    
        _addInfoButton.hidden = YES;
        _addInfoButton_w.constant = 0;
        _userState.hidden = NO;
        _lastTime.hidden = NO;
        _titleBGView.hidden = NO;
        
    } else if (custListModel.custType == CustListCustTypeImport) {
        
        _addInfoButton.hidden = NO;
        _addInfoButton_w.constant = 77;
        
        _userState.hidden = YES;
        _lastTime.hidden = YES;
        _titleBGView.hidden = YES;
        
        _userLevel.text = @"导";
        _userLevel.backgroundColor =  kCBackgroundColor;
        _carName.text = custListModel.customerPhone;
    }
    
    if (_userState.text.length > 0) {
        _titleBGView.hidden = NO;
    } else {
        _titleBGView.hidden = YES;
    }
}

@end