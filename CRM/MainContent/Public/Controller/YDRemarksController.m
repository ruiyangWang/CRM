//
//  YDRemarksController.m
//  CRM
//
//  Created by ios on 16/10/9.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDRemarksController.h"
#import "YDTool.h"

@interface YDRemarksController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation YDRemarksController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self createView];
}

#pragma mark UI
- (void)createView
{
    
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(0, 0, kScreenWidth, 210.0f);
    _textView.delegate = self;
    _textView.text = self.contentText;
    [self.view addSubview:_textView];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 40, 20);
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = doneItem;
    
}

#pragma mark 完成按钮点击
- (void)doneButtonClick
{
    if (self.ChangeBlock) {
        self.ChangeBlock(self.textView.text);
        self.ChangeBlock = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //判断加上输入的字符，是否超过界限
//    NSString *string = [NSString stringWithFormat:@"%@%@", textView.text, text];
//    if (string.length > TEXT_MAXLENGTH){
//        return NO;
//    }
    //   限制苹果系统输入法  禁止输入表情
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    //禁止输入emoji表情
    if ([YDTool stringContainsEmoji:text]) {
        return NO;
    }
    
    return YES;
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
