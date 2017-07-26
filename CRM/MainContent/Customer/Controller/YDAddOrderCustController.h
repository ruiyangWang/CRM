//
//  YDAddOrderCustController.h
//  CRM
//
//  Created by ios on 16/9/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDViewController.h"

@interface YDAddOrderCustController : YDViewController

@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *custmoerPhone;

/**
 *  是否是导入客户
 */
@property (nonatomic, assign) BOOL isImportCustomer;

@end
