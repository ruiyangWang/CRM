//
//  UIActionSheet+YDBlock.m
//  CRM
//
//  Created by YD_iOS on 16/7/15.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "UIActionSheet+YDBlock.h"
#import <objc/runtime.h>

const char actionSheetOldDelegateKey;
const char actionSheetCompletionKey;

@implementation UIActionSheet (YDBlock)

- (void)configCompletion:(YDAlertCompletionBlock)completion
{
    if(completion != nil)
    {
        objc_setAssociatedObject(self, &actionSheetOldDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        
        self.delegate = self;
        objc_setAssociatedObject(self, &actionSheetCompletionKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)showInView:(UIView *)view withCompletion:(YDAlertCompletionBlock)completion
{
    [self configCompletion:completion];
    [self showInView:view];
}

- (void)showFromToolbar:(UIToolbar *)view withCompletion:(YDAlertCompletionBlock)completion
{
    [self configCompletion:completion];
    [self showFromToolbar:view];
}

- (void)showFromTabBar:(UITabBar *)view withCompletion:(YDAlertCompletionBlock)completion
{
    [self configCompletion:completion];
    [self showFromTabBar:view];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated withCompletion:(YDAlertCompletionBlock)completion
{
    [self configCompletion:completion];
    [self showFromRect:rect inView:view animated:animated];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated withCompletion:(YDAlertCompletionBlock)completion
{
    [self configCompletion:completion];
    [self showFromBarButtonItem:item animated:animated];
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    YDAlertCompletionBlock completion = objc_getAssociatedObject(self, &actionSheetCompletionKey);
    if(completion == nil) return;
    
    completion(buttonIndex);
    
    __weak id oldDelegate = objc_getAssociatedObject(self, &actionSheetOldDelegateKey);
    if (oldDelegate != nil)
    {
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.delegate = oldDelegate;
        });
    }
}


@end
