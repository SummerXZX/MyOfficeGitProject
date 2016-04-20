//
//  AppConfig.h
//  NewYMOCCorpProject
//
//  Created by test on 15/12/31.
//  Copyright © 2015年 yimi. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h



// 客户端外部测试默认配置地址
#define REQUEST_SERVER_URL @"http://121.41.87.221"
#define REQUEST_IMAGE_URL @"http://1mjzt.oss-cn-hangzhou.aliyuncs.com"

// 客户端本地测试默认配置地址
//#define REQUEST_SERVER_URL @"http://192.168.100.98:8080"
//#define REQUEST_IMAGE_URL @"http://1mjzt.oss-cn-hangzhou.aliyuncs.com"

// 客户端本地测试默认配置地址
//#define REQUEST_SERVER_URL @"http://10.1.1.243:8080"
//#define REQUEST_IMAGE_URL   @"http://10.1.1.221:8080"

// 客户端生产默认配置地址
//#define REQUEST_SERVER_URL @"http://www.1mjz.com"
//#define REQUEST_IMAGE_URL @"http://cdn.1mjz.com"


// 友盟key
#define UMENG_APPKEY  @"556d519067e58eed09004bbf"

//默认请求数据Size
#define DATASIZE 10
#define SendIdentityCodeTime 60


#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define HEXCOLOR(hexColor)  [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1]

#define FONT(size) [UIFont systemFontOfSize:size]
#define BOLDFONT(size) [UIFont boldSystemFontOfSize:size]

//常用颜色
#define NavigationBarColor RGBCOLOR(255, 255, 255)
#define DefaultGrayTextColor RGBCOLOR(102,102,102)
#define DefaultBackGroundColor RGBCOLOR(240,240,240)
#define DefaultBlueTextColor RGBCOLOR(0,186,255)
#define DefaultLightGrayTextColor RGBCOLOR(200,200,200)
#define DefaultOrangeColor RGBCOLOR(255, 122, 1)
#define DefaultUnTouchButtonColor HEXCOLOR (0x999999)
#define DefaultPlaceholderColor HEXCOLOR (0xcccccc)
#define DefaultFailTitleTextColor HEXCOLOR (0x666666)
#define DefaultFailDetailTextColor HEXCOLOR (0x999999)
#define DefaultFailButtonTextColor HEXCOLOR (0x333333)
#define DefaultFailBackColor HEXCOLOR (0xffffff)
#define SEX_MAN_COLOR HEXCOLOR(0x5ec3e7)
#define SEX_WOMEN_COLOR HEXCOLOR(0xb690fd)

#pragma mark 字符
//提示
#define HintWithNetError @"亲，你的网络不给力哦！"
#define HintWithNetTimeOut @"亲，你的网络超时了！"
#define HintWithNoData @"亲，没有你想要的数据哦！"
#define HintWithListNetErrorTitle @"加载失败"
#define HintWithListNetErrorDetail @"请检查网络设置"
#define HintWithListReload @"重新加载"

//通知
#define GetSelectedCityNotification @"GetSelectedCityNotification"
#define ChargeSuccessNotification @"ChargeSuccessNotification"


//其它
#define CustomerServicePhone  @"400-0458091"


#endif /* AppConfig_h */
