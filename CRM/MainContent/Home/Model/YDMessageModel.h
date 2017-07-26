//
//  YDMessageModel.h
//  CRM
//
//  Created by YD_iOS on 16/7/13.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDBaseModel.h"

@interface YDMessageModel : YDBaseModel

@property (nonatomic, copy) NSString *action;// = ADD;
@property (nonatomic, copy) NSString *content;// =
@property (nonatomic, copy) NSString *corpId;// = 90000;
@property (nonatomic, copy) NSString *createdAt;// = "2016-11-26 12:00:54";
@property (nonatomic, copy) NSString *createdAtBegin;// = "";
@property (nonatomic, copy) NSString *createdAtEnd;// = "";
@property (nonatomic, copy) NSString *createdAtString;// = "2016-11-26 12:00:54";
@property (nonatomic, copy) NSString *modelId;// = c0a80869589e110d81589ecb027000b0;
@property (nonatomic, copy) NSString *sender;// = system;
@property (nonatomic, copy) NSString *senderOrgId;// = "";
@property (nonatomic, copy) NSString *senderOrgName;// = "";
@property (nonatomic, copy) NSString *target;// = c0a808b1589018758158905552790046;
@property (nonatomic, copy) NSString *targetType;// = DEFEAT;
@property (nonatomic, strong) NSNumber *type;// = 4;
@property (nonatomic, assign) BOOL isRead;
@end