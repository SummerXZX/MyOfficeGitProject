//
//  NSString+StringTpye.m
//  SalesHelper_C
//
//  Created by summer on 14/10/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "NSString+StringTpye.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (StringTpye)

#pragma mark 给当前字符串加下划线
-(NSMutableAttributedString *)addUnderline
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    NSRange attributedRange = {0,[attributedString length]};
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:attributedRange];
    return attributedString;
}

#pragma mark 根据字体大小获取字符串size
-(CGSize)getSizeWithFont:(UIFont *)font
{
    CGSize size;
    
    size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    
    return size;
}

#pragma mark 根据字体大小和展示宽度获取字符串size
-(CGSize)getSizeWithFont:(UIFont *)font Width:(CGFloat)width
{
    CGSize size;
    CGSize constrainSize = CGSizeMake(width,2000);
    size = [self boundingRectWithSize:constrainSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return size;
}

#pragma mark 判断是否是特殊字符串格式
-(BOOL)isType:(SpecialStringType)stringType
{
    NSString *regex;
    if (stringType==SpecialStringTypePhone)
    {
        regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    }
   else  if (stringType==SpecialStringTypePhoneNumber)
    {
        regex = @"^[0-9]\\d*$";
    }
   else if (stringType==SpecialStringTypePassword)
    {
        regex = @"^[A-Za-z0-9]+$";
    }
    else if (stringType==SpecialStringTypeMoney)
    {
        regex = @"^\\d+(\\.\\d{1,2})?$";
    }
    else if (stringType==SpecialStringTypeEmail)
    {
        regex = @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

#pragma mark 转换成MD5字符串
-(NSString *)changeToStringToMd5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned)strlen(cStr), result);
    return [NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ];
}


#pragma mark 将日期字符串转换成日期：NSDate
-(NSDate *)changeToNSDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
   
    NSDate *date=[formatter dateFromString:self];
    return date;
}


@end
