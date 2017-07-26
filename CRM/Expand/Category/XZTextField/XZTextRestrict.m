//
//  XZTextRestrict.m
//  UITextField
//
//  Created by YD_iOS on 16/9/28.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "XZTextRestrict.h"

@interface XZTextRestrict()
@end

@interface XZNumberTextRestrict:XZTextRestrict
@end

@interface XZDecimalTextRestrict : XZTextRestrict
@end

@interface XZCharacterTextRestrict : XZTextRestrict
@end

#pragma mark - 父类实现
@implementation XZTextRestrict

+ (instancetype)textRestrictWithRestrictType:(XZRestrictType)restrictType{
    XZTextRestrict *textRestrict;
    switch (restrictType) {
        case XZRestrictTypeOnlyNumber:
            textRestrict = [[XZNumberTextRestrict alloc]init];
            break;
            
        case XZRestrictTypeOnlyDecimal:
            textRestrict = [[XZDecimalTextRestrict alloc]init];
            break;
            
        case XZRestrictTypeOnlyCharacter:
            textRestrict = [[XZCharacterTextRestrict alloc]init];
            break;
            
        default:
            break;
    }
    
    textRestrict.restrictType = restrictType;
    return textRestrict;
}

- (void)textDidChanged: (UITextField *)textField{
    
}

@end

//由于子类在筛选的过程中都存在遍历字符串以及正则表达式验证的流程，把这一部分代码逻辑给封装起来。
//根据EOC的原则优先使用static inline的内联函数而非宏定义
typedef BOOL (^XZStringFilter)(NSString *aString);
static inline NSString *kFilterString(NSString *handleString, XZTextRestrict *tRestrict, XZStringFilter subStringFilter){
    
    NSMutableString *modifyString = handleString.mutableCopy;
    for (NSInteger idx=0; idx<modifyString.length; ) {
        NSString *subString = [modifyString substringWithRange:NSMakeRange(idx, 1)];
        if (subStringFilter(subString) && idx<tRestrict.maxLength) {
            idx++;
        }else{
            [modifyString deleteCharactersInRange:NSMakeRange(idx, 1)];
        }
    }
    return modifyString;
}

static inline BOOL kMatchStringFormat(NSString *aString, NSString *matchFormat){
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",matchFormat];
    return [predicate evaluateWithObject:aString];
}

#pragma mark - 子类实现
@implementation XZNumberTextRestrict

-(void)textDidChanged:(UITextField *)textField{
    textField.text = kFilterString(textField.text, self, ^BOOL(NSString *aString){
        return kMatchStringFormat(aString, @"^\\d$");
    });
}

@end

@implementation XZDecimalTextRestrict

-(void)textDidChanged:(UITextField *)textField{
    textField.text = kFilterString(textField.text,self , ^BOOL(NSString *aString){
        return kMatchStringFormat(aString, @"^[0-9].$");
    });
}

@end

@implementation XZCharacterTextRestrict

-(void)textDidChanged:(UITextField *)textField{
    textField.text = kFilterString(textField.text,self , ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^[^[\\u4e00-\\u9fa5]]$");
    });
}

@end





