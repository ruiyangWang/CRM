//
//  UITextField+XZRestrict.h
//  UITextField
//
//  Created by YD_iOS on 16/9/28.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//  限制字符输入长度 和 类型

#import <UIKit/UIKit.h>
#import "XZTextRestrict.h"

@interface UITextField (XZRestrict)

/// 设置后生效
@property (nonatomic, assign) XZRestrictType restrictType;

/// 文本最长长度
@property (nonatomic, assign) NSUInteger maxTextLength;

/// 设置自定义的文本限制
@property (nonatomic, strong) XZTextRestrict * textRestrict;

@end
