//
//  YDAlertController.h
//  CRM
//
//  Created by YD_iOS on 16/8/25.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//  alert快速使用

#import <UIKit/UIKit.h>

@interface YDAlertController : UIAlertController

+ (instancetype)showAlertWith:(nonnull UIViewController *)v title:(nullable NSString *)title message:(nullable NSString *)message confirm:(void (^ __nullable)(UIAlertAction *action))confirm cancel:(void (^ __nullable)(UIAlertAction *action))cancel;

+ (instancetype)showAlertWith:(nonnull UIViewController *)v title:(nullable NSString *)title message:(nullable NSString *)message  button1:(NSString *)b1 button2:(NSString *)b2 confirm:(void (^ __nullable)(UIAlertAction *action))confirm cancel:(void (^ __nullable)(UIAlertAction *action))cancel;


@end
