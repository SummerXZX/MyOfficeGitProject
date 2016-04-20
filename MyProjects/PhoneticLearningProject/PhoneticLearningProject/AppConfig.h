//
//  AppConfig.h
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#ifndef YMCorporationIOS_AppConfig_h
#define YMCorporationIOS_AppConfig_h

// 客户端生产默认配置地址
#define REQUEST_SERVER_URL @"http://124.207.22.2:80"

typedef void(^ReturnObjectBlock)(id object);

//默认请求数据Size
#define DATASIZE 10
#define SendIdentityCodeTime 60
#define PASSMINLENGTH 1
#define PASSMAXLENGTH 10
#define PHONELENGTH 11


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define NavigationBarColor \
    [UIColor colorWithRed:32 / 255.0 green:203 / 255.0 blue:128 / 255.0 alpha:1]
#define DefaultBackGroundColor \
    [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1]
#define DefaultGrayTextColor \
    [UIColor colorWithRed:133 / 255.0 green:133 / 255.0 blue:133 / 255.0 alpha:1]
#define DefaultLightGrayTextColor \
    [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1]
#define DefaultBlueTextColor \
    [UIColor colorWithRed:0 / 255.0 green:186 / 255.0 blue:255 / 255.0 alpha:1]
#define DefaultUnTouchButtonColor \
[UIColor colorWithRed:152 / 255.0 green:227 / 255.0 blue:194 / 255.0 alpha:1]

#define TabBarViewControllerColor [UIColor whiteColor]

#define RGBCOLOR(r, g, b)              \
    [UIColor colorWithRed:(r) / 255.0f \
                    green:(g) / 255.0f \
                     blue:(b) / 255.0f \
                    alpha:1]
#define RGBACOLOR(r, g, b, a)          \
    [UIColor colorWithRed:(r) / 255.0f \
                    green:(g) / 255.0f \
                     blue:(b) / 255.0f \
                    alpha:(a)]

#define FONT(size) [UIFont systemFontOfSize:size]
#define BOLDFONT(size) [UIFont boldSystemFontOfSize:size]

#pragma mark 字符
//提示
#define HintWithNetError @"您的网络不太好，加载失败了！"
#define HintWithTimeOut @"您的网络不太好，请求超时了！"
#define HintWithNoData @"访问的此页面无数据哦！"

//通知

#endif
