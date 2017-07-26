//
//  UIAlertView+YDBlock.m
//  CRM
//
//  Created by YD_iOS on 16/7/15.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "UIAlertView+YDBlock.h"
#import <objc/runtime.h>

const char oldDelegateKey;
const char completionKey;

@implementation UIAlertView (YDBlock)

- (void)showWithCompletion:(YDAlertCompletionBlock)completion
{
    if (completion != nil)
    {
        objc_setAssociatedObject(self, &oldDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        
        self.delegate = self;
        objc_setAssociatedObject(self, &completionKey, completion, OBJC_ASSOCIATION_COPY);
    }
    
    [self show];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    YDAlertCompletionBlock completion = objc_getAssociatedObject(self, &completionKey);
    if(completion == nil) return;
    
    completion(buttonIndex);
    
    __weak id oldDelegate = objc_getAssociatedObject(self, &oldDelegateKey);
    if (oldDelegate != nil)
    {
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.delegate = oldDelegate;
        });
    }
}

@end
