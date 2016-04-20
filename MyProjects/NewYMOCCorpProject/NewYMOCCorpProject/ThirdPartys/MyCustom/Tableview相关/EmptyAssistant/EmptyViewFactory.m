//
//  OFFemptyFactory.m
//  51offer
//
//  Created by XcodeYang on 12/3/15.
//  Copyright © 2015 51offer. All rights reserved.
//

#import "EmptyViewFactory.h"

@implementation EmptyViewFactory

#pragma mark 网络请求失败
+ (void)errorNetwork:(UIScrollView *)scrollView
            btnBlock:(void(^)())btnBlock
{
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView
                                        configerBlock:^(FOREmptyAssistantConfiger *configer) {
                                            configer.emptyImage = [UIImage imageNamed:@"load_neterror"];
                                            configer.emptyTitle = HintWithListNetErrorTitle;
                                            configer.emptyTitleFont = FONT(15);
                                            configer.emptyTitleColor = DefaultFailTitleTextColor;
                                            configer.emptySubtitle = HintWithListNetErrorDetail;
                                            configer.emptySubtitleFont = FONT(13);
                                            configer.emptySubtitleColor = DefaultFailDetailTextColor;
                                            configer.emptyBtnCornerRadius = 17.5;
                                            configer.emptyBtnBorderColor = DefaultFailDetailTextColor;
                                            configer.emptyBtnBackgroundColor = DefaultFailBackColor;
                                            configer.emptyBtnBorderWidth = 1.0;
                                            configer.emptyBtnSize = CGSizeMake(150, 35);
                                            configer.emptyBtntitleColor = DefaultFailButtonTextColor;
                                            configer.emptyBtntitleFont = FONT(14);
                                        }
                                        emptyBtnTitle:HintWithListReload
                                  emptyBtnActionBlock:btnBlock];
}

#pragma mark 网络请求失败带位移
+(void)errorNetwork:(UIScrollView *)scrollView Offset:(CGFloat)offset btnBlock:(void (^)())btnBlock {
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView
                                        configerBlock:^(FOREmptyAssistantConfiger *configer) {
                                            configer.emptyImage = [UIImage imageNamed:@"load_neterror"];
                                            configer.emptyTitle = HintWithListNetErrorTitle;
                                            configer.emptyTitleFont = FONT(15);
                                            configer.emptyTitleColor = DefaultFailTitleTextColor;
                                            configer.emptySubtitle = HintWithListNetErrorDetail;
                                            configer.emptySubtitleFont = FONT(13);
                                            configer.emptySubtitleColor = DefaultFailDetailTextColor;
                                            configer.emptyBtnCornerRadius = 17.5;
                                            configer.emptyBtnBorderColor = DefaultFailDetailTextColor;
                                            configer.emptyBtnBackgroundColor = DefaultFailBackColor;
                                            configer.emptyBtnBorderWidth = 1.0;
                                            configer.emptyBtnSize = CGSizeMake(150, 35);
                                            configer.emptyBtntitleColor = DefaultFailButtonTextColor;
                                            configer.emptyBtntitleFont = FONT(14);
                                            configer.emptyCenterOffset = CGPointMake(0, offset);
                                        }
                                        emptyBtnTitle:HintWithListReload
                                  emptyBtnActionBlock:btnBlock];
}

#pragma mark 无数据
+ (void)errorNoData:(UIScrollView *)scrollView WithImageName:(NSString *)imageName Title:(NSString *)title
{
    FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
    configer.emptyImage = [UIImage imageNamed:imageName];
    configer.emptyTitle = title;
    configer.emptyTitleColor = DefaultGrayTextColor;
    configer.emptyTitleFont = FONT(13);
    configer.emptySubtitle = @"";
    configer.emptySubtitleFont = FONT(13);
    configer.emptySubtitleColor = DefaultFailDetailTextColor;
    configer.emptyBtntitleFont = FONT(14);
    configer.emptyBtntitleColor = DefaultFailButtonTextColor;
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView emptyConfiger:configer];
}

#pragma mark 无数据带位移
+ (void)errorNoData:(UIScrollView *)scrollView Offset:(CGFloat)offset WithImageName:(NSString *)imageName Title:(NSString *)title {
    FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
    configer.emptyImage = [UIImage imageNamed:imageName];
    configer.emptyTitle = title;
    configer.emptyTitleColor = DefaultGrayTextColor;
    configer.emptyTitleFont = FONT(13);
    configer.emptySubtitle = @"";
    configer.emptySubtitleFont = FONT(13);
    configer.emptySubtitleColor = DefaultFailDetailTextColor;
    configer.emptyBtntitleFont = FONT(14);
    configer.emptyBtntitleColor = DefaultFailButtonTextColor;
    configer.emptyCenterOffset = CGPointMake(0, offset);
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView emptyConfiger:configer];
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com