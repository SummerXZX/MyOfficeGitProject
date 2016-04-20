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
static CGFloat loadImageWidth = 100.0;
static CGFloat loadImageHeight = 120.0;
static CGFloat reloadBtnWidth = 100.0;
static CGFloat reloadBtnHeight = 35.0;


@implementation UIView (Hint)

static char loadLabelKey;
static char loadImageKey;
static char reloadBtnKey;
static char reloadHandleKey;

#pragma mark loadingImageView
-(UIImageView *)loadingImageView
{
    return objc_getAssociatedObject(self, &loadImageKey);
}

-(void)setLoadingImageView:(UIImageView *)loadingImageView
{
    objc_setAssociatedObject(self, &loadImageKey, loadingImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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
-(UIButton *)reloadBtn
{
    return objc_getAssociatedObject(self, &reloadBtnKey);
}

-(void)setReloadBtn:(UIButton *)reloadBtn
{
    objc_setAssociatedObject(self, &reloadBtnKey, reloadBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark reloadHandle
-(ReloadHandle)reloadHandle
{
    return objc_getAssociatedObject(self, &reloadHandleKey);
}




-(void)setReloadHandle:(ReloadHandle)reloadHandle
{
    objc_setAssociatedObject(self, &reloadHandleKey, reloadHandle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark 根据状态显示加载的图片
-(void)showLoadingImageWithStatus:(LoadingStatus)status
{
    //提示label
    UILabel *loadLabel = nil;
    if (!self.loadingLabel)
    {
        loadLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.width-loadLabelWidth)/2.0,0, loadLabelWidth, loadLabelHeight)];
        loadLabel.textColor = DefaultGrayTextColor;
        loadLabel.textAlignment = NSTextAlignmentCenter;
        loadLabel.font =Default_Font_13;
        self.loadingLabel = loadLabel;
        [self addSubview:self.loadingLabel];
    }
    //提示图片
    UIImageView *loadImageView = nil;
    if (!self.loadingImageView)
    {
        loadImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.width-loadImageWidth)/2.0, 0, loadImageWidth,loadImageHeight)];
        loadImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.loadingImageView = loadImageView;
        [self addSubview:self.loadingImageView];
    }
    //重新加载按钮
    UIButton *reloadBtn = nil;
    NSString *imageName = @"";
    if (status==LoadingStatusOnLoading)
    {
       self.loadingLabel.text = @"加载中...";
        self.reloadBtn.hidden = YES;
        imageName = @"loading_logo";
    }
    else if (status==LoadingStatusNoData)
    {
        self.loadingLabel.text = @"没有查询到数据...";
        self.reloadBtn.hidden = YES;
        imageName = @"loading_null";
    }
    else if (status==LoadingStatusNetError)
    {
        self.loadingLabel.text = @"网络不给力哦...";
        imageName = @"loading_failure_logo";
        if (!self.reloadBtn)
        {
            reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            reloadBtn.backgroundColor = HEXCOLOR(0x66C665);
            reloadBtn.layer.cornerRadius = 5.0;
            reloadBtn.titleLabel.font = Default_Font_15;
            [reloadBtn setTitle:@"重试" forState:UIControlStateNormal];
            [reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            reloadBtn.frame = CGRectMake((self.width-reloadBtnWidth)/2.0, 0, reloadBtnWidth, reloadBtnHeight);
            [reloadBtn addTarget:self action:@selector(reloadBtnAction) forControlEvents:UIControlEventTouchUpInside];
            self.reloadBtn = reloadBtn;
            
            [self addSubview:self.reloadBtn];
        }
        else
        {
            self.reloadBtn.hidden = NO;
        }
    }
    self.loadingImageView.image = [UIImage imageNamed:imageName];
    self.loadingImageView.hidden = NO;
    self.loadingLabel.hidden = NO;
    CGFloat loadViewHeight = self.loadingLabel.height+10+self.loadingImageView.height+10+self.reloadBtn.height;
    self.loadingImageView.top = (self.height-loadViewHeight)/2.0-(self.height-loadImageHeight)*0.1;
    self.loadingLabel.top = self.loadingImageView.bottom+10;
    if (self.reloadBtn)
    {
        self.reloadBtn.top = self.loadingLabel.bottom +10;
    }
}

-(void)updateLoadingViewFrameWithInsets:(CGFloat)inserts
{
    self.loadingImageView.top = self.loadingImageView.top-inserts;
    self.loadingLabel.top = self.loadingImageView.bottom+10;
    if (self.reloadBtn)
    {
        self.reloadBtn.top = self.loadingLabel.bottom+10;
    }
}

#pragma mark 重载处理
- (void)handleReload:(ReloadHandle)reloadHandle
{
    self.reloadHandle = reloadHandle;
}

#pragma mark 隐藏状态显示图片
-(void)hiddenLoadingView
{
    self.loadingImageView.hidden = YES;
    self.loadingLabel.hidden = YES;
    self.reloadBtn.hidden = YES;
}

#pragma mark 点击重试按钮动作
-(void)reloadBtnAction
{
    if (self.reloadHandle)
    {
        self.reloadHandle();
    }
    
}

@end
