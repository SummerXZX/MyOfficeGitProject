//
//  MyRefreshFooter.m
//  NewYMOCProject
//
//  Created by test on 15/11/10.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "MyRefreshFooter.h"
#import "MONActivityIndicatorView.h"


@interface MyRefreshFooter () <MONActivityIndicatorViewDelegate>

@property (nonatomic,strong) MONActivityIndicatorView *indicatorView;///<圆点进度view


@end

@implementation MyRefreshFooter

-(MONActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[MONActivityIndicatorView alloc] init];
        _indicatorView.delegate = self;
        _indicatorView.numberOfCircles = 2;
        _indicatorView.radius = 5;
        _indicatorView.duration = 0.8;
        _indicatorView.internalSpacing = 5;
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _indicatorView;
}


-(void)prepare {
    [super prepare];
    self.mj_h = 49.0;
    [self addSubview:self.indicatorView];
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
    
}

-(void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    if (state==MJRefreshStateRefreshing) {
        [self.indicatorView startAnimating];
    }
    
}

-(void)endRefreshing {
    [self.indicatorView stopAnimating];
    [super endRefreshing];
}

#pragma mark MONActivityIndicatorViewDelegate
-(UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index  {
    if (index==0) {
        return RGBCOLOR(250, 120, 0);
    }
    else if (index==1) {
        return RGBCOLOR(102, 197, 103);
    }
    return RGBCOLOR(0, 0, 0);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
