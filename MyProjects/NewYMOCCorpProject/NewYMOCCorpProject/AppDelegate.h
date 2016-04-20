//
//  AppDelegate.h
//  NewYMOCCorpProject
//
//  Created by test on 15/12/31.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  弹出升级alertView
 */
-(void)showUpdateAlertViewWithMessage:(NSString *)message UpdateUrl:(NSString *)updateUrl ;

/**
 *  处理协议
 */
- (void)dealWithUrl:(NSString*)url;

@end

