//
//  WebServiceClient.h
//  WuHanConstructProject
//
//  Created by test on 15/10/27.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebNomalResponse.h"
#import "WebLoginResponse.h"
#import "WebHomeBookListResponse.h"

typedef void (^FailResponse)(NSError* error);
typedef void (^SuccessResponse)(id response);

@interface WebServiceClient : NSObject

/**
 *  登陆接口
 *
 *  @param params  name，pwd
 *  @param success
 *  @param fail
 */
+(void)loginWithParams:(NSDictionary *)params
               success:(void (^)(WebLoginResponse *response))success
                  Fail:(FailResponse)fail;

/**
 *  获取首页书本列表
 *
 *  @param success
 *  @param fail
 */
+(void)getHomeBookListWithParams:(NSDictionary *)params
                         success:(void (^)(WebHomeBookListResponse *response))success
                         Fail:(FailResponse)fail;

/**
 *  下载书本信息
 *
 *  @param params  gradeId
 *  @param success
 *  @param fail
 */
+(void)downloadBookInfoWithParams:(NSDictionary *)params
                          success:(void (^)(WebNomalResponse *response))success
                             Fail:(FailResponse)fail;

/**
 *  更新用户信息
 *
 *  @param params  name,school,grade,classname,realName
 *  @param success
 *  @param fail
 */
+(void)updateUserInfoWithParams:(NSDictionary *)params
                        success:(void (^)(WebNomalResponse *response))success
                           Fail:(FailResponse)fail;

/**
 *  修改用户登陆密码
 *
 *  @param params  uid,oldPwd,newPwd
 *  @param success
 *  @param fail
 */
+(void)changeLoginPassWithParams:(NSDictionary *)params
                         success:(void (^)(WebNomalResponse *response))success
                            Fail:(FailResponse)fail;

/**
 *  意见反馈
 *
 *  @param params  uid,content
 *  @param success
 *  @param fail
 */
+(void)feedbackWithParams:(NSDictionary *)params
                  success:(void (^)(WebNomalResponse *response))success
                     Fail:(FailResponse)fail;

@end
