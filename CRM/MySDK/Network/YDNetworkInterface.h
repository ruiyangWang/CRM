//
//  YDNetworkInterface.h
//  YDCalculateTool
//
//  Created by YD_iOS on 2017/3/1.
//  Copyright © 2017年 ios. All rights reserved.
//
/*
 
 第一步：初始化服务器主机地址
 [[YDNetworkInterface shareInstance]setHost:@"http://192.168.8.118:8080"];

 
 */

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id result);
typedef void(^FailBlock)(id error);

@interface YDNetworkInterface : NSObject

+ (instancetype)shareInstance;

///设置服务器地址
- (void)setHost:(NSString *)host;

#pragma mark - ==============================================库存==============================================
/**
 *  根据输入的电话号码，获取客户信息接口
 *  参数需要 电话号码（customerPhone） 和 客流id（id）
 */
- (void)getCustInfoWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  上传deviceID
 *  参数需要 设备device Token （device）
 */
- (void)getRegisterIdWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  选择车系，获取车牌请求
 */
- (void)getCarBrandsSuccess:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  选择车型，获取车的配置信息
 *  参数需要 品牌ID（brandsId） 和 车型ID （carsId）
 */
- (void)getCarTypeWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  问题反馈接口
 *  参数需要 反馈信息（content）
 */
- (void)getAddQuestionWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  新增客户
 *  参考接口文档 http://192.168.8.115:8080/apidoc/web.do#/webInterfaceDetail/56d8ae37-6ba3-4bc4-8fe2-6fa7ca01901b/客户管理/a91fa8ce-791e-4e5f-9936-4fb8578c128e
 */
- (void)getAddCustomerWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  首页客流列表
 */
- (void)getCustFlowListSuccess:(SuccessBlock)success failure:(FailBlock)failure;


/**
 *  获取车型价格政策详情
 *  参数需要 价格政策ID（policyId） 和 车型ID（carTypeId）
 */
- (void)getPriceWithCarModel:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  报价详情查询
 *  参数需要 报价ID（id）
 */
- (void)getGetAppPriceWithCarModel:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  报价详情录入
 *  参数需要 参考接口文档（不完整） http://192.168.8.115:8080/apidoc/web.do#/webInterfaceDetail/cbee40a0-3217-4abe-89c6-a7cad5b91d30/报价管理/24308526-16c4-4fb3-8125-c7a6771451fb
 */
- (void)getSavePriceInfoWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  获取精品列表
 *  参数需要 品牌ID（brandsId）和 车系ID（carsId）
 */
- (void)getBoutiqueListWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  获取保险列表
 *  参数需要 品牌ID（brandsId）、 车型ID（carTypeId）和 裸车价（carSoldPrice）
 */
- (void)getInsureListWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  获取代办列表
 *  参数需要 品牌ID（brandsId） 和 排量（displacement）
 */
- (void)getAgentListWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  获取金融机构列表
 *  参数需要 品牌ID（brandId）
 */
- (void)getFinancialListWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  获取包牌售价
 *  参数需要 参考接口文档（不完整）http://192.168.8.115:8080/apidoc/web.do#/webInterfaceDetail/62ce537d-e256-450b-abc3-0a4f1a448d43/报价详情管理/6bc01aec-0677-4128-ab24-3d18e8c57d0a
 */
- (void)getStandardPriceWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure;

/**
 *  获取打印机列表
 */
- (void)getListPrinterServiceSuccess:(SuccessBlock)success failure:(FailBlock)failure;

#pragma mark - ==============================================潜客管理==============================================
/**
 获取车型接口
 @param dict 参数
 @param success
 @param failure
 @param isCache 是否需要缓存
 */
- (void)queryCarInfoWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure isCache:(BOOL)isCache;

@end
