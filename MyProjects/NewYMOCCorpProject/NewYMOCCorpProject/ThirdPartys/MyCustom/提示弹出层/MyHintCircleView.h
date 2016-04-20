//
//  MyHintCircleView.h
//  YIMIDemo
//
//  Created by test on 16/1/19.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHintCircleView : UIView

/**
 A float value to indicate how thick the line of the activivity indicator is.
 
 The default value is 2.f.
 */
@property (nonatomic) CGFloat lineWidth;

/**
 Starts the animation of the progress indicator.
 
 When the progress indicator is animated, the gear spins to indicate indeterminate progress. The indicator is animated
 until stopAnimating is called.
 */
- (void)startAnimating;

/**
 Stops the animation of the progress indicator.
 
 Call this method to stop the animation of the progress indicator started with a call to startAnimating. When animating
 is stopped, the indicator is hidden, unless hidesWhenStopped is NO.
 */
- (void)stopAnimating;

/**
 Returns whether the receiver is animating.
 
 @return YES if the receiver is animating, otherwise NO.
 */
- (BOOL)isAnimating;

@end
