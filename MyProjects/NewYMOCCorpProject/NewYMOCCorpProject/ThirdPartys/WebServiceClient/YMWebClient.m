//
//  YMWebClient.m
//  NewYMOCCorpProject
//
//  Created by test on 15/12/31.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "YMWebClient.h"

#import <AFNetworking.h>
#import <MJExtension.h>

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodUploadImage
};


@implementation YMWebClient

#pragma mark 同步本地字典
+(void)syncLocalDicWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodPOST PathString:@"/api/v2/mobile/corp/dict/sync" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 登录接口
+(void)loginWithParams:(NSDictionary *)params Success:(void (^)(YMLoginResponse *))success
{
    
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/login" Params:params MapClassName:@"YMLoginResponse" Success:success];
}

#pragma mark 获取验证码接口
+(void)getRegistCaptchaWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success
{
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/captcha" Params:params MapClassName:@"YMNomalResponse" Success:success];
}


#pragma mark 注册接口
+(void)registWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success
{
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/regist" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 忘记密码接口
+(void)forgetPassWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success
{
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/loginpassword/getback" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 修改密码接口
+(void)changePassWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/loginpassword/update" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 获取商家信息
+(void)getCorpInfoSuccess:(void (^)(YMCorpInfoResponse *))success
{
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/info/detail" Params:nil MapClassName:@"YMCorpInfoResponse" Success:success];
}

#pragma mark 更新商家信息
+(void)updateCorpInfoWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodPOST PathString:@"/api/v2/mobile/corp/info/update" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 上传商家logo
+(void)updateCorpLogoWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
     [YMWebClient requestWithMethod:RequestMethodUploadImage PathString:@"/api/v2/mobile/corp/logo/update" Params:params MapClassName:@"YMNomalResponse" Success:success];
    
}

#pragma mark 获取商家是否认证
+(void)getCheckStatusSuccess:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/checkstatus" Params:nil MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 提交认证
+(void)postCheckWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodUploadImage PathString:@"/api/v2/mobile/corp/info/check" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 查询余额接口
+(void)checkBalanceWithSuccess:(void (^)(YMNomalResponse *))success
{
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/account/balance" Params:nil MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 提交意见反馈接口
+(void)feedbackWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodPOST PathString:@"/api/v2/mobile/corp/feedback/insert" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 获取钱包账单
+(void)getBillRecordWithParams:(NSDictionary *)params Success:(void (^)(YMBillListResponse *))success {
    
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/account/change/list" Params:params MapClassName:@"YMBillListResponse" Success:success];
    
}

#pragma mark 获取支付宝支付订单号
+(void)getChargeOrderNumWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/account/recharge" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 发布职位接口
+(void)postJobWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodPOST PathString:@"/api/v2/mobile/corp/job/publish" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 更新职位信息接口
+(void)updateJobWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
     [YMWebClient requestWithMethod:RequestMethodPOST PathString:@"/api/v2/mobile/corp/job/update" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 获取职位信息详情
+(void)getJobDetailInfoWithParams:(NSDictionary *)params Success:(void (^)(YMJobDetailResponse *))success {
     [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/job/detail" Params:params MapClassName:@"YMJobDetailResponse" Success:success];
}

#pragma mark 获取职位列表
+(void)getJobListWithParams:(NSDictionary *)params Success:(void (^)(YMJobListResponse *))success {
     [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/job/list" Params:params MapClassName:@"YMJobListResponse" Success:success];
}

#pragma mark 职位停招
+(void)stopJobWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
     [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/job/stop" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 获取历史职位
+(void)getHistoryJobSuccess:(void (^)(YMHistoryJobResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/job/history" Params:nil MapClassName:@"YMHistoryJobResponse" Success:success];
}

#pragma mark 获取报名列表
+(void)getReportListWithParams:(NSDictionary *)params Success:(void (^)(YMReportListResponse *))success {
    if ([params[@"type"] integerValue]!=3) {
          [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/job/regi/list" Params:params MapClassName:@"YMReportListResponse" Success:success];
    }
    else {
        [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/job/regi/order/notpay/list" Params:params MapClassName:@"YMReportListResponse" Success:success];
    }
  }

#pragma mark 录用学生
+(void)hireWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/job/regi/use" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 拒绝学生
+(void)refuseWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/job/regi/refuse" Params:params MapClassName:@"YMNomalResponse" Success:success];

}

#pragma mark 支付
+(void)payWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodPOST PathString:@"/api/v2/mobile/corp/job/regi/order/pay" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 未上岗
+(void)unWorkWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/job/regi/order/notwork" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 评价
+(void)evaluateWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodPOST PathString:@"/api/v2/mobile/corp/evaluate/insert" Params:params MapClassName:@"YMNomalResponse" Success:success];
}



#pragma mark 获取员工详情
+(void)getStaffDetailWithParams:(NSDictionary *)params Success:(void (^)(YMStaffDetailResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/stu/resume" Params:params MapClassName:@"YMStaffDetailResponse" Success:success];
}

#pragma mark 获取评论列表
+(void)getAllEvaluateListWithParams:(NSDictionary *)params Success:(void (^)(YMAllEvaluateListResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/evaluate/item" Params:params MapClassName:@"YMAllEvaluateListResponse" Success:success];
}

#pragma mark 获取对该学生的评论信息
+(void)getMyEvaluateInfoWithParams:(NSDictionary *)params Success:(void (^)(YMMyEvaluateInfoResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/evaluate/info" Params:params MapClassName:@"YMMyEvaluateInfoResponse" Success:success];
}

#pragma mark 获取消息列表
+(void)getNewsListWithParams:(NSDictionary *)params Success:(void (^)(YMNewsListResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET
                        PathString:@"/api/v2/mobile/corp/message/list"
                            Params:params
                      MapClassName:@"YMNewsListResponse"
                           Success:success
     ];
}

#pragma mark 标记消息已读
+(void)markerNewIsReadWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success {
    [YMWebClient requestWithMethod:RequestMethodGET PathString:@"/api/v2/mobile/corp/message/read" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 公共发送请求方法
+ (void)requestWithMethod:(RequestMethod)method
               PathString:(NSString*)path
                   Params:(NSDictionary*)params
             MapClassName:(NSString*)mapClass
                  Success:(SuccessResponse)success
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    if (method!=RequestMethodUploadImage) {
        manager.requestSerializer.timeoutInterval = 6;
    }
    else {
        manager.requestSerializer.timeoutInterval = 60;
    }
    [manager.requestSerializer setValue:[ProjectUtil getCurrentAppVersion]
                     forHTTPHeaderField:@"access_version"];
    [manager.requestSerializer setValue:[ProjectUtil getToken]
                     forHTTPHeaderField:@"access_token"];
    [manager.requestSerializer setValue:[ProjectUtil getUMengDeviceToken]
                     forHTTPHeaderField:@"um_device_token"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",REQUEST_SERVER_URL,path];
    
    [ProjectUtil showLog:@"requestHeaders:%@\nrequestUrl:%@\nparams:%@",
     manager.requestSerializer.HTTPRequestHeaders, urlStr,
     params];
    
    if (![UIApplication sharedApplication].networkActivityIndicatorVisible) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    if (method == RequestMethodGET) {
        [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [YMWebClient dealWithSuccessResponse:responseObject Path:path MapClassName:mapClass Success:success];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ProjectUtil showLog:@"%@---error:%@", path, error];
            [YMWebClient dealWithFailResponse:error Success:success];
            
        }];
        
    }
    else if (method == RequestMethodPOST) {
        
        [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [YMWebClient dealWithSuccessResponse:responseObject Path:path MapClassName:mapClass Success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ProjectUtil showLog:@"%@---error:%@", path, error];
            [YMWebClient dealWithFailResponse:error Success:success];
            
        }];
        
    }
    else if (method == RequestMethodUploadImage) {
        
        [manager POST:urlStr parameters:params[@"params"] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (NSDictionary *photo in params[@"photos"]) {
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(photo[@"image"], 1.0)
                                                name:photo[@"name"]
                                            fileName:photo[@"fileName"]
                                            mimeType:photo[@"mimeType"]];
            }
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [YMWebClient dealWithSuccessResponse:responseObject Path:path MapClassName:mapClass Success:success];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [ProjectUtil showLog:@"%@---error:%@", path, error];
            [YMWebClient dealWithFailResponse:error Success:success];
        }];
    }
}


#pragma mark 处理请求成功返回数据
+ (void)dealWithSuccessResponse:(NSData *)responseData
                           Path:(NSString *)path
                   MapClassName:(NSString *)mapClass
                        Success:(SuccessResponse)success
{
    [[UIApplication sharedApplication]
     setNetworkActivityIndicatorVisible:NO];
#ifdef DEBUG
    [ProjectUtil showLog:@"%@---responseJson:%@",path,[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]];
#endif
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    [ProjectUtil showLog:@"%@---responseObject:%@", path, responseObject];
    
    SuccessResponse finalSuccess = [success copy];
    if (finalSuccess) {
        if ([responseObject[@"code"] intValue] == ERROR_NOT_SUPPORT) {
            mapClass  = @"YMNomalResponse";
        }
        finalSuccess([NSClassFromString(mapClass) mj_objectWithKeyValues:responseObject]);
    }
}

#pragma mark 处理请求失败返回数据
+ (void)dealWithFailResponse:(NSError *)error
                     Success:(SuccessResponse)success
{
    [[UIApplication sharedApplication]
     setNetworkActivityIndicatorVisible:NO];
    SuccessResponse finalSuccess = [success copy];
    if (finalSuccess) {
        
        NSMutableDictionary *responseObject = [NSMutableDictionary dictionaryWithObject:@(error.code) forKey:@"code"];
        if (error.code==NSURLErrorTimedOut) {
            [responseObject setObject:HintWithNetTimeOut forKey:@"codeInfo"];
        }
        else {
            [responseObject setObject:HintWithNetError forKey:@"codeInfo"];
        }
        finalSuccess([NSClassFromString(@"YMNomalResponse") mj_objectWithKeyValues:responseObject]);
    }
}


@end
