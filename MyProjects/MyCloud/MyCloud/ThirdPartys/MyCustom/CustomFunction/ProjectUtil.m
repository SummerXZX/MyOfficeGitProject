//
//  ProjectUtil.m
//  AnJieWealth
//
//  Created by zhipu on 14-8-28.
//  Copyright (c) 2014年 deayou. All rights reserved.
//
// 是否输出日志

#import "ProjectUtil.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation ProjectUtil

#pragma mark 输出日志
+(void)showLog:(NSString *)log,...
{
	if (CGLOBAL_SHOW_LOG_FLAG)
    {
		va_list args;
		va_start(args,log);
		NSString *str = [[NSString alloc] initWithFormat:log arguments:args];
		va_end(args);
		NSLog(@" %@ ",str);
       
	}
}
#pragma mark 显示弹出框
+(void)showAlert:(NSString *)title message:(NSString *)msg {
    NSString *strAlertOK = NSLocalizedString(@"确定",nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:strAlertOK
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark 根据日期获取时间戳
+(NSString *)getTimeSpWithDate:(NSDate *)date
{
    return [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
}

#pragma mark 根据时间错获取日期
+(NSDate *)getDateWithTimeSp:(NSInteger)sp
{
    return [NSDate dateWithTimeIntervalSince1970:sp];
}

#pragma mark 将字符串转换成默认日期格式：yyyy-MM-dd
+(NSString *)changeToDefaultDateStrWithSp:(NSInteger)sp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

#pragma mark 将字符串转换成默认日期格式：自定义分隔符
+(NSString *)changeToSpDefaultDateStrWithSp:(NSInteger)sp SegmentSign:(NSString *)segmentSign
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",segmentSign,segmentSign]];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

#pragma mark 将字符串转换成标准的日期格式
+(NSString *)changeStandardDateStrWithSp:(NSInteger)sp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

#pragma mark 将字符串转换成中国日期
+(NSString *)changeToChineseDateStrWithSp:(NSInteger)sp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

#pragma mark 根据字符串数组获取Label应加的高度
+(CGFloat)getAddHeightWithStrArr:(NSArray *)strArr Font:(UIFont *)font LabelHeight:(CGFloat)height LabelWidth:(CGFloat)width
{
    CGFloat addHeight = 0.0;
    for (NSString *str in strArr)
    {
        CGFloat strHeight = [str getSizeWithFont:font Width:width].height;
        if (strHeight>height)
        {
            addHeight += strHeight-height;
        }
    }
    return addHeight;
}

#pragma mark 获取当前APP版本信息
+(NSString *)getCurrentAppVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
    return infoDic[@"CFBundleShortVersionString"];
}

#pragma mark 储存自定义类到userDefaults
+(void)storeCustomObj:(id)obj ToUserDefaultsWithKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodedObject forKey:key];
    [userDefaults synchronize];
}

#pragma 获取userDefaults储存的自定义类
+(id)getCustomObjFromUserDefaultsWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults objectForKey:key];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return obj;
}



@end
