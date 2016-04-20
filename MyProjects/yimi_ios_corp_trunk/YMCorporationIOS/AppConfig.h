//
//  AppConfig.h
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#ifndef YMCorporationIOS_AppConfig_h
#define YMCorporationIOS_AppConfig_h

// 客户端外部测试默认配置地址
//#define REQUEST_SERVER_URL @"http://121.41.87.221"
//#define REQUST_IMAGE_URL @"http://121.41.87.221"

// 客户端本地测试默认配置地址
#define REQUEST_SERVER_URL @"http://192.168.100.98:8080"
#define REQUST_IMAGE_URL @"http://192.168.100.98:8080"

// 客户端本地测试默认配置地址
//#define REQUEST_SERVER_URL @"http://10.1.1.221:8080"
//#define REQUST_IMAGE_URL   @"http://10.1.1.221:8080"

// 客户端生产默认配置地址
//#define REQUEST_SERVER_URL @"http://www.1mjz.com"
//#define REQUST_IMAGE_URL @"http://cdn.1mjz.com"


// 友盟key
#define UMENG_APPKEY  @"556d519067e58eed09004bbf"

//默认请求数据Size
#define DATASIZE 10
#define SendIdentityCodeTime 60


#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define NavigationBarColor [UIColor colorWithRed:84/255.0 green:192/255.0 blue:78/255.0 alpha:1]
#define DefaultButtonColor [UIColor colorWithRed:21/255.0 green:175/255.0 blue:241/255.0 alpha:1]
#define DefaultBackGroundColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define DefaultGrayTextColor [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1]
#define DefaultOrangeTextColor [UIColor colorWithRed:254/255.0 green:121/255.0 blue:30/255.0 alpha:1]
#define DefaultGreenTextColor [UIColor colorWithRed:102/255.0 green:197/255.0 blue:103/255.0 alpha:1]
#define DefaultRedTextColor [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#define DefaultLightGrayTextColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]
#define DefaultLineColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]

#define TabBarViewControllerColor [UIColor whiteColor]

#define HEXCOLOR(hexColor)  [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define Default_Font_12 [UIFont systemFontOfSize:12]
#define Default_Font_13 [UIFont systemFontOfSize:13]
#define Default_Font_14 [UIFont systemFontOfSize:14]
#define Default_Font_15 [UIFont systemFontOfSize:15]
#define Default_Font_16 [UIFont systemFontOfSize:16]
#define Default_Font_17 [UIFont systemFontOfSize:17]
#define Default_Font_18 [UIFont systemFontOfSize:18]
#define Default_Font_20 [UIFont systemFontOfSize:20]

#pragma mark 字符
//提示
#define HintWithNetError @"网络不给力哦"
#define HintWithNetTimeOut @"兼职君，你的网络超时了！"

//通知
#define JumpLoginNotification @"JumpLoginNotification"
#define JumpJobListNotification @"JumpJobListNotification"
#define JumpOrderListNotification @"JumpOrderListNotification"
#define JumpReportListNotification @"JumpReportListNotification"
#define ChargeSuccessNotification @"UpdateRechargeNotification"
#endif
