//
//  YDCancelOrderVC.h
//  CRM
//
//  Created by YD_iOS on 16/8/29.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//  取消订单页面

#import "YDViewController.h"
#import "YDCustListModel.h"

@interface YDCancelOrderVC : YDViewController

/**
 *  是否返回根控制器（订单客户列表新建订单客户选择YES）
 */
@property (nonatomic, assign) BOOL isBackRootVC;

@property (nonatomic, strong) YDCustListModel *cModel;

@end
