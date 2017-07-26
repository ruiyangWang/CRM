//
//  YDRequestManaget.h
//  CRM
//
//  Created by ios on 2016/12/28.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//  用来封装一些能共用的请求方法

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id result);
typedef void(^FailedBlock)(id error);

@interface YDRequestManaget : NSObject


/**
 获取逾期未跟进客户列表
 */
- (void)getOverdueCustomerSuccessBlock:(SuccessBlock)result failedBlock:(FailedBlock)error;


@end
