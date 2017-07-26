//
//  YDUIUtil.m
//  CRM
//
//  Created by YD_iOS on 16/7/15.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDUIUtil.h"

@implementation YDUIUtil

+ (UIWindow *)topWindow {
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = (!window.hidden && window.alpha > 0);
        BOOL windowLevelNormal = (window.windowLevel == UIWindowLevelNormal);
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            topWindow = window;
            break;
        }
    }
    
    return topWindow;
}

+ (UIViewController *)topViewController {
    UIWindow *topWindow = [YDUIUtil topWindow];
    UIViewController *topVC = topWindow.rootViewController;
    
    while (topVC.presentedViewController != nil) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

+ (UIView *)topView {
    return [YDUIUtil topViewController].view;
}

@end
