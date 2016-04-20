//
//  ProjectUtil.h
//  AnJieWealth
//
//  Created by zhipu on 14-8-28.
//  Copyright (c) 2014年 deayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProjectUtil : NSObject

/*****************--------公共方法------*********************/
/**
 * 打印log日志
 */
+ (void)showLog:(NSString*)log, ...;

/**
 *显示弹出框
 */
+ (void)showAlert:(NSString*)title message:(NSString*)msg;

/**
 * 根据日期获取时间戳
 */
+ (NSInteger)getTimeSpWithDate:(NSDate*)date;

/**
 * 根据时间戳获取日期
 */
+ (NSDate*)getDateWithTimeSp:(NSInteger)sp;

/**
 * 根据时间戳和格式将字符串转换成日期 年：yyyy 月：MM 日：dd 时:HH 分：mm 秒：ss
 */
+ (NSString*)changeToDateWithSp:(NSInteger)sp Format:(NSString*)format;

/**
 * 将字符串转换成默认日期格式：yyyy-MM-dd
 */
+ (NSString*)changeToDefaultDateStrWithSp:(NSInteger)sp;

/**
 * 将字符串转换成默认日期格式：自定义分隔符例如--“/”
 */
+ (NSString*)changeToDefaultDateStrWithSp:(NSInteger)sp
                              SegmentSign:(NSString*)segmentSign;

/**
 * 将字符串转换成标准的日期格式：yyyy-MM-dd HH:mm:ss
 */
+ (NSString*)changeStandardDateStrWithSp:(NSInteger)sp;

/**
 * 将字符串转换成中国日期：yyyy年 MM月 dd日
 */
+ (NSString*)changeToChineseDateStrWithSp:(NSInteger)sp;

/**
 * 获取当前APP版本信息
 */
+ (NSString*)getCurrentAppVersion;

/**
 *  获取设备唯一标识
 */
+ (NSString*)getDeviceId;

/**
 *  获取当前设备类型
 */
+ (NSString*)getDeviceModel;

/**
 *  获取当前window
 */
+ (UIWindow *)getCurrentWindow;

/**
 *根据字符串数组获取Label应加的高度
 */
+ (CGFloat)getAddHeightWithStrArr:(NSArray*)strArr
                             Font:(UIFont*)font
                      LabelHeight:(CGFloat)height
                       LabelWidth:(CGFloat)width;

/**
 *使用颜色创建图片
 */
+ (UIImage*)creatUIImageWithColor:(UIColor*)color;

//-----------------------特有方法-------------------------/

/**
 *  保存登陆数据
 *
 *  @param loginData
 */
+(void)saveLoginData:(WebLoginData *)loginData;

/**
 *  获取登陆数据
 *
 *  @return WebLoginData
 */
+(WebLoginData *)getLoginData;

/**
 *  清空登陆信息
 */
+(void)removeLoginData;

/**
 *  保存登陆名
 */
+(void)saveLoginName:(NSString *)loginName;

/**
 *  获取登陆名
 */
+(NSString *)getLoginName;


@end
//-----------------------自定义扩展、类别---------------------/

@interface CALayer (borderColor)

@property (nonatomic, strong) UIColor* borderUIColor; ///<边框颜色

@end

@interface NSString (MyStringCategory)

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
- (void)makeProgress:(NSString*)progress;
- (void)hiddenProgress;
@end

@interface UITextField (RecycleBtn)

/**
 *  添加"完成"按钮，回收键盘
 */
-(void)addRecycleBtn;

@end

