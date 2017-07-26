//
//  YDQuoteAddCustomerController.h
//  CRM
//
//  Created by ios on 16/11/10.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDAddAndEditViewController.h"

@class YDPassengerModel,YDCustListModel;
@interface YDQuoteAddCustomerController : YDAddAndEditViewController

@property (nonatomic, strong) YDPassengerModel *passengerModel;

/**
 新建客户时，输入的号码是订单客户，把订单客户的基本信息带进来
 */
@property (nonatomic, strong) YDCustListModel *orderCustomerModel;


@end
