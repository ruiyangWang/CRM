//
//  YDUserInfoFMDB.h
//  CRM
//
//  Created by ios on 16/10/13.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDUserInfoFMDB : NSObject

SINGLE_INTERFACE(YDUserInfoFMDB)

- (void)insertOrUpdateUserInfo:(NSDictionary *)userInfo;

- (void)deleteUserInfoWithUserID:(NSString *)userID;

- (NSDictionary *)queryUserInfoWithUserID:(NSString *)userID;
@end
