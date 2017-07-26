//
//  YDUserInfoFMDB.m
//  CRM
//
//  Created by ios on 16/10/13.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDUserInfoFMDB.h"
#import "YDFMDB.h"

#define kTableName   @"usetInfoTable"

@implementation YDUserInfoFMDB
SINGLE_IMPLEMENTATION(YDUserInfoFMDB)

- (instancetype)init
{
    if (self = [super init]) {
        BOOL result = [[YDFMDB intance] createTableWithTableName:kTableName keys:@[@"modelId", @"orgName", @"memberName", @"mobilePhone", @"headPic", @"brandsName",@"jobTitle"]];
        if (result) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    }
    return self;
}

- (void)insertOrUpdateUserInfo:(NSDictionary *)userInfo
{
    //插入新的信息
    BOOL result = [[YDFMDB intance] insertIntoTableName:kTableName Dict:userInfo];
    
    if (result) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
}

- (void)deleteUserInfoWithUserID:(NSString *)userID
{
    //BOOL result = [[YDFMDB intance] deleteWithTableName:kTableName where:@[@"modelId", @"=", userID]];

    BOOL result = [[YDFMDB intance] clearTable:kTableName];
    if (result) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

- (NSDictionary *)queryUserInfoWithUserID:(NSString *)userID
{
    NSArray *allArray = [[YDFMDB intance] queryWithTableName:kTableName keys:@[@"modelId", @"orgName", @"memberName", @"mobilePhone", @"headPic", @"brandsName",@"jobTitle"] where:@[@"modelId", @"=", userID]];
    if (allArray.count > 0) {
        return allArray.firstObject;
    } else {
        return nil;
    }
}
@end
