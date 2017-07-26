//
//  YDAlertController.m
//  CRM
//
//  Created by YD_iOS on 16/8/25.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDAlertController.h"

@interface YDAlertController ()

@end

@implementation YDAlertController


+ (instancetype)showAlertWith:(nonnull UIViewController *)v title:(nullable NSString *)title message:(NSString *)message confirm:(void (^ __nullable)(UIAlertAction *action))confirm cancel:(void (^ __nullable)(UIAlertAction *action))cancel{

    return [YDAlertController showAlertWith:v title:title message:message button1:@"确定" button2:@"取消" confirm:confirm cancel:cancel];
}

+ (instancetype)showAlertWith:(nonnull UIViewController *)v title:(nullable NSString *)title message:(nullable NSString *)message  button1:(NSString *)b1 button2:(NSString *)b2 confirm:(void (^ __nullable)(UIAlertAction *action))confirm cancel:(void (^ __nullable)(UIAlertAction *action))cancel{
    
    YDAlertController *alertController = (YDAlertController *)[UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    if (confirm != nil) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:b1 style:(UIAlertActionStyleDefault) handler:confirm]];
    }
    
    
    if (cancel != nil) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:b2 style:(UIAlertActionStyleCancel) handler:cancel]];
    }
    
    [v presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}


@end
