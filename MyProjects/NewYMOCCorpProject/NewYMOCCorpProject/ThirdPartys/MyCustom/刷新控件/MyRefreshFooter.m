//
//  MyRefreshFooter.m
//  NewYMOCProject
//
//  Created by test on 15/11/10.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "MyRefreshFooter.h"
#import "MyCircleActivityIndicatorView.h"

@interface MyRefreshFooter () <MyCircleActivityIndicatorViewDelegate>

@property (nonatomic, strong) MyCircleActivityIndicatorView* indicatorView; ///<圆点进度view

@property (nonatomic, strong) UIView* lineView; ///<分割线

@property (nonatomic, assign) NSLayoutConstraint* stateWidthConstraint; ///<状态label长度

@property (nonatomic, strong) UILabel *stateLabel;///<状态label

@end

@implementation MyRefreshFooter

- (MyCircleActivityIndicatorView*)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[MyCircleActivityIndicatorView alloc] init];
        _indicatorView.delegate = self;
        _indicatorView.numberOfCircles = 2;
        _indicatorView.radius = 5;
        _indicatorView.duration = 0.8;
        _indicatorView.internalSpacing = 5;

        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _indicatorView;
}

- (UILabel*)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = FONT(14);
        _stateLabel.textColor = DefaultGrayTextColor;
        _stateLabel.hidden = YES;
        _stateLabel.text = @"已没有更多数据";
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.backgroundColor = DefaultBackGroundColor;
        _stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _stateLabel;
}

- (UIView*)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = DefaultLightGrayTextColor;
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _lineView;
}

#pragma mark noMoreDataStr
-(void)setNoMoreDataStr:(NSString *)noMoreDataStr {
    _noMoreDataStr = noMoreDataStr;
    self.stateLabel.text = noMoreDataStr;
    _stateWidthConstraint.constant = [self.stateLabel.text getSizeWithFont:self.stateLabel.font].width + 20;
}

- (void)prepare
{
    [super prepare];
    self.mj_h = 49.0;
    [self addSubview:self.indicatorView];
    [self addSubview:self.lineView];
    [self addSubview:self.stateLabel];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.stateLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    NSArray* constraintArr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[stateLabel(0)]" options:0 metrics:nil views:@{ @"stateLabel" : self.stateLabel }];
    [self addConstraints:constraintArr];
    self.stateWidthConstraint = constraintArr[0];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[stateLabel]-0-|" options:0 metrics:nil views:@{ @"stateLabel" : self.stateLabel }]];
    if (self.stateLabel.text.length != 0) {
        self.stateWidthConstraint.constant = [self.stateLabel.text getSizeWithFont:self.stateLabel.font].width + 20;
    }

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView(1)]" options:0 metrics:nil views:@{ @"lineView" : self.lineView }]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[lineView]-15-|" options:0 metrics:nil views:@{ @"lineView" : self.lineView }]];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    if (state == MJRefreshStateRefreshing) {
        [self.indicatorView startAnimating];
        self.stateLabel.hidden = YES;
        self.lineView.hidden = YES;
    }
    else if (state == MJRefreshStateNoMoreData) {
        self.stateLabel.hidden = NO;
        self.lineView.hidden = NO;
    }
    else {
        self.stateLabel.hidden = YES;
        self.lineView.hidden = YES;
    }
}

- (void)endRefreshing
{
    [self.indicatorView stopAnimating];
    [super endRefreshing];
}

#pragma mark MONActivityIndicatorViewDelegate
- (UIColor*)activityIndicatorView:(MyCircleActivityIndicatorView*)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return RGBCOLOR(250, 120, 0);
    }
    else if (index == 1) {
        return RGBCOLOR(102, 197, 103);
    }
    return RGBCOLOR(0, 0, 0);
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
