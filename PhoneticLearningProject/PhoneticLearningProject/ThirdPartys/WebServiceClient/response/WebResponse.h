//
//  WebResponse.h
//  WuHanConstructProject
//
//  Created by test on 15/10/27.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WebErrorCodeOK = 1,///<请求成功
} WebErrorCode;


@interface WebResponse : NSObject

@property (nonatomic,strong) NSString *msg;///<返回描述

@property (nonatomic,assign) int code;///<返回码

@end
