//
//  YDImportCustomerController.h
//  CRM
//
//  Created by ios on 16/8/1.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDTableViewController.h"


typedef NS_ENUM(NSInteger, ImportType) {
    ImportTypeDefult = 1,   //默认可以选择
    ImportTypeCustomer,     //导入意向客户，不可选择
    ImportTypeOrder         //导入订单客户，不可选择

};
@interface YDImportCustomerController : YDViewController

/**
 *  页面类型
 */
@property (nonatomic, assign) ImportType importType;


@end
