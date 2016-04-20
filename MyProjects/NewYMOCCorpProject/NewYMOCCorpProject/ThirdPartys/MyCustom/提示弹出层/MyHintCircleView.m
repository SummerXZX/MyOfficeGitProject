//
//  MyHintCircleView.m
//  YIMIDemo
//
//  Created by test on 16/1/19.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "MyHintCircleView.h"

static NSString *const MyHintCircleViewSpinAnimationKey = @"MyHintCircleViewSpinAnimationKey";


@interface MyHintCircleView ()
{
    BOOL _animating;
}
@property (nonatomic, weak) CAShapeLayer *shapeLayer;


@end

@implementation MyHintCircleView

+ (void)load {
    [self.appearance setLineWidth:2.0];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    self.isAccessibilityElement = YES;
    self.accessibilityLabel = NSLocalizedString(@"Indeterminate Progress", @"Accessibility label for activity indicator view");
    
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.borderWidth = 0;
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    
    
    [self tintColorDidChange];
}

- (void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];

    [self unregisterFromNotificationCenter];
}

#pragma mark - Notifications

- (void)registerForNotificationCenter {
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    [center addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)unregisterFromNotificationCenter {
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    [center removeObserver:self];
}

- (void)applicationDidEnterBackground:(NSNotification *)note {
    [self removeAnimation];
}

- (void)applicationWillEnterForeground:(NSNotification *)note {
    if (self.isAnimating) {
        [self addAnimation];
    }
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    if (ABS(frame.size.width - frame.size.height) < CGFLOAT_MIN) {
        // Ensure that we have a square frame
        CGFloat s = MIN(frame.size.width, frame.size.height);
        frame.size.width = s;
        frame.size.height = s;
    }
    self.shapeLayer.frame = frame;
    
    self.shapeLayer.path = [self layoutPath].CGPath;
    
}

- (UIBezierPath *)layoutPath {
    const double TWO_M_PI = 2.0*M_PI;
    double startAngle = 0.75 * TWO_M_PI;
    double endAngle = startAngle + TWO_M_PI * 0.9;
    
    CGFloat width = self.bounds.size.width;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                          radius:width/2.2f
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:YES];
}


#pragma mark - Hook tintColor

- (void)tintColorDidChange  {
    [super tintColorDidChange];
    self.shapeLayer.strokeColor = self.tintColor.CGColor;
}


#pragma mark - Line width

- (void)setLineWidth:(CGFloat)width {
    self.shapeLayer.lineWidth = width;
}

- (CGFloat)lineWidth {
    return self.shapeLayer.lineWidth;
}




#pragma mark - Control animation

- (void)startAnimating {
    if (_animating) {
        return;
    }
    
    _animating = YES;
    
    [self registerForNotificationCenter];
    [self addAnimation];
}

- (void)stopAnimating {
    if (!_animating) {
        return;
    }
    
    _animating = NO;
    
    [self unregisterFromNotificationCenter];
    
    [self removeAnimation];
    
}

- (BOOL)isAnimating {
    return _animating;
}


#pragma mark - Add and remove animation

- (void)addAnimation {
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue        = @(1*2*M_PI);
    spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    spinAnimation.duration       = 1.0;
    spinAnimation.repeatCount    = INFINITY;
    [self.shapeLayer addAnimation:spinAnimation forKey:MyHintCircleViewSpinAnimationKey];
}

- (void)removeAnimation {
    [self.shapeLayer removeAnimationForKey:MyHintCircleViewSpinAnimationKey];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
