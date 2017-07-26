//
//  UITextField+XZAdjust.m
//  UITextField
//
//  Created by YD_iOS on 16/9/28.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "UITextField+XZAdjust.h"

@implementation UITextField (XZAdjust)

- (void)setAutoAdjust:(BOOL)autoAdjust{
    if (autoAdjust) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    if (self.isFirstResponder) {
        CGPoint relativePoint = [self convertPoint: CGPointZero toView: [UIApplication sharedApplication].keyWindow];
        
        CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
        CGFloat actualHeight = CGRectGetHeight(self.frame) + relativePoint.y + keyboardHeight;
        CGFloat overstep = actualHeight - CGRectGetHeight([UIScreen mainScreen].bounds) + 5;
        if (overstep > 0) {
            CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            CGRect frame = [UIScreen mainScreen].bounds;
            frame.origin.y -= overstep;
            [UIView animateWithDuration: duration delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
                [UIApplication sharedApplication].keyWindow.frame = frame;
            } completion: nil];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    if (self.isFirstResponder) {
        CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect frame = [UIScreen mainScreen].bounds;
        [UIView animateWithDuration: duration delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
            [UIApplication sharedApplication].keyWindow.frame = frame;
        } completion: nil];
    }
}

//如果项目中存在自定义的UITextField子类，那么上面代码中的dealloc你应该使用method_swillzing来实现释放通知的作用
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
