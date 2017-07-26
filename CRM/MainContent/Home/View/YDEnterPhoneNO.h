//
//  YDEnterPhoneNO.h
//  CRM
//
//  Created by YD_iOS on 16/7/21.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDCustListModel.h"
#import "YDPassengerModel.h"

@interface YDEnterPhoneNO : UIView

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) void (^ClickNextButton) (NSString *pNO);
@property (nonatomic, strong) void (^ClickUserInfo) (YDCustListModel *cModel);
@property (nonatomic, copy) void (^InputPhoneBlock) (NSString *phone);

@property (nonatomic, strong) YDPassengerModel *pModel;//客流信息
@property (nonatomic, strong) YDCustListModel *cModel;//客户信息

- (void)showView;
- (void)hiddenView;

@end
