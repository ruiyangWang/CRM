//
//  UIView+Coordinate.m
//  YDCalculateTool
//
//  Created by ios on 16/6/12.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "UIView+Coordinate.h"

@implementation UIView (Coordinate)

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height{
    return CGRectGetHeight(self.bounds);
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width{
    return CGRectGetWidth(self.bounds);
}

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x{
    return CGRectGetMinX(self.frame);
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y{
    return CGRectGetMinY(self.frame);
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX{
    return CGRectGetMidX(self.frame);
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY{
    return CGRectGetMidY(self.frame);
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (void)leftOrRightSlideValue:(CGFloat)value
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x += value;
    self.frame = tempFrame;
}

- (void)upOrDownSlideValue:(CGFloat)value
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y += value;
    self.frame = tempFrame;
}
@end