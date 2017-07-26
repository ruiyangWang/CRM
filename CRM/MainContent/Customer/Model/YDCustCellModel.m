//
//  YDCustCellModel.m
//  CRM
//
//  Created by ios on 16/7/26.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCustCellModel.h"

@implementation YDCustCellModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)cellModelWithDict:(NSDictionary *)dict
{
    YDCustCellModel *model = [[YDCustCellModel alloc] initWithDict:dict];
    model.isShowCell = YES;
    return model;
}
@end
