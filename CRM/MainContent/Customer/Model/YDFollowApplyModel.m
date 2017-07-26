//
//  YDFollowApplyModel.m
//  CRM
//
//  Created by ios on 16/10/21.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDFollowApplyModel.h"

@implementation YDFollowApplyModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"applyMembers"]) {
        if (value) {
            _applyMembers = [NSMutableArray arrayWithArray:value];
        }
    } else {
        [super setValue:value forKey:key];
    }
}

@end
