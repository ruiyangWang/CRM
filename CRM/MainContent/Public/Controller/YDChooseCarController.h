//
//  YDChooseCarController.h
//  CRM
//
//  Created by ios on 2016/12/7.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDViewController.h"

@interface YDChooseCarController : YDViewController

@property (nonatomic, assign) BOOL isALL;

@property (nonatomic, strong) void (^SearchCarRowBlack) (NSString *brandsId, NSString *carsId, NSString *mId, NSString *name);

@end
