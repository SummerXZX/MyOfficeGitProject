//
//  MyRefreshHeader.m
//  NewYMOCProject
//
//  Created by test on 15/11/10.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "MyRefreshHeader.h"
#import "MONActivityIndicatorView.h"

@interface MyRefreshHeader () <MONActivityIndicatorViewDelegate>

@property (nonatomic,strong) MONActivityIndicatorView *indicatorView;///<圆点进度view

@end

@implementation MyRefreshHeader

-(MONActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[MONActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 17, 20, 10)];
        _indicatorView.delegate = self;
        _indicatorView.numberOfCircles = 2;
        _indicatorView.radius = 5;
        _indicatorView.duration = 0.8;
        _indicatorView.internalSpacing = 5;
    }
    return _indicatorView;
}

-(void)prepare {
    [super prepare];
    self.mj_h = 44.0;
    // 添加label
    [self addSubview:self.indicatorView];
}

-(void)placeSubviews {
    [super placeSubviews];
    self.indicatorView.left = (self.mj_w - self.indicatorView.width)/2.0;
    
}

-(void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    if (state==MJRefreshStatePulling) {
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
