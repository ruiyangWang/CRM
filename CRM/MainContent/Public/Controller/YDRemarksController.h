//
//  YDRemarksController.h
//  CRM
//
//  Created by ios on 16/10/9.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDViewController.h"

@interface YDRemarksController : YDViewController

@property (nonatomic, strong) void(^ChangeBlock)(NSString *str);

@property (nonatomic, copy) NSString *contentText;

@end
