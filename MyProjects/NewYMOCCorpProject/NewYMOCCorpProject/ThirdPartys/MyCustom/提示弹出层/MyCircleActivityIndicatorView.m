//
//  MONActivityIndicatorView.m
//
//  Created by Mounir Ybanez on 4/24/14.
//

#import <QuartzCore/QuartzCore.h>
#import "MyCircleActivityIndicatorView.h"

@interface MyCircleActivityIndicatorView ()


@property (strong, nonatomic) UIColor *defaultColor;///<圆圈的默认颜色


@property (readwrite, nonatomic) BOOL isAnimating;///<是否动画

/**
 设置默认值
 */
- (void)setupDefaults;

/**
 添加圆圈
 */
- (void)addCircles;

/**
 移去圆圈
 */
- (void)removeCircles;

/**
 创建圆圈
 */
- (UIView *)createCircleWithRadius:(CGFloat)radius color:(UIColor *)color positionX:(CGFloat)x;

/**
 创建圆圈动画
 */
- (CABasicAnimation *)createAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay;

@end

@implementation MyCircleActivityIndicatorView

#pragma mark 初始化

- (id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

#pragma mark 设置圆圈大小

- (CGSize)intrinsicContentSize {
    CGFloat width = (self.numberOfCircles * ((2 * self.radius) + self.internalSpacing)) - self.internalSpacing;
    CGFloat height = self.radius * 2;
    return CGSizeMake(width, height);
}


#pragma mark 设置默认值

- (void)setupDefaults {
    self.numberOfCircles = 5;
    self.internalSpacing = 5;
    self.radius = 10;
    self.delay = 0.2;
    self.duration = 0.8;
    self.defaultColor = [UIColor lightGrayColor];
}

#pragma mark 创建圆圈
- (UIView *)createCircleWithRadius:(CGFloat)radius
                             color:(UIColor *)color
                         positionX:(CGFloat)x {
    
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(x, 0, radius * 2, radius * 2)];
    circle.backgroundColor = color;
    circle.layer.cornerRadius = radius;
    return circle;
}

#pragma mark 创建圆圈动画
- (CABasicAnimation *)createAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.delegate = self;
    anim.fromValue = @0.0f;
    anim.toValue = @1.0f;
    anim.autoreverses = YES;
    anim.duration = duration;
    anim.removedOnCompletion = NO;
    anim.beginTime = CACurrentMediaTime()+delay;
    anim.repeatCount = INFINITY;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return anim;
}

#pragma mark 添加圆圈
- (void)addCircles {
    for (NSUInteger i = 0; i < self.numberOfCircles; i++) {
        UIColor *color = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(activityIndicatorView:circleBackgroundColorAtIndex:)]) {
            color = [self.delegate activityIndicatorView:self circleBackgroundColorAtIndex:i];
        }
        UIView *circle = [self createCircleWithRadius:self.radius
                                                color:(color == nil) ? self.defaultColor : color
                                            positionX:(i * ((2 * self.radius) + self.internalSpacing))];
        [circle setTransform:CGAffineTransformMakeScale(0, 0)];
        [circle.layer addAnimation:[self createAnimationWithDuration:self.duration delay:(i * self.delay)] forKey:@"scale"];
        [self addSubview:circle];
    }
}

#pragma mark 移去圆圈
- (void)removeCircles {
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}

#pragma mark 开始动画
- (void)startAnimating {
    if (!self.isAnimating) {
        [self addCircles];
        self.hidden = NO;
        self.isAnimating = YES;
    }
}

#pragma mark 停止动画
- (void)stopAnimating {
    if (self.isAnimating) {
        [self removeCircles];
        self.hidden = YES;
        self.isAnimating = NO;
    }
}

#pragma mark numberOfCircles
- (void)setNumberOfCircles:(NSUInteger)numberOfCircles {
    _numberOfCircles = numberOfCircles;
    [self invalidateIntrinsicContentSize];
}

#pragma mark radius
- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self invalidateIntrinsicContentSize];
}

#pragma mark internalSpacing
- (void)setInternalSpacing:(CGFloat)internalSpacing {
    _internalSpacing = internalSpacing;
    [self invalidateIntrinsicContentSize];
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

@end
