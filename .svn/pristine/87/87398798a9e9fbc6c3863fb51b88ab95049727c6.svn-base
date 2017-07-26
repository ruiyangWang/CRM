//
//  YDCircleProgressView.m
//  CRM
//
//  Created by YD_iOS on 16/7/26.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCircleProgressView.h"
#import "YDCircleProgressLayer.h"

@interface YDCircleProgressView()<CAAnimationDelegate>

@property (strong, nonatomic)YDCircleProgressLayer *infoLayer;

@end

@implementation YDCircleProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark ----- vc lift cycle 生命周期
-(void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, 80, 80);
    _lineWidth = self.frame.size.width/10;
    self.layer.mask = [self produceCircleShapeLayer];
}

#pragma mark ----- get and setter 属性的set和get方法
-(YDCircleProgressLayer *)infoLayer{
    if (_infoLayer == nil) {
        _infoLayer = [YDCircleProgressLayer layer];
        _infoLayer.frame = self.bounds;
        _infoLayer.contentsScale = [UIScreen mainScreen].scale;//像素大小比例
    }
    return _infoLayer;
}

- (void)setProgress:(CGFloat)progress {
    
    CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"progress"];
    ani.duration = 5.0 * fabs(progress);
    //ani.duration = 5.0 * fabs(progress - _progress);
    //如果不指定fromValue，将从上一个toValue开始
    ani.fromValue = @(-0.25);
    ani.toValue = @(progress);
    ani.removedOnCompletion = YES;
    ani.fillMode = kCAFillModeForwards;
    ani.delegate = self;
    [self.infoLayer addAnimation:ani forKey:@"progressAni"];
    
    _progress = progress;
    
    //开始红色动画时添加渐变色块
    [self addColorsAnimated:NO];
    [self addColorsAnimated:YES];
}

#pragma mark ----- event Response 事件响应(手势 通知)

#pragma mark ----- custom action for UI 界面处理有关
- (void)setUI{
    _lineWidth = self.frame.size.width/10;
    
    // 生成一个蓝色的图片 并 生产一个圆形路径并设置成遮罩
    self.layer.mask = [self produceCircleShapeLayer];
    
    //添加红色弧线
    [_infoLayer removeFromSuperlayer];
    [self.layer addSublayer:self.infoLayer];
}
-(void)removeView{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self.infoLayer removeFromSuperlayer];
}

- (void)reLoadUI{
    [self removeView];
    [self.layer addSublayer:self.infoLayer];
    self.progress = _progress;
}

//添加蓝色背景 并生成圆环
- (CAShapeLayer *)produceCircleShapeLayer{
    CALayer *blueLayer = [CALayer layer];
    blueLayer.backgroundColor = [UIColor colorWithHexString:@"518DC6"].CGColor;
    blueLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:blueLayer];
        
    CGFloat radius = self.bounds.size.width / 2;
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                              radius:radius - _lineWidth/2
                                                          startAngle:M_PI
                                                            endAngle:-M_PI
                                                           clockwise:NO];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = circlePath.CGPath;
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = _lineWidth;
    
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 1.0;
    
    return shapeLayer;
}

//添加渐变色块
- (void)addColorsAnimated:(BOOL)b{
    UIView *gView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
    CGPoint firstPoint = CGPointMake(self.bounds.size.width/2, 5);
    CAGradientLayer *gradientLayer = (id)[CAGradientLayer layer];
    gradientLayer.frame = gView.frame;
    gradientLayer.position = firstPoint;
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    NSArray *colors = @[(id)[UIColor colorWithHexString:@"518DC6"].CGColor, (id)[UIColor colorWithHexString:@"F26E6E"].CGColor];
    if (b) {
        colors = @[(id)[UIColor colorWithHexString:@"F26E6E"].CGColor, (id)[UIColor colorWithHexString:@"518DC6"].CGColor];
    }
    [gradientLayer setColors:colors];
    [gView.layer addSublayer:gradientLayer];
    [self addSubview:gView];
    if (b) {
        [self addRotationWithLayer:gView];
    }
}

//旋转动画
- (void)addRotationWithLayer:(UIView *)view{
    
    CGPoint anchorPoint = CGPointZero;
    CGPoint superviewCenter = view.superview.center;
    //superviewCenter是view的superview 的 center 在view.superview.superview中的坐标。
    CGPoint viewPoint = [view convertPoint:superviewCenter fromView:view.superview.superview];
    //转换坐标，得到superviewCenter 在 view中的坐标
    anchorPoint.x = (viewPoint.x) / view.bounds.size.width;
    anchorPoint.y = (viewPoint.y) / view.bounds.size.height;
    [self setAnchorPoint:anchorPoint forView:view];
    
    CABasicAnimation*rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2 * _progress + M_PI_2 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 5.0 * fabs(_progress);
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:rotationAnimation forKey:@"Rotation"];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

#pragma mark ----- custom action for DATA 数据处理有关
#pragma mark ----- xxxxxx delegate 各种delegate回调
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.infoLayer.progress = self.progress;
}

@end
