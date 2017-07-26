//
//  YDCustSearchResultTableView.m
//  CRM
//
//  Created by ios on 16/7/22.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCustSearchResultView.h"

@implementation YDCustSearchResultView

- (instancetype)init
{
    if (self = [super init]) {
        [self createUI];
        self.backgroundColor = [UIColor colorWithRed:106 green:106 blue:106];
        self.alpha = 0.5f;
    }
    return self;
}

- (void)createUI
{
//    //毛玻璃
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    [self addSubview:effectView];
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewFromClick)];
    [self addGestureRecognizer:tap];
}

- (void)viewFromClick
{
    if (self.ClickBlock) {
        self.ClickBlock();
    }
}

@end
