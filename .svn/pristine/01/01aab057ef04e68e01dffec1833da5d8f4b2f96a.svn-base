//
//  UITextField+XZRestrict.m
//  UITextField
//
//  Created by YD_iOS on 16/9/28.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "UITextField+XZRestrict.h"
#import <objc/runtime.h>

//？
static void * XZRestrictTypeKey = &XZRestrictTypeKey;
static void * XZTextRestrictKey = &XZTextRestrictKey;
static void * XZMaxTextLengthKey = &XZMaxTextLengthKey;

@implementation UITextField (XZRestrict)

//用@dynamic修饰的属性，其getter和setter方法会在程序运行的时候或者用其他方式动态绑定
@dynamic restrictType,textRestrict,maxTextLength;


- (void)setRestrictType: (XZRestrictType)restrictType
{
    objc_setAssociatedObject(self, XZRestrictTypeKey, @(restrictType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.textRestrict = [XZTextRestrict textRestrictWithRestrictType: restrictType];
}
- (XZRestrictType)restrictType
{
    return [objc_getAssociatedObject(self, XZRestrictTypeKey) integerValue];
}


- (void)setTextRestrict: (XZTextRestrict *)textRestrict
{
    if (self.textRestrict) {
        [self removeTarget: self.text action: @selector(textDidChanged:) forControlEvents: UIControlEventEditingChanged];
    }
    textRestrict.maxLength = self.maxTextLength;
    [self addTarget: textRestrict action: @selector(textDidChanged:) forControlEvents: UIControlEventEditingChanged];
    objc_setAssociatedObject(self, XZTextRestrictKey, textRestrict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (XZTextRestrict *)textRestrict
{
    return objc_getAssociatedObject(self, XZTextRestrictKey);
}



- (void)setMaxTextLength: (NSUInteger)maxTextLength
{
    if (maxTextLength == 0) {
        maxTextLength = NSUIntegerMax;
    }
    objc_setAssociatedObject(self, XZMaxTextLengthKey, @(maxTextLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSUInteger)maxTextLength
{
    NSUInteger maxTextLength = [objc_getAssociatedObject(self, XZMaxTextLengthKey) unsignedIntegerValue];
    if (maxTextLength == 0) {
        self.maxTextLength = NSUIntegerMax;
    }
    return [objc_getAssociatedObject(self, XZMaxTextLengthKey) unsignedIntegerValue];
}


@end




