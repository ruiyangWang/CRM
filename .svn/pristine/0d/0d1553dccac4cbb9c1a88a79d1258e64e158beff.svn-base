//
//  UIView+MBIBnspectable.h
//  YDCalculateTool
//
//  Created by YD_iOS on 16/6/21.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "UIView+MBIBnspectable.h"

@implementation UIView (MBIBnspectable)

#pragma mark - setCornerRadius/borderWidth/borderColor
- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

#pragma mark - hexRgbColor
- (void)setHexRgbColor:(NSString *)hexRgbColor{
    NSScanner *scanner = [NSScanner scannerWithString:hexRgbColor];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return;
    self.backgroundColor = [self colorWithRGBHex:hexNum];
}

- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


- (NSString *)hexRgbColor{
    return @"0xffffff";
}

#pragma mark - setOnePx
- (void)setOnePx:(BOOL)onePx{
    if (onePx) {
        CGRect rect = self.frame;
        rect.size.height = 1.0 / [UIScreen mainScreen].scale;
        self.frame = rect;
    }
}

- (BOOL)onePx{
    return self.onePx;
}

#pragma mark -- xib里面设置阴影
-(void)setMasksToBounds:(BOOL)masksToBounds{
    self.layer.masksToBounds = masksToBounds;
}
-(void)setShadowColor:(UIColor *)shadowColor{
    self.layer.shadowColor = shadowColor.CGColor;
}
-(void)setShadowOffset:(CGSize)shadowOffset{
    self.layer.shadowOffset = shadowOffset;
}
-(void)setShadowRadius:(CGFloat)shadowRadius{
    self.layer.shadowOpacity = shadowRadius;
}
-(void)setShadowOpacity:(CGFloat)shadowOpacity{
    self.layer.shadowOpacity = shadowOpacity;
    
    CGSize size = CGSizeMake(1, 10000);
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:bounds].CGPath;
}

@end
