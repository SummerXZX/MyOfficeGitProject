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
 *根据时间错获取日期
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
 *储存自定义类到userDefaults
 */
+(void)storeCustomObj:(id)obj ToUserDefaultsWithKey:(NSString *)key;

/**
 *获取userDefaults储存的自定义类
 */
+(id)getCustomObjFromUserDefaultsWithKey:(NSString *)key;


@end
