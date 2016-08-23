//
//  AppConfig.h
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#ifndef YMCorporationIOS_AppConfig_h
#define YMCorporationIOS_AppConfig_h


#define REQUEST_SERVER_URL @"http://180.97.31.16:8008/"
#define REQUEST_IMG_URL @"http://180.97.31.16:8008/upload/img_logo/"
#define REQUEST_NOTIIMG_URL @"http://180.97.31.16:8008/upload/img_artwork/"

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define NavigationBarColor [UIColor colorWithRed:114/255.0 green:212/255.0 blue:255/255.0 alpha:1]
#define DefaultBackGroundColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define DefaultGrayTextColor [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1]
#define DefaultLightGrayTextColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]
#define DefaultBlueTextColor [UIColor colorWithRed:41/255.0 green:183/255.0 blue:245/255.0 alpha:1]
#define DefaultLineColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define DefaultStatusBlueColor [UIColor colorWithRed:101/255.0 green:202/255.0 blue:255/255.0 alpha:1]
#define DefaultStatusGrayColor [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1]
#define DefaultRedColor [UIColor colorWithRed:251/255.0 green:42/255.0 blue:46/255.0 alpha:1]


#define FONT(size) [UIFont systemFontOfSize:size]
#define BOLDFONT(size) [UIFont boldSystemFontOfSize:size]


#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//常用颜色
#define DATASIZE 10


#pragma mark 字符
//提示
#define HintWithNetError @"您的网络不给力哦！"
#define HintWithNetTimeOut @"您的网络超时了！"

//通知
#define HomeUpdataUINotification @"HomeUpdataUINotification"

#endif
