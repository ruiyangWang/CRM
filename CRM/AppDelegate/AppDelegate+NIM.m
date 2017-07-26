//
//  AppDelegate+NIM.m
//  NIM_test
//
//  Created by YD_iOS on 2017/3/29.
//  Copyright © 2017年 Eonman. All rights reserved.
//

#import "AppDelegate+NIM.h"
#import <NIMSDK/NIMSDK.h>

#import "NTESLoginViewController.h"
#import "UIView+Toast.h"
#import "NTESService.h"
#import "NTESNotificationCenter.h"
#import "NTESLogManager.h"
#import "NTESDemoConfig.h"
#import "NTESSessionUtil.h"
#import "NTESMainTabController.h"
#import "NTESLoginManager.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESClientUtil.h"
#import "NTESNotificationCenter.h"
#import "NIMKit.h"
#import "NTESSDKConfigDelegate.h"
#import "NTESCellLayoutConfig.h"

#import "ViewController.h"

NSString *NTESNotificationLogout = @"NTESNotificationLogout";

@interface AppDelegate()<NIMLoginManagerDelegate>

@property (nonatomic,strong) NTESSDKConfigDelegate *sdkConfigDelegate;

@end

@implementation AppDelegate (NIM)

-(void)registNIM{
    
    //在注册 NIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数
//    [[NIMSDKConfig sharedConfig] set...]
    
    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    NSString *appKey = [[NTESDemoConfig sharedConfig] appKey];
    NSString *cerName= [[NTESDemoConfig sharedConfig] cerName];
    [[NIMSDK sharedSDK] registerWithAppID:appKey
                                  cerName:cerName];
    
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    
    //注册 NIMKit 自定义排版配置
    [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig class]];
    
    [self setupServices];
    [self registerAPNs];
    [self commonInitListenEvents];
    
    //[self setupMainViewController];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}

#pragma mark - misc
- (void)registerAPNs
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)setupMainViewController
{
    LoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    
    //如果有缓存用户名密码推荐使用自动登录
    if ([account length] && [token length])
    {
        [[[NIMSDK sharedSDK] loginManager] autoLogin:account
                                               token:token];
        [[NTESServiceManager sharedManager] start];
        NTESMainTabController *mainTab = [[NTESMainTabController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController = mainTab;
    }
    else
    {
        [self setupLoginViewController];
    }
}

- (void)commonInitListenEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:NTESNotificationLogout
                                               object:nil];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

- (void)setupLoginViewController
{
    ViewController *loginController = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = nav;
}

#pragma mark - 注销
-(void)logout:(NSNotification*)note
{
    [self doLogout];
}

- (void)doLogout
{
    [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
    [[NTESServiceManager sharedManager] destory];
    [self setupLoginViewController];
}


#pragma NIMLoginManagerDelegate
-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            NSString *clientName = [NTESClientUtil clientName:clientType];
            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)onAutoLoginFailed:(NSError *)error
{
    //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
    DDLogInfo(@"onAutoLoginFailed %zd",error.code);
    NSString *toast = [NSString stringWithFormat:@"登录失败: %zd",error.code];
    [self.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
    }];
}


#pragma mark - logic impl
- (void)setupServices
{
    [[NTESLogManager sharedManager] start];
    [[NTESNotificationCenter sharedCenter] start];
}



@end
