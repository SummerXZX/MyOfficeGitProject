//
//  AppDelegate.h
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  弹出升级alertView
 */
-(void)showUpdateAlertViewWithMessage:(NSString *)message UpdateUrl:(NSString *)updateUrl ;


@end

