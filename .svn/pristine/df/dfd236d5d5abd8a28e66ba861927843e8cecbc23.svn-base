//
//  YDEditMessageVC.m
//  CRM
//
//  Created by YD_iOS on 16/8/19.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDEditMessageVC.h"

@interface YDEditMessageVC ()
@property (weak, nonatomic) IBOutlet UITextView *strTextView;

@end

@implementation YDEditMessageVC

#pragma mark ----- vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *leftBItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickCancelButton)];
    self.navigationItem.leftBarButtonItem = leftBItem;
    
    UIBarButtonItem *rightBItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickOKButton)];
    self.navigationItem.rightBarButtonItem = rightBItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- get and setter 属性的set和get方法
-(void)setVcTitle:(NSString *)vcTitle{
    _vcTitle = vcTitle;
    
    self.title = vcTitle;
}
#pragma mark ----- event Response 事件响应(手势 通知)
- (void)clickCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clickOKButton{
    [self dismissViewControllerAnimated:YES completion:^{
        if (_ClickOKButtonBlack != nil) {
            _ClickOKButtonBlack(_strTextView.text);
        }
    }];    
}
#pragma mark ----- custom action for UI 界面处理有关
#pragma mark ----- custom action for DATA 数据处理有关
#pragma mark ----- xxxxxx delegate 各种delegate回调
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
