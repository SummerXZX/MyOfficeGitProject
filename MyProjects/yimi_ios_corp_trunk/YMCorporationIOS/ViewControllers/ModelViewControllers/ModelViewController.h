//
//  ModelViewController.h
//  SalesHelper_C
//
//  Created by summer on 14-10-10.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelViewController : UIViewController

/**
 *初始化self.view上子控件View
 */
-(void)layoutSubViews;

/**
 *拨打电话
 */
-(void)callWithPhoneNum:(NSString *)phoneNum;

/**
 *处理请求错误
 */
- (void)handleErrorWithErrorResponse:(id)errorResponse;

@property (nonatomic, strong) UITableView* tableView;

@end
