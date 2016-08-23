//
//  WebClient.h
//  WeiYuanQuan
//
//  Created by test on 16/3/18.
//  Copyright © 2016年 yimi. All rights reserved.
//


#import "WebNomalResponse.h"
#import "WebLoginResponse.h"
#import "WebHomeInfoResponse.h"
#import "WebContactListResponse.h"
#import "WebDepListResponse.h"
#import "WebDepContactListResponse.h"
#import "WebAnnounceListResponse.h"
#import "WebAnnounceDetailResponse.h"
#import "WebNoticeListResponse.h"
#import "WebNoticeDetailResponse.h"
#import "WebUploadPhotoParams.h"

typedef enum : NSUInteger {
    ResponseCodeSuceess = 1,///<访问成功
    ResponseCodeNetError = -1004,///<网络异常
} ResponseCode;

typedef void (^SuccessResponse)(id response);

@interface WebClient : NSObject

/**
 *  登录
 *
 *  @param params
 *  @param success
 */
+ (void)loginWithParams:(NSDictionary *)params Success:(void (^)(WebLoginResponse *response))success;

/**
 *  获取首页信息
 *
 *  @param params
 *  @param success
 */
+ (void)getHomeInfoWithParams:(NSDictionary *)params Success:(void (^)(WebHomeInfoResponse *response))success;

/**
 *  获取联系人列表
 *
 *  @param params
 *  @param success
 */
+ (void)getContactListWithParams:(NSDictionary *)params Success:(void (^)(WebContactListResponse *response))success;

/**
 *  获取部门列表
 *
 *  @param params
 *  @param success
 */
+ (void)getDepListWithParams:(NSDictionary *)params Success:(void (^)(WebDepListResponse *response))success;

/**
 *  获取部门人员列表
 *
 *  @param params
 *  @param success
 */
+ (void)getDepContactListWithParams:(NSDictionary *)params Success:(void (^)(WebDepContactListResponse *response))success;

/**
 *  获取人员信息
 *
 *  @param params  
 *  @param success
 */
+ (void)getContactDetailWithParams:(NSDictionary *)params Success:(void (^)(WebLoginResponse *response))success;

/**
 *  获取公告列表
 *
 *  @param params
 *  @param success
 */
+ (void)getAnnounceListWithParams:(NSDictionary *)params Success:(void (^)(WebAnnounceListResponse *response))success;

/**
 *  获取公告详情
 *
 *  @param params
 *  @param success
 */
+ (void)getAnnounceDetailWithParams:(NSDictionary *)params Success:(void (^)(WebAnnounceDetailResponse *response))success;

/**
 *  获取通知列表
 *
 *  @param params
 *  @param success
 */
+ (void)getNoticeListWithParams:(NSDictionary *)params Success:(void (^)(WebNoticeListResponse *response))success;

/**
 *  获取通知详情
 *
 *  @param params  
 *  @param success
 */
+ (void)getNoticeDetailWithParams:(NSDictionary *)params Success:(void (^)(WebNoticeDetailResponse *response))success;


@end
