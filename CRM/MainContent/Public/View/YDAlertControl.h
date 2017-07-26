//
//  YDAlertControl.h
//  CRM
//
//  Created by YD_iOS on 16/7/15.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//  Alert 和 ActionSheet 视图 ，兼容8.0前后

#import <Foundation/Foundation.h>

/**
 @brief	弹出框完成回调
 
 @param buttonIndex 点击按钮的索引
 */
typedef void(^YDAlertCompletionBlock)(NSUInteger buttonIndex);

@interface YDAlertControl : NSObject

+ (BOOL)alertControlIsDisplaying;

/**
 @brief	ButtonIndex顺序：Cancel:0, OtherButtons:1、2、3....
 如果没有Cancel，则OtherButtons:0、1、2....
 8.0以下OtherButtons限定不超过五个
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                completion:(YDAlertCompletionBlock)completion
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSString *)otherButtonTitles, ...;

/**
 @brief	ButtonIndex顺序：Cancel:0, Destructive:1，OtherButtons:2、3、4....
 如果没有Cancel，则Destructive:0，OtherButtons:1、2、3....
 如果没有Destructive，则Cancel:0，OtherButtons:1、2、3....
 如果没有Cancel和Destructive，则OtherButtons:0、1、2....
 */
+ (void)showActionSheetWithTitle:(NSString *)title
                      completion:(YDAlertCompletionBlock)completion
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
