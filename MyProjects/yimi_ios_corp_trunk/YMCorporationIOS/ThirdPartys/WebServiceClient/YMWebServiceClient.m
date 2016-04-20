//
//  YMWebServiceClient.m
//  YimiJob
//
//  Created by test on 15/4/13.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YMWebServiceClient.h"
#import <AFNetworking.h>
#import <MJExtension.h>

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodUploadImage
};

@interface YMWebServiceClient ()

@end


@implementation YMWebServiceClient

#pragma mark 登陆接口
+(void)loginWithParams:(NSDictionary *)params Success:(void (^)(YMLoginResponse *))success 
{
   
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/login" Params:params MapClassName:@"YMLoginResponse" Success:success];
}

#pragma mark 注册获取验证码接口
+(void)getRegistCaptchaWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/captcha" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 注册接口
+(void)registWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/regist" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 忘记密码接口
+(void)forgetPassWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/update/loginpassword2" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 修改密码接口
+(void)changePassWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/update/loginpassword1" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 修改用户名 (此方法没有使用)
+(void)changeUserNameWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/update/loginname" Params:params MapClassName:@"YMNomalResponse" Success:success];
}



#pragma mark 获取本地字典
+(void)syncLocalDicWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/v1/api/mobile/corp/dict/sync" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 获取首页数据
+(void)getHomeInfoSuccess:(void (^)(YMHomeResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/summary" Params:nil MapClassName:@"YMHomeResponse" Success:success];
}

#pragma mark 发布职位
+(void)postJobWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/v1/api/mobile/corp/job/insert" Params:params MapClassName:@"YMNomalResponse" Success:success ];
}


#pragma mark 更新职位
+(void)updateJobWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/v1/api/mobile/corp/job/update" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 获取职位列表
+(void)getJobListWithParams:(NSDictionary *)params Success:(void (^)(YMJobListResponse *))success 
{
    [YMJobListData mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"list":@"YMJobSummary"};
    }];
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/list" Params:params MapClassName:@"YMJobListResponse" Success:success];
}

#pragma mark 获取职位详情
+(void)getJobDetailWithParams:(NSDictionary *)params Success:(void (^)(YMJobDetailResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/detail" Params:params MapClassName:@"YMJobDetailResponse" Success:success ];

}

#pragma mark 刷新职位
+(void)refreshJobWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/refresh" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 重新发布职位
+(void)repostJobWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/again" Params:params MapClassName:@"YMNomalResponse" Success:success];

}

#pragma mark 停招职位
+(void)stopJobWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/stop" Params:params MapClassName:@"YMNomalResponse" Success:success];

    
}

#pragma mark 获取待签约列表数据
+(void)getWaitInviteListWithParams:(NSDictionary *)params Success:(void (^)(YMWaitInviteListReponse *))success 
{
    [YMWaitInviteData mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"list":@"YMWaitInviteSummary"};
    }];
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/regi/asklist" Params:params MapClassName:@"YMWaitInviteListReponse" Success:success ];
}

#pragma mark 获取学生简历信息
+(void)getStuResumeWithParams:(NSDictionary *)params Success:(void (^)(YMStuResumeResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/stu/resume" Params:params MapClassName:@"YMStuResumeResponse" Success:success ];

}

#pragma mark 获取上岗订单数据
+(void)getWorkOrderListWithParams:(NSDictionary *)params Success:(void (^)(YMOrderResponse *))success 
{
    [YMOrderData mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"list":@"YMOrderSummary"};
    }];
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/regi/order/list" Params:params MapClassName:@"YMOrderResponse" Success:success ];


}

#pragma mark 获取职位的报名信息
+(void)getJobRegiListWithParams:(NSDictionary *)params Success:(void (^)(YMJobRegiResponse *))success 
{
    [YMJobRegiData mj_setupObjectClassInArray:^NSDictionary *{
       return @{@"list":@"YMJobRegiSummary"};
    }];
    [YMJobRegiSummary mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"jobRegiOrderList":@"YMJobRegiOrderSummary"};
    }];
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/regi/list" Params:params MapClassName:@"YMJobRegiResponse" Success:success ];
}

#pragma mark 获取当前开通城市列表
+(void)getCityListSuccess:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/city/list" Params:nil MapClassName:@"YMNomalResponse" Success:success];

}

#pragma mark 更新商家登录名
+(void)updateCorpLoginNameWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/update/loginname" Params:params MapClassName:@"YMNomalResponse" Success:success ];
}

#pragma mark 更新商家logo
+(void)updateCorpLogoWithImage:(UIImage *)image Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodUploadImage PathString:@"/v1/api/mobile/corp/update/logo" Params:@{@"photo":image} MapClassName:@"YMNomalResponse" Success:success ];
    
}

#pragma mark 获取商家信息
+(void)getCorpInfoSuccess:(void (^)(YMCorpInfoResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/material" Params:nil MapClassName:@"YMCorpInfoResponse" Success:success];
    
}

#pragma mark 更新商家信息
+(void)updateCorpInfoWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/v1/api/mobile/corp/update/corp" Params:params MapClassName:@"YMNomalResponse" Success:success ];
}

#pragma mark 获取是否完善商家信息
+(void)getIsCompleteCorpInfoSuccess:(void (^)(YMCompleteCorpInfoResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/ispublish" Params:nil MapClassName:@"YMCompleteCorpInfoResponse" Success:success ];
}

#pragma mark 支付订单
+(void)payOrderWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/regi/order/pay" Params:params MapClassName:@"YMNomalResponse" Success:success ];
}

#pragma mark 标记未上岗订单
+(void)markUnWorkOrderWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/regi/order/unsign" Params:params MapClassName:@"YMNomalResponse" Success:success ];
}

#pragma mark 取消订单
+(void)cancelOrderWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/regi/order/cancel" Params:params MapClassName:@"YMNomalResponse" Success:success ];
}

#pragma mark 邀约学生
+(void)inviteStuWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/v1/api/mobile/corp/job/regi/order/insert" Params:params MapClassName:@"YMNomalResponse" Success:success ];
}

#pragma mark 拒绝学生
+(void)refuserStuWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/job/regi/refuse" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 充值获取订单号
+(void)getChargeOrderNumWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/account/recharge" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 查询余额接口
+(void)checkBalanceWithSuccess:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/account/balance" Params:nil MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 获取提现账户信息
+(void)getWithdrawAcountInfoSuccess:(void (^)(YMBankResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/account/bank" Params:nil MapClassName:@"YMBankResponse" Success:success];
}

#pragma mark 获取充值记录
+(void)getRechargeRecordWithParams:(NSDictionary *)params Success:(void (^)(YMRechargeReponse *))success 
{
    [YMRechargeData mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"list":@"YMRechargeSummary"};
    }];
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/account/recharge/list" Params:params MapClassName:@"YMRechargeReponse" Success:success ];
}

#pragma mark 充值记录继续支付
+(void)rechargeRecordChargeWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/account/recharge/pay" Params:params MapClassName:@"YMNomalResponse" Success:success ];
}

#pragma mark 获取提现记录
+(void)getWithdrawRecordParams:(NSDictionary *)params Success:(void (^)(YMWithdrawResponse *))success 
{
    [YMWithdrawData mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"list":@"YMWithdrawSummary"};
    }];
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/account/withdraw/list" Params:params MapClassName:@"YMWithdrawResponse" Success:success];

}

#pragma mark 保存提现账户信息
+(void)saveWithdrawInfoWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/v1/api/mobile/corp/account/bank/save" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 提现操作
+(void)withdrawWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/v1/api/mobile/corp/account/withdraw" Params:params MapClassName:@"YMNomalResponse" Success:success ];
}

#pragma mark 上传身份证照片
+(void)uploadIdentityWithImage:(UIImage *)image Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodUploadImage PathString:@"/v1/api/mobile/corp/update/idnum" Params:@{@"photo":image} MapClassName:@"YMNomalResponse" Success:success ];

}

#pragma mark 上传营业执照照片
+(void)uploadBusinessWithImage:(UIImage *)image Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodUploadImage PathString:@"/v1/api/mobile/corp/update/businum" Params:@{@"photo":image} MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 意见反馈
+(void)feedbackWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/v1/api/mobile/corp/feedback/insert" Params:params MapClassName:@"YMNomalResponse" Success:success ];
}

#pragma mark 获取启动页广告图片
+(void)getStartAdWithSuccess:(void (^)(YMStartAdResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/apk/start" Params:nil MapClassName:@"YMStartAdResponse" Success:success];

}

#pragma mark 是否设置支付密码
+(void)isSetPayPwdWithSuccess:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/account/ispwd" Params:nil MapClassName:@"YMNomalResponse" Success:success];


}

#pragma mark 获取支付密码验证码
+(void)getPayPwdCaptchaWithSuccess:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/update/payPwd/captcha" Params:nil MapClassName:@"YMNomalResponse" Success:success ];
}

#pragma mark 设置支付密码
+(void)updatePayPwdWithParams:(NSDictionary *)params Success:(void (^)(YMNomalResponse *))success 
{
    [YMWebServiceClient requestWithMethod:RequestMethodGET PathString:@"/v1/api/mobile/corp/account/update/payPwd" Params:params MapClassName:@"YMNomalResponse" Success:success];
}

#pragma mark 公共发送请求方法
+ (void)requestWithMethod:(RequestMethod)method PathString:(NSString*)path Params:(NSDictionary *)params MapClassName:(NSString*)mapClass Success:(SuccessResponse)success 
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 6;
    [manager.requestSerializer setValue:[ProjectUtil getCurrentAppVersion] forHTTPHeaderField:@"access_version"];
    [manager.requestSerializer setValue:[ProjectUtil getUserToken] forHTTPHeaderField:@"access_token"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", REQUEST_SERVER_URL, path];
    
    [ProjectUtil showLog:@"requestHeaders:%@\nrequestUrl:%@\nparams:%@", manager.requestSerializer.HTTPRequestHeaders, urlStr, params];
    if (![UIApplication sharedApplication].networkActivityIndicatorVisible) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    if (method == RequestMethodGET) {
        [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            [ProjectUtil showLog:@"%@---responseObject:%@",path,responseObject];
            [YMWebServiceClient dealWithResponse:responseObject MapClassName:mapClass Success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[UIApplication sharedApplication]
             setNetworkActivityIndicatorVisible:NO];
            [ProjectUtil showLog:@"%@---error:%@", path, error];
            NSMutableDictionary *responseObject = [NSMutableDictionary dictionaryWithObject:@(error.code) forKey:@"code"];
            if (error.code==NSURLErrorTimedOut) {
                [responseObject setObject:HintWithNetTimeOut forKey:@"codeInfo"];
            }
            else {
                [responseObject setObject:HintWithNetError forKey:@"codeInfo"];
            }
            [YMWebServiceClient dealWithResponse:responseObject MapClassName:mapClass Success:success];
        }];
    }
    else if (method == RequestMethodPOST) {
        [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[UIApplication sharedApplication]
             setNetworkActivityIndicatorVisible:NO];
            [ProjectUtil showLog:@"%@---responseObject:%@", path, responseObject];
            [YMWebServiceClient dealWithResponse:responseObject MapClassName:mapClass Success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[UIApplication sharedApplication]
             setNetworkActivityIndicatorVisible:NO];
            [ProjectUtil showLog:@"%@---error:%@", path, error];
            NSMutableDictionary *responseObject = [NSMutableDictionary dictionaryWithObject:@(error.code) forKey:@"code"];
            if (error.code==NSURLErrorTimedOut) {
                [responseObject setObject:HintWithNetTimeOut forKey:@"codeInfo"];
            }
            else {
                [responseObject setObject:HintWithNetError forKey:@"codeInfo"];
            }
            [YMWebServiceClient dealWithResponse:responseObject MapClassName:mapClass Success:success];
        }];
           }
    else if (method == RequestMethodUploadImage) {
        [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            UIImage* photo = params[@"photo"];
            [formData appendPartWithFileData:UIImagePNGRepresentation(photo)
                                        name:@"article[image]" fileName:@"photo.png" mimeType:@"image/png"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[UIApplication sharedApplication]
             setNetworkActivityIndicatorVisible:NO];
            [ProjectUtil showLog:@"%@---responseObject:%@", path, responseObject];
            [YMWebServiceClient dealWithResponse:responseObject MapClassName:mapClass Success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[UIApplication sharedApplication]
             setNetworkActivityIndicatorVisible:NO];
            [ProjectUtil showLog:@"%@---error:%@", path, error];
            NSMutableDictionary *responseObject = [NSMutableDictionary dictionaryWithObject:@(error.code) forKey:@"code"];
            if (error.code==NSURLErrorTimedOut) {
                [responseObject setObject:HintWithNetTimeOut forKey:@"codeInfo"];
            }
            else {
                [responseObject setObject:HintWithNetError forKey:@"codeInfo"];
            }
            [YMWebServiceClient dealWithResponse:responseObject MapClassName:mapClass Success:success];
        }];
    }
}

#pragma mark 处理返回数据
+ (void)dealWithResponse:(id)responseObject
            MapClassName:(NSString*)mapClass
                 Success:(SuccessResponse)success
{
    if (mapClass) {
        if (success) {
            if ([responseObject[@"code"] intValue] == ERROR_NOT_SUPPORT) {
                mapClass  = @"YMNomalResponse";
            }
            success([NSClassFromString(mapClass) mj_objectWithKeyValues:responseObject]);
        }
    }
    else {
        success (responseObject);
    }
}


@end
