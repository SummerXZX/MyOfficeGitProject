//
//  YMResponse.h
//  YMCorporation
//
//  Created by test on 15/6/2.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _ErrorCode {
    ERROR_OK = 200,
    ERROR_NOT_SUPPORT = 301,
    ERROR_UNAUTHORIZED = 302,
    ERROR_EXPIRED_TOKEN = 303,
    ERROR_INVALID_TOKEN = 304,
    ERROR_INTERNAL_ERROR = 305,
    ERROR_IP_REJECT = 406,
    ERROR_TIME_REJECT = 407,
    ERROR_GATEWAY_ERROR = 408,
    ERROR_CODE_ERROR = 409,
    ERROR_REGI_PHONE_ALREADY = 410,
    ERROR_REGI_NAME_ALREADY = 411,
    ERROR_LOGIN_ERROR = 412,
    ERROR_LOGINNAME_ERROR = 413,
    ERROR_PASSWORD_ERROR = 414,
    ERROR_REGI_ALREADY = 422,
    ERROR_CHECKIN_ALREADY = 423,
    ERROR_LIKE_ALREADY = 424,
    ERROR_INFO_ERROR = 430,
    ERROR_CORP_NAME_ERROR = 460,
    ERROR_CORP_LOGINNAME_ERROR = 461,
} ErrorCode;


@interface YMResponse : NSObject

@property (nonatomic,assign) int code;
@property (nonatomic,strong) NSString *codeInfo;
@property (nonatomic,assign) int dataId;

@end
