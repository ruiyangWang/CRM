//
//  YDFollowTimeSortModel.h
//  CRM
//
//  Created by ios on 16/10/21.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDBaseModel.h"

typedef NS_ENUM(NSInteger, FollowType) {
    FollowTypeDefault,   //手动添加跟进产生的跟进记录
    FollowTypeApply,     //战败申请、撞单申请产生的跟进记录
    FollowTypeArchives   //客户信息修改产生的档案记录
};

@interface YDFollowTimeSortModel : YDBaseModel

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) FollowType followType;

@property (nonatomic, strong) id followModel;

@end
