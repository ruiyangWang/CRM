//
//  PriceDisplayView.h
//  YDCalculateTool
//
//  Created by ios on 16/6/11.
//  Copyright © 2016年 ios. All rights reserved.
//

/**
 *  显示价格的view
 */

#import <UIKit/UIKit.h>

@interface PriceDisplayView : UIView

/**
 *  最低价格，超过这个价格阴影变红
 */
@property (nonatomic, assign) NSInteger minPrice;

@property (nonatomic, assign) NSInteger showPrice;

/**
 *  带数字改变动画的view
 *
 *  @param width 每个数字按钮的宽度
 *  @param space 每个数字按钮之间的间距
 *
 *  @return <#return value description#>
 */
- (void)setItemWidth:(CGFloat)width itemSpace:(CGFloat)space;

/**
 *  <#Description#>
 *
 *  @param width 每个数字按钮的宽度
 *  @param space 每个数字按钮之间的间距
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithItemWidth:(CGFloat)width itemSpace:(CGFloat)space;

/**
 *  没有动画的
 *
 *  @param price <#price description#>
 */
- (void)setPrice:(NSInteger)price;

/**
 *  <#Description#>
 *
 *  @param price    设置数字
 *  @param animated 数组改变是否需要动画
 */
- (void)setPrice:(NSInteger)price animated:(BOOL)animated;

@end
