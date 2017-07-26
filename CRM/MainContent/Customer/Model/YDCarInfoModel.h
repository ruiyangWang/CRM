//
//  YDCarInfoModel.h
//  CRM
//
//  Created by ios on 16/8/29.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDBaseModel.h"

@interface YDCarInfoModel : YDBaseModel


@property (nonatomic, copy) NSString *attr;
@property (nonatomic, copy) NSString *brandsId;
@property (nonatomic, copy) NSString *brandsName;
@property (nonatomic, strong) NSString *carTypeId;
@property (nonatomic, copy) NSString *carTypeName;
@property (nonatomic, strong) NSString *carsId;
@property (nonatomic, copy) NSString *carsName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *carSortNo;

@end
