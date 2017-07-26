//
//  XZTextRestrict.h
//  UITextField
//
//  Created by YD_iOS on 16/9/28.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//  使用工程模式封装 限制字符输入长度 和 类型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XZRestrictType){
    XZRestrictTypeOnlyNumber,//数字
    XZRestrictTypeOnlyDecimal,//数字 和 .
    XZRestrictTypeOnlyCharacter//非中文
};

@interface XZTextRestrict : NSObject

///内容限制长度
@property (nonatomic, assign) NSInteger maxLength;

///内容限制类型
@property (nonatomic, assign) XZRestrictType restrictType;

///工厂方法
+ (instancetype)textRestrictWithRestrictType:(XZRestrictType)restrictType;

///子类实现限制文本内容
- (void)textDidChanged: (UITextField *)textField;

@end
