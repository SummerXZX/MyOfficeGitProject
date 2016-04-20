//
//  YMWebClient.h
//  NewYMOCCorpProject
//
//  Created by test on 15/12/31.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMNomalResponse.h"
#import "YMLoginResponse.h"
#import "YMCorpInfoResponse.h"
#import "YMBillListResponse.h"
#import "YMJobDetailResponse.h"
#import "YMJobListResponse.h"
#import "YMHistoryJobResponse.h"
#import "YMReportListResponse.h"
#import "YMStaffDetailResponse.h"
#import "YMAllEvaluateListResponse.h"
#import "YMMyEvaluateInfoResponse.h"
#import "YMNewsListResponse.h"

@interface YMWebClient : NSObject

typedef void (^SuccessResponse)(id response);

/**
 *  同步本地字典
 */
+(void)syncLocalDicWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  登录接口
 */
+(void)loginWithParams:(NSDictionary *)params Success:(void(^)(YMLoginResponse *response))success;

/**
 *  获取验证码接口
 */
+(void)getRegistCaptchaWithParams:(NSDictionary *)params Success:(void (^) (YMNomalResponse *response))success;

/**
 *  注册接口
 */
+(void)registWithParams:(NSDictionary *)params Success:(void (^) (YMNomalResponse *response))success;

/**
 *  忘记密码接口
 */
+(void)forgetPassWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  修改密码接口
 */
+(void)changePassWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  获取商家信息
 */
+(void)getCorpInfoSuccess:(void(^)(YMCorpInfoResponse *response))success;

/**
 *  更新商家信息
 */
+(void)updateCorpInfoWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  上传商家logo
 *
 *  @param params
 *  @param success
 */
+(void)updateCorpLogoWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  获取商家是否认证
 */
+(void)getCheckStatusSuccess:(void(^)(YMNomalResponse *response))success ;

/**
 *  提交认证 注：所有上传图片，默认传递：params:除图片文件外参数,photos:图片字典{data:图片文件，name,fileName,mimeType}
 */
+(void)postCheckWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  查询余额接口
 */
+(void)checkBalanceWithSuccess:(void(^)(YMNomalResponse *response))success ;

/**
 *  提交意见反馈接口
 */
+(void)feedbackWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  获取钱包账单
 *
 *  @param params  pageSize, pageNum, type
 *  @param success
 */
+(void)getBillRecordWithParams:(NSDictionary *)params Success:(void(^)(YMBillListResponse *response))success;

/**
 *  获取支付宝支付订单号
 *
 *  @param params
 *  @param success
 */
+(void)getChargeOrderNumWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  发布职位接口
 *
 *  @param params  data
 *  @param success
 */
+(void)postJobWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;
/**
 *  更新职位信息接口
 *
 *  @param params  data,id
 *  @param success
 */
+(void)updateJobWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;
/**
 *  获取职位信息详情
 *
 *  @param params  id
 *  @param success
 */
+(void)getJobDetailInfoWithParams:(NSDictionary *)params Success:(void(^)(YMJobDetailResponse *response))success;
/**
 *  获取职位列表
 *
 *  @param params type:1,未审核，2招聘中，3已结束,pageNum,pageSize
 *  @param success
 */
+(void)getJobListWithParams:(NSDictionary *)params Success:(void(^)(YMJobListResponse *response))success;
/**
 *  职位停招
 *
 *  @param params  id
 *  @param success
 */
+(void)stopJobWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;
/**
 *  获取历史职位
 *
 *  @param success
 */
+(void)getHistoryJobSuccess:(void(^)(YMHistoryJobResponse *response))success;

/**
 *  获取报名列表
 *
 *  @param params
 *  @param success
 */
+(void)getReportListWithParams:(NSDictionary *)params Success:(void(^)(YMReportListResponse *response))success;

/**
 *  录用学生
 *
 *  @param params  ids
 *  @param success
 */
+(void)hireWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  拒绝学生
 *
 *  @param params  id
 *  @param success
 */
+(void)refuseWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  支付
 *
 *  @param params payData，payType 0是线下支付，1是线上支付
 *  @param success
 */
+(void)payWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  未上岗
 *
 *  @param params
 *  @param success
 */
+(void)unWorkWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  评价
 *
 *  @param params
 *  @param success
 */
+(void)evaluateWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  获取员工详情
 *
 *  @param params
 *  @param success
 */
+(void)getStaffDetailWithParams:(NSDictionary *)params Success:(void(^)(YMStaffDetailResponse *response))success;

/**
 *  获取评论列表
 *
 *  @param params stuId
 *  @param success
 */
+(void)getAllEvaluateListWithParams:(NSDictionary *)params Success:(void(^)(YMAllEvaluateListResponse *response))success;

/**
 *  获取对该学生的评论信息
 *
 *  @param params stuId,corpId,jobId,regiId
 *  @param success
 */
+(void)getMyEvaluateInfoWithParams:(NSDictionary *)params Success:(void(^)(YMMyEvaluateInfoResponse *response))success;

/**
 *  标记消息已读
 *
 *  @param params
 *  @param success
 */
+(void)markerNewIsReadWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *  获取消息列表
 *
 *  @param params
 *  @param success
 */
+ (void)getNewsListWithParams:(NSDictionary*)params
                      Success:(void (^)(YMNewsListResponse* response))success;

@end
