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
 *  设置view的默认属性
 */
- (void)setViewBasicProperty;

/**
 *  设置tableview的默认属性
 */
- (void)setTableViewBasicProperty;

/**
 *  设置空的返回按钮标题
 */
- (void)setEmptyBackButtonTitle;

/**
 *  拨打电话
 */
- (void)callWithPhoneNum:(NSString*)phoneNum;



@end
