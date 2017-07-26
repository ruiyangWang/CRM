//
//  YDSalesHTMLController.m
//  CRM
//
//  Created by ios on 2017/2/10.
//  Copyright © 2017年 YD_iOS. All rights reserved.
//

#import "YDSalesHTMLController.h"

@interface YDSalesHTMLController () <UIWebViewDelegate>

@end

@implementation YDSalesHTMLController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"销售总览";
    
    self.navigationController.navigationBar.translucent = NO;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin-webapp/overview/list?type=%ld&sid=%@", kServerIP, (long)self.type, getNSUser(kCRM_SIDKey)]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64.0f)];
    [webView loadRequest:[NSURLRequest requestWithURL:URL]];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    [MBProgressHUD showStatus:@"" toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
