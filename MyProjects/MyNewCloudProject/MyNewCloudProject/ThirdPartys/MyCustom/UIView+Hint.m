//
//  UIView+Hint.m
//  YimiJob
//
//  Created by test on 15/4/23.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "UIView+Hint.h"
#import <objc/runtime.h>

static CGFloat loadLabelHeight = 20.0;
static CGFloat loadLabelWidth = 250.0;


@implementation UIView (Hint)

static char loadLabelKey;
static char loadActivityKey;

#pragma mark loadingLabel
-(UILabel *)loadingLabel
{
    return objc_getAssociatedObject(self, &loadLabelKey);
}

-(void)setLoadingLabel:(UILabel *)loadingLabel
{
    objc_setAssociatedObject(self, &loadLabelKey, loadingLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark reloadBtn
-(UIActivityIndicatorView *)activityView
{
    return objc_getAssociatedObject(self, &loadActivityKey);
}

-(void)setActivityView:(UIActivityIndicatorView *)activityView
{
    objc_setAssociatedObject(self, &loadActivityKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark 根据状态显示加载的图片
-(void)showLoadingImageWithStatus:(LoadingStatus)status StatusStr:(NSString *)statusStr
{
    //提示label
    if (!self.loadingLabel)
    {
       self.loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,(self.height-loadLabelHeight)/2.0, loadLabelWidth, loadLabelHeight)];
        self.loadingLabel.textColor = DefaultGrayTextColor;
        self.loadingLabel.textAlignment = NSTextAlignmentCenter;
        self.loadingLabel.font =FONT(13);
        self.loadingLabel.text = statusStr;
        [self addSubview:self.loadingLabel];
    }
    else
    {
        self.loadingLabel.hidden = NO;
        self.loadingLabel.text = statusStr;
    }
    //提示圈圈
    if (status==LoadingStatusOnLoading)
    {
        if (!self.activityView)
        {
            self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            self.activityView.top = self.loadingLabel.top+(self.loadingLabel.height-self.activityView.height)/2.0;
            [self addSubview:self.activityView];
            [self.activityView startAnimating];
        }
    }
    else
    {
        self.activityView=nil;
    }
    CGFloat contentWidth = [statusStr getSizeWithFont:self.loadingLabel.font].width;
    self.loadingLabel.width = contentWidth;
    if (self.activityView)
    {
        contentWidth += self.activityView.width+5;
        self.activityView.left = (self.width-contentWidth)/2.0;
        self.loadingLabel.left = self.activityView.right+5;
    }
    else
    {
        self.loadingLabel.left = (self.width-self.loadingLabel.width)/2.0;
    }
}

#pragma mark 隐藏状态显示图片
-(void)hiddenLoadingView
{
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
    self.loadingLabel.hidden = YES;
}


@end
