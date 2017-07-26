//
//  UIColor+HexString.h
//  YDCalculateTool
//
//  Created by ios on 16/6/23.
//  Copyright © 2016年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)


+ (UIColor *)colorWithHexString:(NSString *)color;
+ (NSString *)hexStringWithColor:(UIColor *)c;

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;


@end
