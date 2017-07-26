//
//  YDBaseModel.m
//  CRM
//
//  Created by ios on 16/8/1.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDBaseModel.h"


@implementation YDBaseModel
+ (instancetype)instanceWithDict:(NSDictionary *)dict {
    return [dict isKindOfClass:[NSDictionary class]] ? [[self alloc] initWithDict:dict] : nil;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if ((self = [self init]))
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@缺少%@字段", NSStringFromClass([self class]),key);
}





@end
