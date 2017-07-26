//
//  YDPassengerModel.m
//  CRM
//
//  Created by YD_iOS on 16/8/18.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDPassengerModel.h"
#import "YDCarInfoModel.h"

@implementation YDPassengerModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        _modelId = [dic objectForKey:@"modelId"];
        _memberId = [dic objectForKey:@"memberId"];
        _quoteId = [dic objectForKey:@"quoteId"];
        _memberName = [dic objectForKey:@"memberName"];
        _createTime = [dic objectForKey:@"createTime"];
        _createDate = [NSDate dateWithString:_createTime format:@"yyyy-MM-dd HH:mm:ss"];
        _count = [[dic objectForKey:@"count"] integerValue];
        _hasQuote = [[dic objectForKey:@"hasQuote"] integerValue];
        _customerId = [dic objectForKey:@"customerId"];
        _customerName = [dic objectForKey:@"customerName"];
        _customerPhone = [dic objectForKey:@"customerPhone"];
        _isInten = [[dic objectForKey:@"isInten"] boolValue];
        _isDrive = [[dic objectForKey:@"isDrive"] integerValue] == 1 ? 1 : 0; //如果是1代表是，2代表否，赋值0
        
        _carRelArray = [NSMutableArray array];
        NSArray *carRel = [dic objectForKey:@"carRel"];
        for (NSDictionary *carDic in carRel) {
            YDCarInfoModel *carModel = [YDCarInfoModel instanceWithDict:carDic];
            [_carRelArray addObject:carModel];
        }
    }
    
    return self;
}

@end
