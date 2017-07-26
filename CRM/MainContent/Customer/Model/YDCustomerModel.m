//
//  YDCustomerModel.m
//  CRM
//
//  Created by ios on 16/8/23.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCustomerModel.h"


@implementation YDCustomerModel


- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"customerInfo"]) {
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            _customerInfo = [YDCustInfoModel instanceWithDict:value];
        }
        
    } else if ([key isEqualToString:@"intentionInfo"]) {
    
        if ([value isKindOfClass:[NSDictionary class]]) {
            _intentionInfo = [YDIntentionInfoModel instanceWithDict:value];
        }
        
    } else if ([key isEqualToString:@"list"]) {
        //_listArray = [NSMutableArray array];
        
#warning 客户的跟进信息使用单独的接口获取
//        for (NSDictionary *dic in value) {
//            YDFollowInfoModel *followInfoModel = [YDFollowInfoModel instanceWithDict:dic];
//            [_listArray addObject:followInfoModel];
//        }
        
    } else if ([key isEqualToString:@"listApply"]) {
        _listApplyArray = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            YDDefeatInfoModel *defeatInfoModel = [YDDefeatInfoModel instanceWithDict:dic];
            [_listArray addObject:defeatInfoModel];
        }

    } else if ([key isEqualToString:@"carRel"]) {
        _carRel = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            YDCarInfoModel *defeatInfoModel = [YDCarInfoModel instanceWithDict:dic];
            [_carRel addObject:defeatInfoModel];
        }
    } else {
        [super setValue:value forKey:key];
    }
}
@end
