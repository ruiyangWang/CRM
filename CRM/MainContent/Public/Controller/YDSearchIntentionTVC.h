//
//  YDSearchIntentionTVC.h
//  CRM
//
//  Created by YD_iOS on 16/8/1.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//  选择意向级别页面 客户级别

#import <UIKit/UIKit.h>

@interface YDSearchIntentionTVC : UITableViewController

@property (nonatomic, strong) void (^ClickCellBlack) (NSString *str);

@property (nonatomic, assign) BOOL showLow;

@end
