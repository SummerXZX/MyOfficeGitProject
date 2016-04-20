//
//  OFFemptyFactory.h
//  51offer
//
//  Created by XcodeYang on 12/3/15.
//  Copyright © 2015 51offer. All rights reserved.
//

#import "FORScrollViewEmptyAssistant.h"

@interface EmptyViewFactory : NSObject

/**
 *  网络请求失败
 *
 *  @param scrollView
 *  @param btnBlock
 */
+ (void)errorNetwork:(UIScrollView *)scrollView
            btnBlock:(void(^)())btnBlock;

/**
 *  网络请求失败带位移
 *
 *  @param scrollView
 *  @param offset
 *  @param btnBlock
 */
+ (void)errorNetwork:(UIScrollView *)scrollView Offset:(CGFloat)offset btnBlock:(void (^)())btnBlock;

/**
 *  无数据
 *
 *  @param scrollView
 *  @param btnBlock
 */
+ (void)errorNoData:(UIScrollView *)scrollView WithImageName:(NSString *)imageName Title:(NSString *)title;

/**
 *  无数据带位移
 *
 *  @param scrollView
 *  @param offset
 *  @param imageName
 *  @param title
 */
+ (void)errorNoData:(UIScrollView *)scrollView Offset:(CGFloat)offset WithImageName:(NSString *)imageName Title:(NSString *)title;
//
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com