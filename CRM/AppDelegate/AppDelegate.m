//
//  AppDelegate.m
//  CRM
//
//  Created by YD_iOS on 16/7/14.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "AppDelegate.h"
#import "YDMainTabBarController.h"
#import "AppDelegate+Push.h"
#import "AppDelegate+NIM.h"
#import "AppDelegate+Log.h"

#import "NTESDemoConfig.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESCellLayoutConfig.h"

// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "CatchCrash.h"

@interface AppDelegate ()

@property (nonatomic, assign) BOOL isUserJPUSH;//标记是否使用激光推送

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [self registNIM];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    if (getNSUser(@"youdao.CRM_SID") != nil) {
        self.window.rootViewController = [[YDMainTabBarController alloc]init];
    }
    
    _isUserJPUSH = YES;
    
    if (_isUserJPUSH) {
        [self registJPushRemoteNotificationWithOptions:launchOptions];
    }else{
        //系统自带推送 注册远程推送
        [self registRemoteNotification];
    }
    
    //注册消息处理函数的处理方法
    //如此一来，程序崩溃时会自动进入CatchCrash.m的uncaughtExceptionHandler()方法
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [self uploadLog];
    
    return YES;
}


#pragma mark ***************************** AppDelegate lift cycle *****************************

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ***************************** Push Setting *****************************

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    [application registerForRemoteNotifications];
}

//会接收来自苹果服务器给你返回的deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    if (_isUserJPUSH) {
        [JPUSHService registerDeviceToken:deviceToken];
    }else{
        
        NSLog(@"device token is %@",deviceToken);
        
        NSString *token=[NSString stringWithFormat:@"%@",deviceToken];
        token=[token stringByReplacingOccurrencesOfString:@"<" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@">" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSLog(@"device token is %@",token);
    }
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Regist fail%@",error);
}

//收到本地推送消息后调用的方法
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"%@",notification);
}

//在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    NSLog(@"%@----%@",identifier,notification);
    completionHandler();//处理完消息，最后一定要调用这个代码块,系统规定
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    
    if (_isUserJPUSH) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}



@end
