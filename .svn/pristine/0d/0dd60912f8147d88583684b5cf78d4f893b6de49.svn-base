//
//  UIViewController+YDIntercepter.m
//  CRM
//
//  Created by YD_iOS on 16/8/29.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "UIViewController+YDIntercepter.h"
#import <objc/runtime.h>

@implementation UIViewController (YDIntercepter)

+ (void)load {
    SEL selectors[] = {
        @selector(viewWillAppear:),
        @selector(viewWillDisappear:)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"yd_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)yd_viewWillAppear:(BOOL)animated {
    if ([self isNeedFilter]) return ;
    
//    [MobClick beginLogPageView:[self viewDescription]];
    NSLog(@"----进入----%@",[self viewDescription]);
    
    [self yd_viewWillAppear:animated];
}

- (void)yd_viewWillDisappear:(BOOL)animated {
    if ([self isNeedFilter]) return ;
    
    NSLog(@"----离开----%@",[self viewDescription]);

//    [MobClick endLogPageView:[self viewDescription]];
    
    [self yd_viewWillDisappear:animated];
}

- (NSString *)viewDescription {
    NSString *description = self.title;
    
    if (description.length == 0) {
        description = [self description];
    }
    
    if (description.length == 0) {
        description = NSStringFromClass([self class]);
    }
    
    return description;
}

- (BOOL)isNeedFilter {
    if ([self isMemberOfClass:[UITabBarController class]]) {
        return YES;
    } else if ([self isMemberOfClass:[UINavigationController class]]) {
        return YES;
    }
    
    return NO;
}


@end
