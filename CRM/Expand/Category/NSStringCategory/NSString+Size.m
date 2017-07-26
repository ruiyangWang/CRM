//
//  NSString+Size.m
//  CRM
//
//  Created by ios on 16/10/26.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithWidth:(CGFloat)width andFont:(CGFloat)font {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize  size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)  attributes:attribute context:nil].size;
    return size;
}

@end
