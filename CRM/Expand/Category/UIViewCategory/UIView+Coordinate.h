//
//  UIView+Coordinate.h
//  YDCalculateTool
//
//  Created by ios on 16/6/12.
//  Copyright © 2016年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Coordinate)

/** 视图高度 */
@property (assign, nonatomic)   CGFloat height;

/** 视图宽度 */
@property (assign, nonatomic)   CGFloat width;

/** 视图x点 */
@property (assign, nonatomic)   CGFloat x;

/** 视图y点 */
@property (assign, nonatomic)   CGFloat y;

/** 视图原点 */
@property (assign, nonatomic)   CGPoint origin;

/** 视图尺寸 */
@property (assign, nonatomic)   CGSize size;

/** 视图中心点 X */
@property (assign, nonatomic)   CGFloat centerX;

/** 视图中心点 Y */
@property (assign, nonatomic)   CGFloat centerY;

/** 视图最大x点 */
@property (assign, nonatomic, readonly)   CGFloat maxX;

/** 视图最大y点 */
@property (assign, nonatomic, readonly)   CGFloat maxY;

/**
 *  向左或向右滑动
 *
 *  @param value <#value description#>
 */
- (void)leftOrRightSlideValue:(CGFloat)value;

/**
 *  向上或向下滑动
 *
 *  @param value <#value description#>
 */
- (void)upOrDownSlideValue:(CGFloat)value;

@end
