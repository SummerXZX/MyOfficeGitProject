//
//  UIView+Hint.h
//  YimiJob
//
//  Created by test on 15/4/23.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadHandle)();

typedef NS_ENUM(NSInteger, LoadingStatus)
{
    LoadingStatusOnLoading,
    LoadingStatusNoData,
    LoadingStatusNetError,
};

@interface UIView (Hint)

@property (nonatomic,strong) UILabel *loadingLabel;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
/**
 * 根据状态显示加载
 */
-(void)showLoadingImageWithStatus:(LoadingStatus)status StatusStr:(NSString *)statusStr;

/**
 * 隐藏状态显示
 */
-(void)hiddenLoadingView;





@end
