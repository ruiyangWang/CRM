//
//  YDUpdateFollowupVC.h
//  CRM
//
//  Created by YD_iOS on 16/7/25.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//  补充本次跟进

#import <UIKit/UIKit.h>
#import "YDViewController.h"
#import "YDCustListModel.h"

@interface YDUpdateFollowupVC : YDViewController

@property (nonatomic, strong) YDCustListModel *cModel;

@property (nonatomic, assign) BOOL canSetLow;

@property (nonatomic, strong) NSNumber *followType;

@property (nonatomic, copy) NSString *passengerId;

@end
