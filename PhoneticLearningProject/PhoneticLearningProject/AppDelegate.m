//
//  AppDelegate.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/11.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "AppDelegate.h"
#import "BookDataBaseManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setAppStyle];
    //创建数据表结构
    [BookDataBaseManager creatLocalTables];
    [ProjectUtil showLog:@"dbPath:%@",[BookDataBaseManager getBookDBPath]];

    
    //设置rootVC
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if ([ProjectUtil getLoginData]) {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
    }
    else {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }
    
    return YES;
}

#pragma mark 定制导航栏和底部tabbar样式
- (void)setAppStyle
{
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //导航栏样式
    [[UINavigationBar appearance]
     setBackgroundImage:[ProjectUtil creatUIImageWithColor:NavigationBarColor]
     forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName : BOLDFONT(18),
                                                           NSForegroundColorAttributeName : [UIColor whiteColor]
                                                           }];
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];
    
    //返回按钮样式
    UIImage* image = [[UIImage imageNamed:@"nav_back"]
                      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    
    [[UIBarButtonItem appearance]
     setBackButtonBackgroundImage:image
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    
    
    // tabbar样式
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectionIndicatorImage:nil];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName : RGBCOLOR(196, 196, 196)
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName : NavigationBarColor
                                                        } forState:UIControlStateSelected];
    

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
