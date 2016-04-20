//
//  YMResponse.h
//  NewYMOCProject
//
//  Created by test on 15/8/31.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ErrorCode) {
    ERROR_OK = 200,///<成功请求
    ERROR_NOT_SUPPORT = 301, ///<版本不在支持
    ERROR_UNAUTHORIZED = 302, ///<拒绝访问
    ERROR_EXPIRED_TOKEN = 303, ///<token过期
    ERROR_INVALID_TOKEN = 304, ///<token无效
    ERROR_INTERNAL_ERROR = 305, ///<服务器内部错误
    ERROR_NSF = 20021,///<余额不足
    ERROR_NODATA = 100, ///<没有数据
    ERROR_ONLOADING = 101, ///<正在加载

};

@interface YMResponse : NSObject

@property (nonatomic, assign) NSInteger code; ///<返回码
@property (nonatomic, strong) NSString* codeInfo; ///<返回码解释
@property (nonatomic, assign) NSInteger dataId; ///<返回数据码

@end
