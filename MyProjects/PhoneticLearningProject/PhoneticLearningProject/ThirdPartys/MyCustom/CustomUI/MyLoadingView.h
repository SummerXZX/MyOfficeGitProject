//
//  MyLoadingView.h
//  NewYMOCProject
//
//  Created by test on 15/11/10.
//  Copyright © 2015年 yimi. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoadingStatus) {
    LoadingStatusOnLoading, ///<正在加载
    LoadingStatusNoData, ///<无数据
    LoadingStatusNetError, ///<网络错误
};

typedef void(^MyLoadViewReloadAction)();

@interface MyLoadingView : UIView

@property (nonatomic,strong) UIImageView *loadedImageView;///<加载后显示的图片
@property (nonatomic,strong) UILabel *loadedLabel;///<加载显示的文本
@property (nonatomic,strong) UIButton *reloadBtn;///<重载按钮

/**
 *  显示方法
 */
+(instancetype)showFromView:(UIView *)view WithLoadingStatus:(LoadingStatus)loadingStatus;

/**
 *  带重载按钮的显示方法
 */
+(instancetype)showFromView:(UIView *)view HandleReloadAction:(MyLoadViewReloadAction)reloadAction;

/**
 *  隐藏加载view
 */
+(void)hiddenForView:(UIView *)view;


@property (nonatomic,assign) CGFloat topInsert;

@end
