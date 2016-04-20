//
//  AppDelegate.m
//  NewYMOCCorpProject
//
//  Created by test on 15/12/31.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LocalDicDataBaseManager.h"
#import <IQKeyboardManager.h>
#import <AlipaySDK/AlipaySDK.h>
#import "UMessage.h"
#import "JobsManagerViewController.h"
#import "ReportManagerViewController.h"
#import "HasEvaluateViewController.h"
#import "MessageManagerViewController.h"
#import "ModelWebViewController.h"

@interface AppDelegate ()<UIAlertViewDelegate>
{
    BOOL _alertShow;
    NSString *_updateUrl;
    NSString* _jumpUrl;
}
@end

@implementation AppDelegate

static NSInteger UpdateAlertTag = 101;
static NSInteger UrlJumpAlertTag = 102;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    //设置app样式
    [self setAPPStyle];
    
    //对比本地APPVersion
    [self checkLocalAppVersion];
    
    //创建本地数据库表
    [DataBaseManager creatLocalTables];
    
    //同步本地数据字典
    [self synchronizeLocalDic];
    
    //集成友盟推送
    //    set AppKey and LaunchOptions
    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];
    [self addUMessage];
    [UMessage setAutoAlert:NO];
    [UMessage setLogEnabled:YES];
     
    //跳转下个页面
    [self jumpNextVC];
    
    return YES;
}

#pragma mark 集成友盟推送
- (void)addUMessage
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        //register remoteNotification types
        UIMutableUserNotificationAction* action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title = @"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground; //当点击的时候启动程序
        
        UIMutableUserNotificationAction* action2 = [[UIMutableUserNotificationAction alloc] init]; //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title = @"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground; //当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES; //需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory* categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1"; //这组动作的唯一标示
        [categorys setActions:@[ action1, action2 ] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings* userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    }
    else {
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         | UIRemoteNotificationTypeSound
         | UIRemoteNotificationTypeAlert];
    }
    [UMessage setLogEnabled:YES];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    NSString* deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                 stringByReplacingOccurrencesOfString:@">"
                                 withString:@""]
                                stringByReplacingOccurrencesOfString:@" "
                                withString:@""];
    [ProjectUtil saveUMengDeviceToken:deviceTokenStr];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    [ProjectUtil showLog:@"notierror:%@", error];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    if (application.applicationState == UIApplicationStateActive) {
        _jumpUrl = userInfo[@"url"];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:userInfo[@"title"] message:userInfo[@"text"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去查看", nil];
        alertView.tag = UrlJumpAlertTag;
        [alertView show];
    }
    else {
        [self dealWithUrl:userInfo[@"url"]];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}




#pragma mark 设置app样式
-(void)setAPPStyle {
    [[UINavigationBar appearance] setBackgroundImage:[ProjectUtil creatUIImageWithColor:NavigationBarColor Size:CGSizeMake(1.0f, 1.0f)] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[ProjectUtil creatUIImageWithColor:DefaultLightGrayTextColor Size:CGSizeMake(1.0f, 0.2f)]];
    
    //返回按钮样式
    UIImage* image = [[UIImage imageNamed:@"nav_back_default"]
                      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 17, 0, 0)];
    
    
    [[UIBarButtonItem appearance]
     setBackButtonBackgroundImage:image
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                                      NSFontAttributeName : BOLDFONT(18),
                                                                      NSForegroundColorAttributeName : [UIColor blackColor]
                                                                      }];
    
    [[UIBarButtonItem appearance]
     setBackButtonTitlePositionAdjustment:UIOffsetMake(-10000,
                                                       0)
     forBarMetrics:UIBarMetricsDefault];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

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
        [ProjectUtil removeLoginInfo];
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
    
    [YMWebClient syncLocalDicWithParams:params Success:^(YMNomalResponse *response)
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

#pragma mark 跳转下级页面
- (void)jumpNextVC
{
    //判断是否第一次启动
    BOOL isNotFirstStart =
    [[NSUserDefaults standardUserDefaults] boolForKey:@"isNotFirstStart"];
    UIStoryboard* mainStoryboard =
    [UIStoryboard storyboardWithName:@"Main"
                              bundle:nil];
    
    if (isNotFirstStart) {
        self.window.rootViewController = [mainStoryboard
                                          instantiateViewControllerWithIdentifier:@"StartAdViewController"];
    }
    else {
        self.window.rootViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"GuideViewController"];
    }
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
        alertView.tag = UpdateAlertTag;
        [alertView show];
        _alertShow = YES;
    }
}

#pragma mark 处理协议
- (void)dealWithUrl:(NSString*)url
{

    UINavigationController *naVC = (UINavigationController *)self.window.rootViewController;
    if (![self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    }
    if ([url hasPrefix:@"http"]) {
        if ([url rangeOfString:@"/chome"].length>0) {
            if (![naVC.topViewController isKindOfClass:[HomeViewController class]]) {
                [naVC popToRootViewControllerAnimated:YES];
            }
        }
        else if ([url rangeOfString:@"/jobManager"].length>0) {
            JobsManagerViewController *nextVC = [[JobsManagerViewController alloc]init];
            nextVC.title = @"职位管理";
            YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
            if (loginInfo.checkStatus==2) {
                nextVC.cellType = JobManagerListCellTypeRecruiting;
            }
            else {
                nextVC.cellType = JobManagerListCellTypeChecking;
            }
            [naVC pushViewController:nextVC animated:YES];
        }
        else if ([url rangeOfString:@"/reportManager"].length>0) {
            
        }
        else if ([url rangeOfString:@"/evaluateInfo"].length>0) {
            HasEvaluateViewController *nextVC = [[HasEvaluateViewController alloc] init];
            NSString *paramsStr = [[url componentsSeparatedByString:@"/"] lastObject];
            NSArray *params = [paramsStr componentsSeparatedByString:@","];
            nextVC.title = @"工作评价";
            nextVC.jobId = [params[0] integerValue];
            nextVC.stuId = [params[1] integerValue];
            nextVC.regiId = [params[2] integerValue];
            [naVC pushViewController:nextVC animated:YES];
        }
        else if ([url rangeOfString:@"/cmessage"].length>0) {
            MessageManagerViewController *nextVC = [[MessageManagerViewController alloc]init];
            nextVC.title = @"消息管理";
            [naVC pushViewController:nextVC animated:YES];
        }
        else if ([url rangeOfString:@"itunes.apple.com"].length > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        else {
            ModelWebViewController* nextVC = [[ModelWebViewController alloc]
                                              initWithURL:[NSURL URLWithString:url]];
            nextVC.title = @"一米兼职";
            nextVC.hidesBottomBarWhenPushed = YES;
            [naVC pushViewController:nextVC animated:YES];
        }

    }
    else {
        [self.window showFailHintWith:@"不支持的跳转链接"];
    }
    
}

#pragma mark alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == UpdateAlertTag) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self exitApplication];
        }
        else {
            
            BOOL bUpdate = [[UIApplication sharedApplication]
                            openURL:[NSURL URLWithString:_updateUrl]];
            if (!bUpdate) {
                [self.window showFailHintWith:@"升级地址错误"];
            }
        }
    }
    else if (alertView.tag == UrlJumpAlertTag) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self dealWithUrl:_jumpUrl];
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"]integerValue]==9000)
            {
                [self.window showSuccessHintWith:@"充值成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:ChargeSuccessNotification object:nil];
            }
            else
            {
                [self.window showFailHintWith:resultDic[@"memo"]];
            }
            
        }];
    }
    return YES;
}


@end
