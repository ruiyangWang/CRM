//
//  YDCustInfoModel.h
//  CRM
//
//  Created by ios on 16/8/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//


/**
 *  客户基本信息
 */
#import "YDBaseModel.h"

@interface YDCustInfoModel : YDBaseModel

@property (nonatomic, copy) NSString *address;// ---------》地址
@property (nonatomic, copy) NSString *attr;//"attr": "",
@property (nonatomic, copy) NSString *birthday;//"birthday": null, -----------》出生日期
@property (nonatomic, copy) NSString *birthdayString;//"birthdayString": "",
@property (nonatomic, copy) NSString *brandName;// -----》品牌名称
@property (nonatomic, copy) NSString *carTypeName;// ----》车型名称
@property (nonatomic, copy) NSString *carsName;// ---------车系名称
@property (nonatomic, copy) NSString *corpId;// "10000",
@property (nonatomic, copy) NSString *countBy;
@property (nonatomic, copy) NSString *createTime;// "2016-08-12 19:23:27",
@property (nonatomic, copy) NSString *createTimeString;// "2016-08-12 19:23:27",
@property (nonatomic, copy) NSString *customerLevel;// -----------客户意向等级
@property (nonatomic, copy) NSString *customerName;//": "曾斌", -----------客户名称
@property (nonatomic, copy) NSString *customerPhone;//"13256765413", -------客户手机号码
@property (nonatomic, strong) NSNumber *customerStatus;// 2, ----------客户状态: 1潜客客户; 2战败客户(1,2为意向客户状态); 3下订; 4取消订单; 5提车(3,4,5为订单客户状态)
@property (nonatomic, strong) NSNumber *customerType;//: 0, -----------客户类型: 1意向客户; 2订单客户;
@property (nonatomic, strong) NSNumber *familyStatus;//: 0,-----------家庭状况1单身; 2已婚; 3已育;
@property (nonatomic, strong) NSNumber *flag;//: 0, ---------
@property (nonatomic, strong) NSNumber *gender;// 0,---------0 表示男  1表示女
@property (nonatomic, copy) NSString *modelId;//"1",
@property (nonatomic, copy) NSString *idNumber;;//-------------身份证号码
@property (nonatomic, assign) BOOL isDrive;//: 1,----------是否开车: 0否; 1是;
@property (nonatomic, copy) NSString *memberId;//: "5aedda72ba484bccb23d8eea0acfe159",
@property (nonatomic, copy) NSString *memberName;//: "测试用户", --------所属销售顾问名称
@property (nonatomic, copy) NSString *modifyTime;//: "2016-08-17 17:39:32",
@property (nonatomic, copy) NSString *modifyTimeString;//: "2016-08-17 17:39:32",
@property (nonatomic, copy) NSString *orgId;// "10000",
@property (nonatomic, copy) NSString *orgName;//: "默认企业",
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *searchKey;
@property (nonatomic, copy) NSString *weixin;

@end
