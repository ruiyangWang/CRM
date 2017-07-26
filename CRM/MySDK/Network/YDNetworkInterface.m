//
//  YDNetworkInterface.m
//  YDCalculateTool
//
//  Created by YD_iOS on 2017/3/1.
//  Copyright © 2017年 ios. All rights reserved.
//

#import "YDNetworkInterface.h"
#import "NIDataService.h"
#import "YDAddressHeader.h"
#import "XDataService.h"

@interface YDNetworkInterface()

//私有方法
//调用网络请求
- (void)requestWithURL:(NSString *)url Parameters:(NSDictionary *)parameters
               success:(SuccessBlock)success failure:(FailBlock)failure;

@end

@implementation YDNetworkInterface

static NSString *requestHostString = nil;
static YDNetworkInterface *_dataInterface = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataInterface = [[super allocWithZone:NULL]init];
    });
    return _dataInterface;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [YDNetworkInterface shareInstance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone{
    return [YDNetworkInterface shareInstance];
}

-(void)setHost:(NSString *)host{
    requestHostString = host;
}

- (void)requestWithURL:(NSString *)url
            Parameters:(NSDictionary *)parameters
               success:(SuccessBlock)success
               failure:(FailBlock)failure
{
    NSString *allURL = [NSString stringWithFormat:@"%@%@",requestHostString,url];
    [NIDataService POST:parameters url:allURL success:^(id response) {
        if (success != nil) {
            success(response);
        }
    } failure:^(id error) {
        if (failure != nil) {
            failure(error);
        }
    }];
}

- (void)POSTWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
            success:(SuccessBlock)success
            failure:(FailBlock)failure
            isCache:(BOOL)isCache
{
    NSString *allURL = [NSString stringWithFormat:@"%@%@",requestHostString,url];
    if (isCache) {
        [XDataService startPostCacheWithURL:allURL dict:parameters cBlock:^(id result) {
            if (success) {
                success(result);
            }
        } fBlock:^(id error) {
            if (failure) {
                failure(error);
            }
        }];
    } else {
        [XDataService startPostWithURL:allURL dict:parameters cBlock:^(id result) {
            if (success) {
                success(result);
            }
        } fBlock:^(id error) {
            if (failure) {
                failure(error);
            }
        }];
    }
    
}

#pragma make 接口实现

- (void)getCustInfoWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [mDict setValue:@"一定要传，不会检测" forKey:@"customerName"];
    [self requestWithURL:kSDKGetCustInfoRequest Parameters:mDict success:success failure:failure];
}

- (void)getRegisterIdWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [mDict setValue:@"QUOTED" forKey:@"app"];
    
    [self requestWithURL:kSDKGetRegisterId Parameters:mDict success:success failure:failure];
}

- (void)getCarBrandsSuccess:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKGetCarBrandsRequest Parameters:@{} success:success failure:failure];
}

- (void)getCarTypeWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKGetCarTypeRequest Parameters:dict success:success failure:failure];
}

- (void)getAddQuestionWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKGetAddQuestionRequest Parameters:dict success:success failure:failure];
}

- (void)getAddCustomerWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKGetAddCustomerRequest Parameters:dict success:success failure:failure];
}


/**
 *  首页客流列表
 */
- (void)getCustFlowListSuccess:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKCustFlowListRequest Parameters:@{} success:success failure:failure];
}

/**
 *  获取车型价格政策详情
 *  参数需要
 */
- (void)getPriceWithCarModel:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKGetPriceWithCarModel Parameters:dict success:success failure:failure];
}

/**
 *  报价详情查询
 *  参数需要
 */
- (void)getGetAppPriceWithCarModel:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKGetAppPriceWithCarModel Parameters:dict success:success failure:failure];
}

/**
 *  报价详情录入
 *  参数需要
 */
- (void)getSavePriceInfoWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKSavePriceInfo Parameters:dict success:success failure:failure];
}

/**
 *  获取精品列表
 *  参数需要
 */
- (void)getBoutiqueListWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKGetBoutiqueList Parameters:dict success:success failure:failure];
}

/**
 *  获取保险列表
 *  参数需要
 */
- (void)getInsureListWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKGetInsureList Parameters:dict success:success failure:failure];
}

/**
 *  获取代办列表
 *  参数需要
 */
- (void)getAgentListWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKGetAgentList Parameters:dict success:success failure:failure];
}

/**
 *  获取金融机构列表
 *  参数需要 brandId
 */
- (void)getFinancialListWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKGetFinancialList Parameters:dict success:success failure:failure];
}

/**
 *  获取包牌售价
 *  参数需要
 */
- (void)getStandardPriceWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure{
    
    [self requestWithURL:kSDKApiGetStandardPrice Parameters:dict success:success failure:failure];
}

/**
 *  获取打印机列表
 *  参数需要
 */
- (void)getListPrinterServiceSuccess:(SuccessBlock)success failure:(FailBlock)failure{

    [self requestWithURL:kSDKListPrinterService Parameters:@{} success:success failure:failure];
}


#pragma mark - ==============================================潜客管理==============================================
/**
 获取车型接口
 @param dict 参数
 @param success
 @param failure
 @param isCache 是否需要缓存
 */
- (void)queryCarInfoWithParameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailBlock)failure isCache:(BOOL)isCache
{
    [self POSTWithURL:kSDKChooseBrands parameters:dict success:success failure:failure isCache:isCache];
}






@end
