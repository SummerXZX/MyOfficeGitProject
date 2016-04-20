//
//  CreatCustomUI.m
//  SalesHelper_C
//
//  Created by summer on 14/10/17.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "CreatCustom.h"

@implementation CreatCustom

#pragma mark 使用背景色创建View
+(UIView *)creatUIViewWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    return view;
}

#pragma mark 使用颜色创建图片
+(UIImage*)creatUIImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark 创建LineView
+(UIView *)creatLineViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = DefaultLineColor;
    return view;
}


@end
