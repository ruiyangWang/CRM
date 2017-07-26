//
//  YDAlertControl.m
//  CRM
//
//  Created by YD_iOS on 16/7/15.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDAlertControl.h"
#import "YDUIUtil.h"
#import "UIAlertView+YDBlock.h"
#import "UIActionSheet+YDBlock.h"

#define isIOS8 [[[UIDevice currentDevice] systemVersion] intValue] >= 8

static __weak id _alertControl = nil;

typedef NS_ENUM(NSUInteger, YDAlertActionStyle) {
    YDAlertActionStyleAlert,
    YDAlertActionStyleActionSheet
};

@implementation YDAlertControl

+ (BOOL)alertControlIsDisplaying {
    return (_alertControl != nil);
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                completion:(YDAlertCompletionBlock)completion
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    NSMutableArray *otherButtonTitleArray = [NSMutableArray array];
    va_list arguments;
    id otherButtonTitle;
    if (otherButtonTitles) {
        [otherButtonTitleArray addObject:otherButtonTitles];
        
        va_start(arguments, otherButtonTitles);
        while ((otherButtonTitle = va_arg(arguments, id))) {
            [otherButtonTitleArray addObject:otherButtonTitle];
        }
        va_end(arguments);
    }
    
    [self showWithStyle:YDAlertActionStyleAlert Title:title message:message completion:completion cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitleArray];
}

+ (void)showActionSheetWithTitle:(NSString *)title
                      completion:(YDAlertCompletionBlock)completion
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    NSMutableArray *otherButtonTitleArray = [NSMutableArray array];
    va_list arguments;
    id otherButtonTitle;
    if (otherButtonTitles) {
        [otherButtonTitleArray addObject:otherButtonTitles];
        
        va_start(arguments, otherButtonTitles);
        while ((otherButtonTitle = va_arg(arguments, id))) {
            [otherButtonTitleArray addObject:otherButtonTitle];
        }
        va_end(arguments);
    }
    
    [self showWithStyle:YDAlertActionStyleActionSheet Title:title message:nil completion:completion cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitleArray];
}

+ (void)showWithStyle:(YDAlertActionStyle)style
                Title:(NSString *)title
              message:(NSString *)message
           completion:(YDAlertCompletionBlock)completion
    cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles {
    
    
    if (isIOS8) {
        UIAlertControllerStyle preferredStyle = UIAlertControllerStyleActionSheet;
        if (style == YDAlertActionStyleAlert)
            preferredStyle = UIAlertControllerStyleAlert;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        
        __weak UIAlertController *weakAlertController = alertController;
        void(^actionHandler)(UIAlertAction *action) = ^(UIAlertAction *action) {
            if (completion) {
                completion([weakAlertController.actions indexOfObject:action]);
            }
        };
        
        if (cancelButtonTitle != nil) {
            [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:actionHandler]];
        }
        
        if (destructiveButtonTitle != nil) {
            [alertController addAction:[UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:actionHandler]];
        }
        
        for (NSString *otherButtonTitle in otherButtonTitles) {
            [alertController addAction:[UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:actionHandler]];
        }
        
        [[YDUIUtil topViewController] presentViewController:alertController animated:YES completion:nil];
        
        _alertControl = alertController;
    } else {
        if (style == YDAlertActionStyleAlert) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
            for (NSString *otherButtonTitle in otherButtonTitles) {
                [alertView addButtonWithTitle:otherButtonTitle];
            }
            [alertView showWithCompletion:completion];
            
            _alertControl = alertView;
        } else {
            NSString *title1 = nil;
            NSString *title2 = nil;
            NSString *title3 = nil;
            NSString *title4 = nil;
            NSString *title5 = nil;
            
            if (otherButtonTitles.count > 0)
                title1 = otherButtonTitles[0];
            
            if (otherButtonTitles.count > 1)
                title2 = otherButtonTitles[1];
            
            if (otherButtonTitles.count > 2)
                title3 = otherButtonTitles[2];
            
            if (otherButtonTitles.count > 3)
                title4 = otherButtonTitles[3];
            
            if (otherButtonTitles.count > 4)
                title5 = otherButtonTitles[4];
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:title1, title2, title3, title4, title5, nil];
            
            WEAK_OBJECT(actionSheet);
            [actionSheet showInView:[YDUIUtil topWindow] withCompletion:^(NSUInteger buttonIndex) {
                NSUInteger convertdButtonIndex = buttonIndex;
                
                // Cancel Button
                if (buttonIndex == [weak_actionSheet cancelButtonIndex]) {
                    convertdButtonIndex = 0;
                }
                // Destructive Button
                else if (buttonIndex == [weak_actionSheet destructiveButtonIndex]) {
                    if ([weak_actionSheet cancelButtonIndex] == -1)
                    {
                        convertdButtonIndex = 0;
                    }
                    else
                    {
                        convertdButtonIndex = 1;
                    }
                }
                // Other Button
                else  {
                    if ([weak_actionSheet cancelButtonIndex] != -1)
                    {
                        convertdButtonIndex = buttonIndex + 1;
                    }
                }
                
                if (completion)
                    completion(convertdButtonIndex);
            }];
            
            _alertControl = actionSheet;
        }
    }
}


@end
