//
//  YDOrderInfoModel.h
//  CRM
//
//  Created by ios on 16/11/7.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDBaseModel.h"

@interface YDOrderInfoModel : YDBaseModel


@property (nonatomic, copy) NSString *attr;
@property (nonatomic, copy) NSString *corpId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, copy) NSString *modifyTime;
@property (nonatomic, copy) NSString *modifyTimeString;
@property (nonatomic, strong) NSNumber *orderNo;
@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSString *overTime;
@property (nonatomic, copy) NSString *overTimeString;
@property (nonatomic, copy) NSString *reason;


@end
