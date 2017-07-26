//
//  YDAddAndEditViewController.h
//  CRM
//
//  Created by ios on 2017/4/7.
//  Copyright © 2017年 YD_iOS. All rights reserved.
//

#import "YDViewController.h"

@interface YDAddAndEditViewController : YDViewController



/**
 发送短信功能
 @param phone 手机号集合，NSArray
 @param message 信息内容
 */
- (void)sendMessageWithPhone:(NSArray *)phone message:(NSString *)message;


@end
