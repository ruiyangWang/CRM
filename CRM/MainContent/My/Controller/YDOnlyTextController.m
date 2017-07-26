//
//  YDOnlyTextController.m
//  CRM
//
//  Created by ios on 16/8/27.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDOnlyTextController.h"
#import "YDDataService.h"

@interface YDOnlyTextController ()

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *customerId;

@end

@implementation YDOnlyTextController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self createView];
    
    [self loadDataFormNetwork];
}



- (void)createView
{
    self.title = @"离店短信";
    
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(0, 0, kScreenWidth, 210.0f);
    [self.view addSubview:_textView];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 40, 20);
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = doneItem;

}


- (void)doneButtonClick
{
    [self.view endEditing:YES];
    
    NSDictionary *dic = @{
                          @"val" : _textView.text,
                          @"id" : _customerId
                          };
    
    NSString *setMessageUrl = [NSString stringWithFormat:@"%@type=%@&sid=%@",kSetMessageAddress,_type,getNSUser(@"youdao.CRM_SID")];
    
    [YDDataService startRequest:dic url:setMessageUrl block:^(id result) {
        
        if ([result[@"code"] isEqualToString:@"S_OK"]) {
            [MBProgressHUD showTips:@"设置成功" toView:kWindow];
            setNSUser(_textView.text, kLeaveMessageKey);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failBlock:^(id error) {
        
    }];

}


- (void)loadDataFormNetwork
{
    NSDictionary *dic = @{};
    
    NSString *getMessageUrl = [NSString stringWithFormat:@"%@sid=%@",kGetMessageAddress,getNSUser(@"youdao.CRM_SID")];
    
    [YDDataService startRequest:dic url:getMessageUrl block:^(id result) {
        
        if ([result[@"code"] isEqualToString:@"S_OK"]) {
            NSDictionary *resultDic = result[@"var"];
            
            if (![resultDic[@"memberconfig"] isKindOfClass:[NSNull class]]) {
                _textView.text = resultDic[@"memberconfig"][@"val"];
                _type = @"update";
                _customerId = resultDic[@"memberconfig"][@"modelId"];
            } else {
                _textView.text = resultDic[@"baseconfig"][@"val"];
                _type = @"save";
            }
            
        }
        
    } failBlock:^(id error) {
        
    }];
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
