//
//  YDCircleProgressView.h
//  CRM
//
//  Created by YD_iOS on 16/7/26.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDCircleProgressView : UIView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat progress;//-0.25 - 0.75 范围，set方法触发动画

- (void)setUI;
- (void)removeView;
- (void)reLoadUI;

@end
