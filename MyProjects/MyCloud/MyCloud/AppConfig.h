//
//  AppConfig.h
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#ifndef YMCorporationIOS_AppConfig_h
#define YMCorporationIOS_AppConfig_h
//应用的请求key
#define REQUEST_ConPass @"NorthCloud2015"

// 客户端生产默认配置地址
#define REQUEST_SERVER_URL @"http://180.97.31.16:8081/service.asmx/"

// 是否输出日志
#define CGLOBAL_SHOW_LOG_FLAG  NO

//默认请求数据Size
#define DATASIZE 10

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define NavigationBarColor [UIColor colorWithRed:114/255.0 green:212/255.0 blue:255/255.0 alpha:1]
#define DefaultBackGroundColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define DefaultGrayTextColor [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1]
#define DefaultLightGrayTextColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]
#define DefaultBlueTextColor [UIColor colorWithRed:41/255.0 green:183/255.0 blue:245/255.0 alpha:1]
#define DefaultLineColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define DefaultStatusBlueColor [UIColor colorWithRed:101/255.0 green:202/255.0 blue:255/255.0 alpha:1]
#define DefaultStatusGrayColor [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1]


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

//通知
#define HomeUpdataUINotification @"HomeUpdataUINotification"

#endif
