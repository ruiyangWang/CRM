//
//  MenuPopover.m
//  Menu
//
//  Created by fcx on 15/7/31.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "MenuPopover.h"

@implementation MenuPopover
{
    UIImageView *menuImageView;
    UIButton *topButton;
    UIButton *bottomButton;
    UIButton *threeButton;
    
    UIView *lineView;
    UIView *lineView2;
}



- (instancetype)initWithMenuFrame:(CGRect)frame menuClickBlock:(MenuClickBlock)menuClickBlock {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.menuClickBlock = menuClickBlock;
        menuImageView = [[UIImageView alloc] initWithFrame:frame];
        menuImageView.image = [UIImage imageNamed:@"popup_menu_bg3"];
        menuImageView.userInteractionEnabled = YES;
        menuImageView.layer.anchorPoint = CGPointMake(1, 0);
        menuImageView.frame = frame;
        [self addSubview:menuImageView];
        
        topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        topButton.frame = CGRectMake(4, 8.5, 100, 43.5);
        topButton.tag = 0;
        topButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [topButton setTitle:@"新建意向客户" forState:UIControlStateNormal];
        [topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuImageView addSubview:topButton];
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:62 green:122 blue:186];
        lineView.frame = CGRectMake(topButton.x, topButton.maxY + 1.0f, 100.0f, 1.0f);
        [menuImageView addSubview:lineView];
        
        
        bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomButton.frame = CGRectMake(4, 8.5 + 43.5, 100, 43.5);
        bottomButton.tag = 1;
        bottomButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [bottomButton setTitle:@"导入意向客户" forState:UIControlStateNormal];
        [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottomButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuImageView addSubview:bottomButton];
        lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = [UIColor colorWithRed:62 green:122 blue:186];
        lineView2.frame = CGRectMake(bottomButton.x, bottomButton.maxY + 1.0f, 100.0f, 1.0f);
        [menuImageView addSubview:lineView2];
        
        threeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        threeButton.frame = CGRectMake(4, 8.5 + 43.5 + 43.5, 100, 43.5);
        threeButton.tag = 3;
        threeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [threeButton setTitle:@"导入订单客户" forState:UIControlStateNormal];
        [threeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [threeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuImageView addSubview:threeButton];
        
        UITapGestureRecognizer *tapGesgure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGesgure];
        
    }
    return self;
}

- (void)setMenuType:(NSInteger)menuType
{
    _menuType = menuType;
    
    
    //意向客户
    menuImageView.frame = CGRectMake(menuImageView.x, menuImageView.y, menuImageView.width, menuImageView.height - 50.0f);
    menuImageView.image = [UIImage imageNamed:@"popup_menu_bg1"];
    [topButton setTitle:@"新建客户" forState:UIControlStateNormal];
    bottomButton.hidden = YES;
    threeButton.hidden = YES;
    lineView2.hidden = YES;
    lineView.hidden = YES;
    
}


- (void)buttonAction:(UIButton *)button {
    
    [self dismiss];
    if (self.menuClickBlock) {
        self.menuClickBlock(button.tag);
    }
    
}

- (void)show {
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    __weak UIImageView *weakImageView = menuImageView;
    
    menuImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        weakImageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismiss {
    
    __weak __typeof(self)weakSelf = self;
    __weak UIImageView *weakImageView = menuImageView;
    
    [UIView animateWithDuration:.15 animations:^{
        
        weakImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];
    
}



@end
