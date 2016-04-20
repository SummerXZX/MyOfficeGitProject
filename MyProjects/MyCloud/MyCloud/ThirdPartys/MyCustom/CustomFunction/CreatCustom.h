//
//  CreatCustomUI.h
//  SalesHelper_C
//
//  Created by summer on 14/10/17.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+StringTpye.h"

@interface CreatCustom : NSObject

/**
 *使用颜色创建图片
 */
+(UIImage*)creatUIImageWithColor:(UIColor*)color;

/**
 *使用背景色创建View
 */
+(UIView *)creatUIViewWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor;



/**
 *创建LineView
 */
+(UIView *)creatLineViewWithFrame:(CGRect)frame;



@end
