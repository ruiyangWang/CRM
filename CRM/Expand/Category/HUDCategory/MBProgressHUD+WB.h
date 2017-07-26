//
//  MBProgressHUD+WB.h
//  YDCalculateTool
//
//  Created by ios on 16/6/30.
//  Copyright © 2016年 ios. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (WB)

/**
 *  无网络提示，2秒后消失
 */
+ (instancetype)showNotNetworkingHUDToView:(UIView *)view;

/**
 *  状态提示，不会自动消失，虚手动
 */
+ (instancetype)showStatus:(NSString *)statusString toView:(UIView *)view;

/**
 *  显示提示信息，2秒后消失
 */
+ (instancetype)showTips:(NSString *)tipsString toView:(UIView *)view;

/**
 *  显示错误带图提示，2秒后消失
 */
+ (instancetype)showInputErrorTips:(NSString *)tipsString toView:(UIView *)view;

/**
 *  显示成功带图提示，2秒后消失
 */
+ (instancetype)showSuccessTips:(NSString *)tipsString toView:(UIView *)view;

/**
 *  显示HUD 需手动取消
 */
+ (instancetype)showLoadingMessage:(NSString *)message toView:(UIView *)view;

/**
 *  判断当前view是否在转圈
 */
- (BOOL)isShowForView:(UIView *)view;

@end
