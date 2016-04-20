//
//  MyHintView.h
//  YIMIDemo
//
//  Created by test on 16/1/19.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHintCircleView.h"

@interface MyHintView : UIView

@property (nonatomic,strong) UILabel *contentLabel;///<说明内容label

@property (nonatomic,strong) MyHintCircleView *circleView;///<提示转动圆圈

/**
 *  显示进度的提示框,注：无需加“...”默认有“...”的动画
 *
 *  @param view  superView
 *  @param title 内容
 *
 *  @return MyHintView
 */
+ (instancetype)showProgressHintWithTitle:(NSString *)title;

/**
 *  移除进度提示框
 *
 *  @param view superView
 */
+ (void)dismissProgressHintForView:(UIView *)view;

/**
 *  显示成功提示框
 *
 *  @param view  superView
 *  @param title 内容
 *
 *  @return MyHintView
 */
+ (instancetype)showSuccessHintAddedTo:(UIView *)view title:(NSString *)title;

/**
 *  显示失败提示框
 *
 *  @param view  superView
 *  @param title 内容
 *
 *  @return MyHintView
 */
+ (instancetype)showFailHintAddedTo:(UIView *)view title:(NSString *)title;


@end
