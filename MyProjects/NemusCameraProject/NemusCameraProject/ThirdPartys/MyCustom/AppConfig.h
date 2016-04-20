//
//  AppConfig.h
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#ifndef YMCorporationIOS_AppConfig_h
#define YMCorporationIOS_AppConfig_h

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define FONT(size) [UIFont systemFontOfSize:size]
#define BOLDFONT(size) [UIFont boldSystemFontOfSize:size]


#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//常用颜色
#define NavigationBarColor RGBCOLOR(30, 128, 240)
#define DefaultBackGroundColor RGBCOLOR(37,37,37)


#pragma mark 字符
//提示

//通知

#endif
