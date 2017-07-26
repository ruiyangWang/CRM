//
//  YDIntentionCustomerFMDB.m
//  CRM
//
//  Created by ios on 16/9/29.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDIntentionCustomerFMDB.h"
#import "YDImportCustModel.h"
#import "NSDictionary+Object.h"
#import "YDFMDB.h"

#define tableName @"importIntentionCustomer"

@implementation YDIntentionCustomerFMDB
SINGLE_IMPLEMENTATION(YDIntentionCustomerFMDB)

- (instancetype)init
{
    if (self = [super init]) {
        BOOL result =[[YDFMDB intance] createTableWithTableName:tableName keys:@[@"userId", @"name", @"phone", @"isSelected"]];
        if (result) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    }
    return self;
}

- (void)insertIntenCustomer:(YDImportCustModel *)importCustModel
{
    NSDictionary *dic = [NSDictionary getObjectData:importCustModel];
    BOOL result = [[YDFMDB intance] insertIntoTableName:tableName Dict:dic];//插入语句
    if (result) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
}

- (void)updateCustomer:(YDImportCustModel *)importCustModel
{
    NSDictionary *dic = [NSDictionary getObjectData:importCustModel];

    BOOL result = [[YDFMDB intance] updateWithTableName:tableName valueDict:dic where:nil];//更新语句
    if (result) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败");
    }
}

- (void)deleteCustomer:(YDImportCustModel *)importCustModel
{

    BOOL result = [[YDFMDB intance] deleteWithTableName:tableName where:@[@"userId", @"=", importCustModel.userId,
                                                                          @"name", @"=", importCustModel.name,
                                                                          @"phone", @"=", importCustModel.phone]];//删除语句
    if (result) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

- (NSArray *)queryAllImporeIntentionCustomerWithUserId:(NSString *)userId
{
    NSMutableArray *allCustArray = [NSMutableArray array];
    NSArray* arr = [[YDFMDB intance] queryWithTableName:tableName];//查询语句
    for (NSDictionary *dic in arr) {
        YDImportCustModel *importModel = [YDImportCustModel instanceWithDict:dic];
        if ([importModel.userId isEqualToString:userId]) {
            [allCustArray addObject:importModel];
        }
    }
    return allCustArray;
}
@end
