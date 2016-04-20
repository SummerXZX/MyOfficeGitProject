//
//  ProjectUtil.h
//  AnJieWealth
//
//  Created by zhipu on 14-8-28.
//  Copyright (c) 2014年 deayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *LoginInfoPhoneKey = @"loginPhone";//登录手机号保存key
static NSString* LoginInfoKey = @"loginInfo";//登录信息保存key

@interface ProjectUtil : NSObject

/*****************--------公共方法------*********************/
/**
 *打印log日志
 */
+(void)showLog:(NSString *)log,...;
/**
 *显示弹出框
 */
+(void)showAlert:(NSString *)title message:(NSString *)msg;


/**
 *根据日期获取时间戳
 */
+(NSString *)getTimeSpWithDate:(NSDate *)date;

/**
 *根据时间戳获取日期
 */
+(NSDate *)getDateWithTimeSp:(NSInteger)sp;
   
/**
 *将字符串转换成默认日期格式：yyyy-MM-dd
 */
+(NSString *)changeToDefaultDateStrWithSp:(NSInteger)sp;

/**
 *将字符串转换成默认日期格式：自定义分隔符例如--“/”
 */
+(NSString *)changeToSpDefaultDateStrWithSp:(NSInteger)sp SegmentSign:(NSString *)segmentSign;

/**
 *将字符串转换成标准的日期格式：yyyy-MM-dd HH:mm:ss
 */
+(NSString *)changeStandardDateStrWithSp:(NSInteger)sp;

/**
 *将字符串转换成中国日期
 */
+(NSString *)changeToChineseDateStrWithSp:(NSInteger)sp;

/**
 *获取当前APP版本信息
 */
+(NSString *)getCurrentAppVersion;

/**
 *根据字符串数组获取Label应加的高度
 */
+(CGFloat)getAddHeightWithStrArr:(NSArray *)strArr Font:(UIFont *)font LabelHeight:(CGFloat)height LabelWidth:(CGFloat)width;

/**
 *使用颜色创建图片
 */
+ (UIImage*)creatUIImageWithColor:(UIColor*)color;

//*****************--------特有方法------*********************

/**
 *  获取周几
 */
+(NSString *)getWeekDayStrWithTimeSp:(NSInteger)time;

/**
 *  根据TimeUnitId获取timeUnitStr
 */
+(NSString *)getWorkTimeUnitStrWithUnitId:(int)unitId;

/**
 * 根据isCheck获取职位状态字符串
 */
+(NSString *)getJobStatusStrWithIsCheck:(int)isCheck;
/**
 *  根据status获取订单状态字符串
 */
+(NSString *)getOrderStatusStrWithStatus:(int)status;

/**
 *  根据status获取充值状态字符串
 */
+(NSString *)getRechargeStatusStrWithStatus:(int)status;

/**
 *  根据status获取提现状态字符串
 */
+(NSString *)getWithdrawStatusStrWithStatus:(int)status;

/**
 * 保存登录信息
 */
+(void)saveLoginInfo:(YMLoginInfo *)data;

/**
 * 获取登录信息
 */
+(YMLoginInfo *)getLoginInfo;

/**
 * 保存商家信息
 */
+ (void)saveLoginCorpInfo:(YMCorpSummary *)data;

/**
 *获取商家信息
 */
+(YMCorpSummary *)getCorpInfo;

/**
 *  删除登录信息
 */
+(void)deleteLoginInfo;




/**
 *获取用户token
 */
+(NSString *)getUserToken;

/**
 *  获取当前设备上一次登录的手机号
 */
+ (NSString*)getLoginPhone;

/**
 *  储存登陆的手机号
 */
+ (void)saveLoginPhone:(NSString *)phone;

/**
 *是否完善信息
 */
+(BOOL)isCompleteCorpInfo;

/**
 *是否设置支付密码
 */
+(BOOL)isSetPayPwd;


@end

@interface CALayer (borderColor)

@property (nonatomic, strong) UIColor* borderUIColor; ///<边框颜色

@end

typedef NS_ENUM(NSInteger, SpecialStringType) {
    SpecialStringTypePhone, //手机号
    SpecialStringTypePhoneNumber, //数字0-9
    SpecialStringTypePassword, //密码
    SpecialStringTypeEmail //邮箱
};

@interface NSString (MyStringCategory)

/**
 *判断是否是特殊字符串格式
 */
- (BOOL)isType:(SpecialStringType)stringType;

/**
 *给当前字符串加下划线
 */
- (NSMutableAttributedString*)addUnderline;

/**
 *根据字体大小获取字符串size
 */
- (CGSize)getSizeWithFont:(UIFont*)font;

/**
 *根据字体大小和展示宽度获取字符串size
 */
- (CGSize)getSizeWithFont:(UIFont*)font Width:(CGFloat)width;

/**
 *转换成MD5字符串
 */
- (NSString*)changeToStringToMd5String;

@end

CGPoint CGRectGetCenter(CGRect rect);
CGRect CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void)moveBy:(CGPoint)delta;
- (void)scaleBy:(CGFloat)scaleFactor;
- (void)fitInSize:(CGSize)aSize;
@end


@interface UIView (Toast)
// each makeToast method creates a view and displays it as toast
- (void)makeToast:(NSString*)message;
- (void)makeToast:(NSString*)message
         duration:(CGFloat)interval
         position:(id)position;
- (void)makeToast:(NSString*)message
         duration:(CGFloat)interval
         position:(id)position
            title:(NSString*)title;
- (void)makeToast:(NSString*)message
         duration:(CGFloat)interval
         position:(id)position
            title:(NSString*)title
            image:(UIImage*)image;
- (void)makeToast:(NSString*)message
         duration:(CGFloat)interval
         position:(id)position
            image:(UIImage*)image;

// the showToast methods display any view as toast
- (void)showToast:(UIView*)toast;
- (void)showToast:(UIView*)toast duration:(CGFloat)interval position:(id)point;
// MBprogress
- (void)makeProgress:(NSString*)message;
- (void)hiddenProgress;
@end



