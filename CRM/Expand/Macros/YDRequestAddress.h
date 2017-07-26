//
//  YDRequestAddress.h
//  CRM
//
//  Created by YD_iOS on 16/7/15.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#ifndef YDRequestAddress_h
#define YDRequestAddress_h


#endif /* YDRequestAddress_h */

/**
 *  曾斌服务器
 */
//#define kServerIP @"http://192.168.8.177"
//#define kServerAddress @"http://192.168.8.177/admin-webapp/service/func"

/**
 *  测试服务器（内网）
 */
#define kServerIP @"http://192.168.8.118:8080"
#define kServerAddress @"http://192.168.8.118:8080/admin-webapp/service/func"


/**
 *  服务器地址（外网）
 */
//#define kServerIP @"http://www.autoheader.com:8080"
//#define kServerAddress @"http://www.autoheader.com:8080/admin-webapp/service/func"

 
#define kUser kServerAddress

/**
 *  获取SID-OK
 */
//#define kSIDRequest @"http://192.168.8.177/admin-webapp/loginapi/token"
#define kSIDRequest @"http://www.autoheader.com:8080/admin-webapp/login/login/admin-webapp/loginapi/token"

/**
 *  获取验证码/登录
 */
#define kGetCodeAndLogin [NSString stringWithFormat:@"%@/admin-webapp/loginapi/appdevice/login",kServerIP]


/**
 获取登录的销售顾问信息    
 */
#define kGetMemberInfoAddress  [NSString stringWithFormat:@"%@/perms/AndroidMemberInfo?",kUser]

/**
 *  获取客流列表接口-OK
 */
#define kListPassenger [NSString stringWithFormat:@"%@/passenger/crmListPassenger?",kUser]

/**
 *  新增客流接口/修改客流接口-（修改为非意向OK）
 */
#define kAddPassenger [NSString stringWithFormat:@"%@/passenger/crmAddPassenger?",kUser]

/**
 *  查询客户详情、意向信息、跟进记录接口
 */
#define kCrmGetCustomerInfo [NSString stringWithFormat:@"%@/customer/CrmGetCustomerInfo?",kUser]

/**
 *  获取订单客户详情的接口
 */
#define kGetOrderCustmerDetailAddress [NSString stringWithFormat:@"%@/customer/crmFincCustomer?",kUser]

/**
 *  获取客流详情接口
 */
#define kFindPassenger [NSString stringWithFormat:@"%@/crmFindPassenger?",kUser]

/**
 *  更新客流状态接口
 */
#define kUpdateStatus [NSString stringWithFormat:@"%@/crmUpdateStatus?",kUser]

/**
 *  客户列表接口
 */
#define kCustomerListAddress [NSString stringWithFormat:@"%@/customer/crmListCustomer?",kUser]

/**
 *  直接新建客户接口
 */
#define kAddCustomerAddress [NSString stringWithFormat:@"%@/customer/crmAddCustomer?",kUser]

/**
 *  查询客户信息接口（手机号和ID查询）
 */
#define kGetCustomerInfoAddress [NSString stringWithFormat:@"%@/customer/CrmGetCustomerInfo?",kUser]

/**
 *  获取未读消息列表接口-OK
 */
#define kCrmGetNotifyMsg [NSString stringWithFormat:@"%@/notify/CrmGetNotifyMsg?",kUser]

/**
 *  标记未读消息为已读接口-OK
 */
#define kCrmModifyNotifyMsg [NSString stringWithFormat:@"%@/notify/CrmModifyNotifyMsg?",kUser]

/**
 *  查车
 */
#define kChooseBrands [NSString stringWithFormat:@"%@/carType/CrmQueryBrandsAndCars?",kUser]

/**
 *  新增跟进信息
 */
#define kCrmAddFollow [NSString stringWithFormat:@"%@/customer/crmAddFollow?",kUser]

/**
 *  待跟进信息
 */
#define kCrmListFollow [NSString stringWithFormat:@"%@/customer/crmListFollow?",kUser]

/**
 *  销售总览
 */
#define kCrmSalesOverview [NSString stringWithFormat:@"%@/report/crmSalesOverviewHome?",kUser]

/**
 *  撞单申请
 */
#define kCrmAppeal [NSString stringWithFormat:@"%@/appeal/CrmAppeal?",kUser]

/**
 *  获取离店短信
 */
#define kGetMessageAddress [NSString stringWithFormat:@"%@/customer/crmFindLeaveMsg?",kUser]

/**
 *  设置离店短信
 */
#define kSetMessageAddress [NSString stringWithFormat:@"%@/customer/crmAddLeaveMsg?",kUser]

/**
 *  获取意向客户等级
 */
#define kGetCustomerLevelAddress [NSString stringWithFormat:@"%@/customer/crmFindCustomerLevel?",kUser]

/**
 *  设置意向客户等级
 */
#define kSetCustomerLevelAddress [NSString stringWithFormat:@"%@/customer/crmAddCustomerLevel?",kUser]


/**
 *  新增/修改订单信息接口
 */
#define kCrmAddOrderInfo [NSString stringWithFormat:@"%@/customer/crmAddOrderInfo?",kUser]

/**
 *  撞单申诉接口
 */
#define kConfictAppealAddress [NSString stringWithFormat:@"%@/appeal/CrmAppeal?",kUser]

/**
 *  获取跟进记录列表
 */
#define kFollowListAddress [NSString stringWithFormat:@"%@/customer/crmListFollow?",kUser]

/**
 *  战败申诉地址
 */
#define kDefeatApplyAddress [NSString stringWithFormat:@"%@/defeat/CrmDefeat?",kUser]

/**
 *  获取报价列表
 */
#define kQuoteListAddress [NSString stringWithFormat:@"%@/quota/crmListQuote?",kUser]

/**
 获取报价详情
 */
#define kQuoteDetailAddress [NSString stringWithFormat:@"%@/admin-webapp/api/showPolicy/showApiPolicy?",kServerIP]


/**
 反馈接口
 */
#define kFeedbackAddress [NSString stringWithFormat:@"%@/feedback/CrmAddFeedback?",kUser]

/**
 反馈上传图片
 */
#define kAddImageAddress [NSString stringWithFormat:@"%@/feedback/crmFeedbackUpload?",kUser]

/**
 上传用户头像
 */
#define kUserIconAddress [NSString stringWithFormat:@"%@/perms/crmMemberUpload?",kUser]

/**
 切换组织接口
 */
#define kChangeOrgAddress [NSString stringWithFormat:@"%@/org/crmChangeOrg?", kUser]

/**
 获取版本号信息
 */
#define kGetVersionAddress [NSString stringWithFormat:@"%@/admin-webapp/version/getVersion?", kServerIP]

