//
//  UIView+Hint.h
//  YimiJob
//
//  Created by test on 15/4/23.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadHandle)();

typedef NS_ENUM(NSInteger, LoadingStatus) {
    LoadingStatusOnLoading, ///<正在加载
    LoadingStatusNoData, ///<无数据
    LoadingStatusNetError, ///<网络错误
};

@interface UIView (Hint)

@property (nonatomic, strong) UILabel* loadingLabel; ///<加载文本
@property (nonatomic, strong) UIImageView* loadingImageView; ///<加载图片
@property (nonatomic, strong) UIButton* reloadBtn; ///<重新加载按钮
@property (nonatomic, copy) ReloadHandle reloadHandle; ///<处理重新加载块

/**
 * 根据状态显示加载的图片
 */
- (void)showLoadingImageWithStatus:(LoadingStatus)status;

/**
 * 隐藏状态显示图片
 */
-(void)hiddenLoadingView;

/**
 * 调节loadView的位置
 */
-(void)updateLoadingViewFrameWithInsets:(CGFloat)inserts;

/**
 *  重载处理
 */
- (void)handleReload:(ReloadHandle)reloadHandle;

@end
