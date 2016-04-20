//
//  ProjectUtil.h
//  AnJieWealth
//
//  Created by zhipu on 14-8-28.
//  Copyright (c) 2014年 deayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TableViewTypeNomal,///<普通
    TableViewTypeFullSeparator,///<分割线到头
} TableViewType;

typedef enum : NSUInteger {
    PostJobStatusPost=1,///<发布职位
    PostJobStatusEdit,///<编辑职位
    PostJobStatusDetail///<职位详情
} PostJobStatus;

typedef void(^GetDicSelectedResultBlock)(NSDictionary *selectedDic);

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
 * 根据时间戳和格式将字符串转换成日期 年：yyyy 月：MM 日：dd 时:HH 分：mm 秒：ss
 */
+ (NSString*)changeToDateWithSp:(NSInteger)sp Format:(NSString*)format;

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
 *  获取当前window
 */
+ (UIWindow *)getCurrentWindow;

/**
 *根据字符串数组获取Label应加的高度
 */
+(CGFloat)getAddHeightWithStrArr:(NSArray *)strArr Font:(UIFont *)font LabelHeight:(CGFloat)height LabelWidth:(CGFloat)width;

/**
 *使用颜色创建图片
 */
+ (UIImage*)creatUIImageWithColor:(UIColor*)color Size:(CGSize)size;


//*****************--------特有方法------*********************

/**
 *  保存友盟推送deviceToken
 */
+ (void)saveUMengDeviceToken:(NSString*)deviceToken;

/**
 *  获取友盟deviceToken
 */
+ (NSString *)getUMengDeviceToken;

/**
 * 保存登录信息
 */
+(void)saveLoginInfo:(YMLoginInfo *)data;

/**
 * 获取登录信息
 */
+(YMLoginInfo *)getLoginInfo;

/**
 *  获取当前用户token
 */
+ (NSString*)getToken;

/**
 * 删除登录信息
 */
+(void)removeLoginInfo;

/**
 *  获取当前设备上一次登录的手机号
 */
+ (NSString*)getLoginPhone;

/**
 *  储存登录的手机号
 */
+ (void)saveLoginPhone:(NSString *)phone;

/**
 *  获取完整的图片下载地址
 */
+ (NSString *)getWholeImageUrlWithResponseUrl:(NSString *)url;

/**
 *  获取默认的TableView
 */
+ (UITableView *)getDefaultTableViewWithType:(TableViewType)type;

/**
 *  插入默认橙色渐变背景
 */
+(void)insertOrangeGradientBackColorWithLayer:(CALayer *)layer Frame:(CGRect)frame;

/**
 *  获取签到类型字符串
 */
+(NSString *)getSignTypeStringWithSignType:(NSInteger)signType;

@end

@interface CALayer (borderColor)

@property (nonatomic, strong) UIColor* borderUIColor; ///<边框颜色

@end

typedef NS_ENUM(NSInteger, SpecialStringType) {
    SpecialStringTypePhone,///<手机号
    SpecialStringTypePhoneNumber,///<数字0-9
    SpecialStringTypePassword,///<密码
    SpecialStringTypeEmail,///<邮箱
    SpecialStringTypePayCount///<支付金额
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

@interface UIView (CustomHint)

/**
 *  显示等待层
 *
 *  @param progress 显示内容
 */
-(void)showProgressHintWith:(NSString *)hint;

/**
 *  显示成功提示层
 *
 *  @param hint 显示内容
 */
-(void)showSuccessHintWith:(NSString *)hint;

/**
 *  显示失败提示层
 *
 *  @param hint 显示内容
 */
-(void)showFailHintWith:(NSString *)hint;

/**
 *  消失方法
 */
-(void)dismissProgress;

@end




