//
//  NSString+StringTpye.h
//  SalesHelper_C
//
//  Created by summer on 14/10/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define PhoneStringLength 11 //默认电话号码长度
#define PasswordStringMinLength 6//默认最小密码长度
#define PasswordStringMaxLength 20//默认最大密码长度
#define IdentityCodeMaxLength 4//默认验证码长度

typedef NS_ENUM(NSInteger, SpecialStringType)
{
    SpecialStringTypePhone,//手机号
    SpecialStringTypePhoneNumber,//数字0-9
    SpecialStringTypePassword,//密码
    SpecialStringTypeMoney,//金钱
    SpecialStringTypeEmail//邮箱
};

@interface NSString (StringTpye)

/**
 *给当前字符串加下划线
 */
-(NSMutableAttributedString *)addUnderline;

/**
 *根据字体大小获取字符串size
 */
-(CGSize)getSizeWithFont:(UIFont *)font;

/**
 *根据字体大小和展示宽度获取字符串size
 */
-(CGSize)getSizeWithFont:(UIFont *)font Width:(CGFloat)width;

/**
 *判断是否是特殊字符串格式
 */
-(BOOL)isType:(SpecialStringType)stringType;

/**
 *转换成MD5字符串
 */
-(NSString *)changeToStringToMd5String;

/**
 *将日期字符串转换成日期：NSDate
 */
-(NSDate *)changeToNSDate;


@end
