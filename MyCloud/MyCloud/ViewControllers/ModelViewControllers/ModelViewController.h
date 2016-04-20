//
//  ModelViewController.h
//  SalesHelper_C
//
//  Created by summer on 14-10-10.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <UIKit/UIKit.h>


//跳转方式
typedef NS_ENUM(NSInteger, PushType){
    Present=101,
    Push=102,
};

@interface ModelViewController : UIViewController

/**
 *初始化self.view上子控件View
 */
-(void)layoutSubViews;

/**
 *创建统一的返回按钮
 */
-(void)creatBackButtonWithPushType:(PushType)pushType;


/**
 *拨打电话
 */
-(void)callWithPhoneNum:(NSString *)phoneNum;

@end
