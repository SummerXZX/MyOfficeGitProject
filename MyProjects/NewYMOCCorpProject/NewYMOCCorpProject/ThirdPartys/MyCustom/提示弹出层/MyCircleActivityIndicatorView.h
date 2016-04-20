//
//  MONActivityIndicatorView.h
//
//  Created by Mounir Ybanez on 4/24/14.
//

#import <UIKit/UIKit.h>

@protocol MyCircleActivityIndicatorViewDelegate;

@interface MyCircleActivityIndicatorView : UIView

@property (readwrite, nonatomic) NSUInteger numberOfCircles;///<多少个圆圈

@property (readwrite, nonatomic) CGFloat internalSpacing;///<圆圈间的间距

@property (readwrite, nonatomic) CGFloat radius;///<圆圈的半径

@property (readwrite, nonatomic) CGFloat delay;///<每个圆圈间的间隔时间

@property (readwrite, nonatomic) CGFloat duration;///<每个圆圈的动画时间

@property (weak, nonatomic) id<MyCircleActivityIndicatorViewDelegate> delegate;///<代理


/**
 开始动画
 */
- (void)startAnimating;

/**
 结束动画
 */
- (void)stopAnimating;

@end

@protocol MyCircleActivityIndicatorViewDelegate <NSObject>

@optional

/**
 获取每个圆圈的颜色
 */
- (UIColor *)activityIndicatorView:(MyCircleActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index;

@end
