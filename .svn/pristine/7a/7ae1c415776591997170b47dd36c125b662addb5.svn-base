//
//  PriceDisplayView.m
//  YDCalculateTool
//
//  Created by ios on 16/6/11.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "PriceDisplayView.h"


@interface PriceDisplayView ()

@property (nonatomic, strong) NSMutableArray *labelArray;

@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *scrollArray;

@end

@implementation PriceDisplayView


- (instancetype)initWithItemWidth:(CGFloat)width itemSpace:(CGFloat)space
{
    if (self = [super init]) {
        _labelArray = [NSMutableArray array];
        
        
        [self createViewWithItemWidth:width itemSpace:space];
        _itemWidth = width;
    }
    return self;
}

- (void)setItemWidth:(CGFloat)width itemSpace:(CGFloat)space
{
    _scrollArray = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    [self createScrollViewWithItemWidth:width itemSpace:space];
}


- (void)createViewWithItemWidth:(CGFloat)width itemSpace:(CGFloat)space
{
    for (int i = 0; i < 7; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"price_background"]];
        imageView.frame = CGRectMake(i * (width + space), 0, width, width);
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(i * (30.0f + 7.5f) + 2.5f, 0, width - 5.0f, width - 5.0f);
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:imageView];
        [self addSubview:label];
        
        [_labelArray addObject:label];
    }
}


- (void)setPrice:(NSInteger)price
{
    NSInteger tempPrice = price;
    
    for (int i = 0; i < _labelArray.count; i++)
    {
        UILabel *label = [_labelArray objectAtIndex:_labelArray.count - 1 - i];
        label.text = [NSString stringWithFormat:@"%ld", tempPrice % 10];
        tempPrice = tempPrice / 10;
    }
    
    UILabel *label = [_labelArray objectAtIndex:0];
    label.text = @"￥";
}

- (void)setPrice:(NSInteger)price animated:(BOOL)animated
{
    _showPrice = price;
    
    for (UIImageView *imageView in _imageArray) {
        imageView.image = [UIImage imageNamed:@"price_background"];
    }
    
    for (int i = 6; i >= 0; i--) {
        UIScrollView *scrollerView = _scrollArray[i];
        [UIView animateWithDuration:0.5 animations:^{
            scrollerView.contentOffset = CGPointMake(0, 30 * (price % 10));
        }];
        scrollerView.contentOffset = CGPointMake(0, 30 * (price % 10));
        price = price / 10;
    }
}

- (void)createScrollViewWithItemWidth:(CGFloat)width itemSpace:(CGFloat)space
{
    for (int i = 0; i < 7; i++) {
        UIScrollView *scrollView = [self createScrollWithIsFirst:!i]; //i 等于0的时候返回yes  不等于0的时候返回no
        scrollView.frame = CGRectMake(40 * i, 0, 30, 30);
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"price_background"]];
        imageView.frame = CGRectMake(40 * i, 0, 35, 35);
        
        [self addSubview:imageView];
        [self addSubview:scrollView];
        
        [_imageArray addObject:imageView];
        [_scrollArray addObject:scrollView];
    }
}

- (UIScrollView *)createScrollWithIsFirst:(BOOL)isFirst
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(30, 300);
    scrollView.userInteractionEnabled = NO;
    for (int i = 0; i < 10; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(2.5f, 30 * i, 30, 30);
        label.text = [NSString stringWithFormat:@"%d", i];
        [scrollView addSubview:label];
        if (isFirst) {
            label.text = @"¥";
        }
    }
    
    return scrollView;
}


@end
