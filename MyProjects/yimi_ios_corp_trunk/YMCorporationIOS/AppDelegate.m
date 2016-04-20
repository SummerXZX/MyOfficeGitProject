//
//  AppDelegate.m
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import "LocalDicDataBaseManager.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "StartAdViewController.h"
#import "UserGuideViewController.h"

#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<UIAlertViewDelegate>
{
    BOOL _alertShow;
    NSString *_updateUrl;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    
    //定制导航栏和底部tabbar样式
    [self setAppStyle];
    
    //对比本地APPVersion
    [self checkLocalAppVersion];

    //创建本地数据库表
    [DataBaseManager creatLocalTables];
    
    //同步本地数据字典
    [self synchronizeLocalDic];
    
    //集成友盟统计
    [MobClick startWithAppkey:UMENG_APPKEY];
    [MobClick setLogSendInterval:REALTIME];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //集成友盟分享
    [UMSocialData setAppKey:UMENG_APPKEY];
    [UMSocialData openLog:NO];
    [UMSocialWechatHandler setWXAppId:@"wxd1d0cfd77c9bc7cc"
                            appSecret:@"f5116d1999ed5b3af803ca6e2ef86ca4"
                                  url:@"https://itunes.apple.com/cn/app/yi-mi-jian-zhi/id913430621?mt=8"];
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    [UMSocialQQHandler setQQWithAppId:@"1104854504"
                               appKey:@"8XDcJXWkU87ScF7V"
                                  url:@"https://itunes.apple.com/cn/app/yi-mi-jian-zhi/id913430621?mt=8"];
     [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
    
        //跳转页面
        NSString *userToken = [ProjectUtil getUserToken];
        BOOL isNotFirstStart = [[NSUserDefaults standardUserDefaults]boolForKey:@"isNotFirstStart"];
        if (!isNotFirstStart)
        {
            self.window.rootViewController = [[UserGuideViewController alloc]init];
        }
        else if (userToken.length!=0)
        {
           self.window.rootViewController = [[StartAdViewController alloc]init];
        }
        else
        {
           UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
           self.window.rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"loginNaVC"];
        }
        return YES;
}


#pragma mark alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        [self exitApplication];
    }
    else
    {
        BOOL bUpdate = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateUrl]];
        if (!bUpdate)
        {
            [self.window makeToast:@"升级地址错误"];
        }
    }
}

- (void)exitApplication {
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

#pragma mark 定制导航栏和底部tabbar样式
-(void)setAppStyle
{
    
    //导航栏样式
    [[UINavigationBar appearance]setBackgroundImage:[ProjectUtil creatUIImageWithColor:NavigationBarColor] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
                                       
    //返回按钮样式
    UIImage *image = [[UIImage imageNamed:@"nav_back"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [[UIBarButtonItem appearance]setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000 , 0) forBarMetrics:UIBarMetricsDefault];
    
    //tabbar样式
    [[UITabBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance]setSelectionIndicatorImage:nil];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:DefaultGrayTextColor} forState:UIControlStateNormal];
    [[UITabBarItem appearance ]setTitleTextAttributes:@{NSForegroundColorAttributeName:NavigationBarColor} forState:UIControlStateSelected];
    
    
}

#pragma mark 对比本地APP版本
-(void)checkLocalAppVersion
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentVersion = [ProjectUtil getCurrentAppVersion];
    NSString *localVersion = [userDefaults objectForKey:@"localVersion"];

    if (localVersion==nil)
    {
        [userDefaults setObject:currentVersion forKey:@"localVersion"];
        [userDefaults synchronize];
    }
    else if (![localVersion isEqualToString:currentVersion])
    {
        NSString *dbPath = [DataBaseManager getLocalDBPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:dbPath error:nil];
        [userDefaults setObject:currentVersion forKey:@"localVersion"];
        //注：下下个版本需注销
        [userDefaults synchronize];
        [ProjectUtil deleteLoginInfo];
    }
}


#pragma mark 同步本地数据字典
-(void)synchronizeLocalDic
{
    NSArray *localVerArr = [LocalDicDataBaseManager getLocalVerArr];
    NSString *versionsStr = @"";
    if (localVerArr.count!=0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:localVerArr options:NSJSONWritingPrettyPrinted error:nil];
        versionsStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSDictionary *params = @{@"versions":versionsStr};
    
    [YMWebServiceClient syncLocalDicWithParams:params Success:^(YMNomalResponse *response)
    {
        if(response.code==ERROR_OK){
            NSArray *arr = [NSArray arrayWithArray:response.data];
            if (arr.count!=0)
            {
                [LocalDicDataBaseManager insertLocalDicDataWith:arr];
            }
        }
        else if (response.code == ERROR_NOT_SUPPORT) {
            [self showUpdateAlertViewWithMessage:response.codeInfo UpdateUrl:(NSString *)response.data];
        }
    } ];
}

#pragma mark 弹出升级alertView
-(void)showUpdateAlertViewWithMessage:(NSString *)message UpdateUrl:(NSString *)updateUrl {
    if (!_alertShow) {
        _updateUrl = updateUrl;
        UIAlertView* alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:message
                                  delegate:self
                         cancelButtonTitle:@"退出"
                         otherButtonTitles:@"立即升级", nil];
        [alertView show];
        _alertShow = YES;
    }
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
    //这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
    [UMSocialSnsService applicationDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString *urlStr = url.absoluteString;
    NSRange range = [urlStr rangeOfString:@"YMCorporationIOSPay"];
    if (range.length>0)
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"]intValue]==9000)
            {
                [self.window makeToast:@"充值成功"];
            }
            else
            {
                [self.window makeToast:resultDic[@"memo"]];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:ChargeSuccessNotification object:nil];
        }];
        return YES;
    }
    else
    {
         return [UMSocialSnsService handleOpenURL:url];
    }
}     





@end
