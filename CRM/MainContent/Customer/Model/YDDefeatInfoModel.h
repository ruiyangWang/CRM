//
//  YDDefeatInfoModel.h
//  CRM
//
//  Created by ios on 16/8/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

/**
 *  客户撞单战败记录
 */
#import "YDBaseModel.h"

@interface YDDefeatInfoModel : YDBaseModel

@property (nonatomic, copy) NSString *applyMemberId;// f216ae1aa77b4168b35ae262a0ff772b,
@property (nonatomic, copy) NSString *applyMemberName;// 测试用户,
@property (nonatomic, copy) NSString *attr;;
@property (nonatomic, copy) NSString *corpId;;// 10000,
@property (nonatomic, copy) NSString *countBy;;// ,
@property (nonatomic, copy) NSString *createTime;// 2016-08-15 18//36//09,
@property (nonatomic, copy) NSString *createTimeString;// 2016-08-15 18//36//09,
@property (nonatomic, copy) NSString *customerId;// 1,
@property (nonatomic, copy) NSString *customerName;;// ,
@property (nonatomic, copy) NSString *customerPhone;// ,
@property (nonatomic, copy) NSString *modelId;// c0a80203568d1e2181568dc5cd700002,
@property (nonatomic, copy) NSString *memberId;// 5aedda72ba484bccb23d8eea0acfe159,
@property (nonatomic, copy) NSString *memberName;// 测试用户41,
@property (nonatomic, copy) NSString *modelsName;// ,
@property (nonatomic, copy) NSString *modifyTime;// 2016-08-17 17//39//32,
@property (nonatomic, copy) NSString *modifyTimeString;// 2016-08-17 17//39//32,
@property (nonatomic, copy) NSString *orgId;// 10000,
@property (nonatomic, copy) NSString *orgName;// ,
@property (nonatomic, copy) NSString *reason;// ,
@property (nonatomic, copy) NSString *result;// 销售经理将客户：曾斌分配给了销售顾问：测试用户,
@property (nonatomic, copy) NSString *searchKey;// ,
@property (nonatomic, strong) NSNumber *status;// 0,
@property (nonatomic, strong) NSNumber *type;// 0
@end
