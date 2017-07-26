//
//  YDCircleProgressLayer.m
//  CRM
//
//  Created by YD_iOS on 16/7/26.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCircleProgressLayer.h"

@implementation YDCircleProgressLayer

- (instancetype)initWithLayer:(YDCircleProgressLayer *)layer {
    if (self = [super initWithLayer:layer]) {
        self.progress = layer.progress;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx{
    CGFloat radius = self.bounds.size.width / 2;
    CGFloat lineWidth = 10.0;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                         radius:radius - lineWidth / 2
                                                     startAngle:-M_PI_2
                                                       endAngle:M_PI * 2 * self.progress
                                                      clockwise:YES];
//    CGContextSetRGBStrokeColor(ctx, 242/255.0, 110/255.0, 110/255.0, 255/255.0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHexString:@"F26E6E"].CGColor);
    CGContextSetLineWidth(ctx, 10);
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

@end
