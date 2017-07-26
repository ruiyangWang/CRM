//
//  YDAddAndEditViewController.m
//  CRM
//
//  Created by ios on 2017/4/7.
//  Copyright © 2017年 YD_iOS. All rights reserved.
//

#import "YDAddAndEditViewController.h"
#import <MessageUI/MessageUI.h>

@interface YDAddAndEditViewController () <MFMessageComposeViewControllerDelegate>

@end

@implementation YDAddAndEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 发送离店短信
- (void)sendMessageWithPhone:(NSArray *)phone message:(NSString *)message
{
    if ([MFMessageComposeViewController canSendText]) {
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phone;
        controller.body = message;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
        
        //修改短信界面标题
        //[[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"提示信息" message:@"设备没有短信功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];//关键的一句   不能为YES
    
    switch (result) {
            
        case MessageComposeResultCancelled:
            [[[UIAlertView alloc] initWithTitle:@"信息发送取消" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
            break;
        case MessageComposeResultFailed:
            [[[UIAlertView alloc] initWithTitle:@"信息发送失败" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
            break;
        case MessageComposeResultSent:
            [[[UIAlertView alloc] initWithTitle:@"信息发送成功" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
            break;
        default:
            break;
    }
}


@end
