//
//  UIActionSheet+YDBlock.h
//  CRM
//
//  Created by YD_iOS on 16/7/15.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @brief	弹出框完成回调
 
 @param buttonIndex 点击按钮的索引
 */
typedef void(^YDAlertCompletionBlock)(NSUInteger buttonIndex);

@interface UIActionSheet (YDBlock)<UIActionSheetDelegate>

- (void)showInView:(UIView *)view withCompletion:(YDAlertCompletionBlock)completion;

- (void)showFromToolbar:(UIToolbar *)view withCompletion:(YDAlertCompletionBlock)completion;

- (void)showFromTabBar:(UITabBar *)view withCompletion:(YDAlertCompletionBlock)completion;

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated withCompletion:(YDAlertCompletionBlock)completion;

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated withCompletion:(YDAlertCompletionBlock)completion;

@end
