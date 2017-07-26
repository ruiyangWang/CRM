//
//  YDQuoteModel.h
//  CRM
//
//  Created by ios on 16/11/10.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDBaseModel.h"

@interface YDQuoteModel : YDBaseModel

@property (nonatomic, strong) NSNumber *actualBidAmount; // 实际报价金额(界面上可以修改的)
@property (nonatomic, strong) NSNumber *agencyMoney; // 代办价格
@property (nonatomic, copy) NSString *attr; //
@property (nonatomic, copy) NSString *brandId; // 品牌ID
@property (nonatomic, copy) NSString *carTypeId; // 车型ID
@property (nonatomic, copy) NSString *carsId; // 车系ID
@property (nonatomic, copy) NSString *colorCode; // 颜色编码
@property (nonatomic, copy) NSString *corpId; // 企业ID
@property (nonatomic, copy) NSString *countBy; //
@property (nonatomic, copy) NSString *createTime; // 2016-11-04 15; //16; //02
@property (nonatomic, copy) NSString *createTimeString; // 2016-11-04 15; //16; //02
@property (nonatomic, copy) NSString *customerId; // 客户ID
@property (nonatomic, copy) NSString *detailId; // 报价详情ID
@property (nonatomic, strong) NSNumber *downPayment; // 首付金额
@property (nonatomic, strong) NSNumber *giftMoney; // 精品价格
@property (nonatomic, copy) NSString *modelId; // 报价ID
@property (nonatomic, strong) NSNumber *insurMoney; // 保险价格
@property (nonatomic, copy) NSString *listTimeString; // 16-11-04
@property (nonatomic, strong) NSNumber *loanAmount; // 贷款金额
@property (nonatomic, copy) NSString *memberId; // 所属销售顾问ID
@property (nonatomic, copy) NSString *modifyTime; // 2016-11-04 15; //16; //02
@property (nonatomic, copy) NSString *modifyTimeString; // 2016-11-04 15; //16; //02
@property (nonatomic, strong) NSNumber *monthPayment; // 月供金额
@property (nonatomic, copy) NSString *orgId; // 组织ID
@property (nonatomic, copy) NSString *passengerId; // 客流ID
@property (nonatomic, strong) NSNumber *periods; // 月供期数
@property (nonatomic, strong) NSNumber *purchaseTax; // 购置税
@property (nonatomic, copy) NSString *searchKey; //
@property (nonatomic, strong) NSNumber *totalBidAmount; // 总报价金额(界面上不能修改的) ------- CRM显示取该字段

@property (nonatomic, strong) NSNumber *carSoldPrice; //裸车价格
@property (nonatomic, copy) NSString *logoPath; // 车系LOGO
@property (nonatomic, copy) NSString *modelsName; // 车型名称

@end
