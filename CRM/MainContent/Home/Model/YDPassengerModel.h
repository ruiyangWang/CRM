//
//  YDPassengerModel.h
//  CRM
//
//  Created by YD_iOS on 16/8/18.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDCustListModel.h"

@interface YDPassengerModel : NSObject

- (instancetype)initWithDic:(NSDictionary *)dic;

@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *quoteId;//报价id
@property (nonatomic, copy) NSString *memberName;//用户名称
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, assign) NSInteger count;//到店人数
@property (nonatomic, assign) BOOL hasQuote;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *customerPhone;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, assign) BOOL isDrive; //是否开车
@property (nonatomic, assign) BOOL isInten; //是否意向客户
@property (nonatomic, strong) NSMutableArray *carRelArray; //汽车

@end