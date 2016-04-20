//
//  UIViewController+ProjectCategory.h
//  NewYMOCProject
//
//  Created by test on 15/12/16.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ProjectCategory)

/**
 *初始化self.view上子控件View
 */
- (void)layoutSubViews;

/**
 *  设置view的默认属性
 */
- (void)setViewBasicProperty;

/**
 *处理请求错误
 */
-(void)handleErrorWithErrorResponse:(id)errorResponse ShowHint:(BOOL)showHint;

/**
 *拨打电话
 */
- (void)callWithPhoneNum:(NSString*)phoneNum;





@end
