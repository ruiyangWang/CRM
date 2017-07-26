//
//  UIAlertView+YDBlock.h
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

@interface UIAlertView (YDBlock)

- (void)showWithCompletion:(YDAlertCompletionBlock)completion;

@end
