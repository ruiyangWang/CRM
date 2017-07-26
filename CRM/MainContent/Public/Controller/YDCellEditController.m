//
//  YDCellEditController.m
//  CRM
//
//  Created by ios on 16/8/9.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCellEditController.h"

@interface YDCellEditController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *subTitleTextField;

@end

@implementation YDCellEditController

- (instancetype)init
{
    if (self = [super init]) {
        [self createView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self viewAddTap];
    
}

#pragma mark 创建view
- (void)createView
{
    UIView *navBarView = [[UIView alloc] init];
    navBarView.frame = CGRectMake(0, 0, kScreenWidth, 64.0f);
    navBarView.backgroundColor = kNavigationBackgroundColor;
    [self.view addSubview:navBarView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(25.0f, 20.0f, kScreenWidth, 44.0f);
    _titleLabel.text = @"客户名称";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_titleLabel];
    
    _subTitleTextField = [[UITextField alloc] init];
    _subTitleTextField.placeholder = @"请输入客户名称";
    _subTitleTextField.textAlignment = NSTextAlignmentRight;
    _subTitleTextField.frame = CGRectMake(0, 20.0f, kScreenWidth - 25.0f, 44.0f);
    _subTitleTextField.returnKeyType = UIReturnKeyDone;
    _subTitleTextField.textColor = [UIColor whiteColor];
    _subTitleTextField.delegate = self;
    _subTitleTextField.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_subTitleTextField];
    
    [_subTitleTextField becomeFirstResponder];
}

- (void)setTitle:(NSString *)title andPlaceholder:(NSString *)placeholder
{
    _titleLabel.text = title;
    _subTitleTextField.placeholder = placeholder;
    
    if ([title isEqualToString:@"联系电话"] || [title isEqualToString:@"身份证号"]) {
        _subTitleTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
}


#pragma mark view添加手势
- (void)viewAddTap
{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backFrontPage)];
    [self.view addGestureRecognizer:tap];
}

- (void)backFrontPage
{
    if (self.BackBlack) {
        self.BackBlack(_subTitleTextField.text);
    }
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - ====================UITextFieldDelegate====================
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{

    [self backFrontPage];
    return YES;
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
