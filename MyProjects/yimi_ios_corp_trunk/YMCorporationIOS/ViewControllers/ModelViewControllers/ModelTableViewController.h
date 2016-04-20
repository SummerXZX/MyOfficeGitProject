//
//  ModelTableViewController.h
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewController.h"

@interface ModelTableViewController : UITableViewController

/**
 *初始化self.view上子控件View
 */
-(void)layoutSubViews;


/**
 *处理请求错误
 */
- (void)handleErrorWithErrorResponse:(id)errorResponse;

/**
 *拨打电话
 */
-(void)callWithPhoneNum:(NSString *)phoneNum;

@end
