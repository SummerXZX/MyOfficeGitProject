//
//  WebClient.m
//  WeiYuanQuan
//
//  Created by test on 16/3/18.
//  Copyright © 2016年 yimi. All rights reserved.
//



#import "WebClient.h"
#import <AFNetworking.h>
#import <MJExtension.h>

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
};


@implementation WebClient

#pragma mark 登录
+ (void)loginWithParams:(NSDictionary *)params Success:(void (^)(WebLoginResponse *))success {
    
    [WebClient requestWithMethod:RequestMethodGET PathString:@"io_doLogin.action" Params:params MapClassName:@"WebLoginResponse" Success:success];
}

#pragma mark 获取首页信息
+ (void)getHomeInfoWithParams:(NSDictionary *)params Success:(void (^)(WebHomeInfoResponse *))success {
    [WebClient requestWithMethod:RequestMethodGET PathString:@"io_getAllNumber.action" Params:params MapClassName:@"WebHomeInfoResponse" Success:success];
}

#pragma mark 获取联系人列表
+ (void)getContactListWithParams:(NSDictionary *)params Success:(void (^)(WebContactListResponse *))success {
    [WebClient requestWithMethod:RequestMethodGET PathString:@"io_getContacts.action" Params:params MapClassName:@"WebContactListResponse" Success:success];
}

#pragma mark 获取部门列表
+ (void)getDepListWithParams:(NSDictionary *)params Success:(void (^)(WebDepListResponse *))success {
    [WebClient requestWithMethod:RequestMethodGET PathString:@"io_getDptList.action" Params:params MapClassName:@"WebDepListResponse" Success:success];
}

#pragma mark 获取部门人员列表
+ (void)getDepContactListWithParams:(NSDictionary *)params Success:(void (^)(WebDepContactListResponse *))success {
    [WebClient requestWithMethod:RequestMethodGET PathString:@"io_getUserByDptCode.action" Params:params MapClassName:@"WebDepContactListResponse" Success:success];
}

#pragma mark 获取人员信息
+ (void)getContactDetailWithParams:(NSDictionary *)params Success:(void (^)(WebLoginResponse *))success {
    [WebClient requestWithMethod:RequestMethodGET PathString:@"io_getUserByCode.action" Params:params MapClassName:@"WebLoginResponse" Success:success];
}

#pragma makr 获取公告列表
+ (void)getAnnounceListWithParams:(NSDictionary *)params Success:(void (^)(WebAnnounceListResponse *))success {
    [WebClient requestWithMethod:RequestMethodGET PathString:@"io_getAfficheList.action" Params:params MapClassName:@"WebAnnounceListResponse" Success:success];
}

#pragma mark 获取公告详情
+ (void)getAnnounceDetailWithParams:(NSDictionary *)params Success:(void (^)(WebAnnounceDetailResponse *))success {
    [WebClient requestWithMethod:RequestMethodGET PathString:@"io_getAfficheByCode.action" Params:params MapClassName:@"WebAnnounceDetailResponse" Success:success];
}

#pragma mark 获取通知列表
+ (void)getNoticeListWithParams:(NSDictionary *)params Success:(void (^)(WebNoticeListResponse *))success {
    [WebClient requestWithMethod:RequestMethodGET PathString:@"io_getNoticeList.action" Params:params MapClassName:@"WebNoticeListResponse" Success:success];
}

#pragma mark 获取通知详情
+ (void)getNoticeDetailWithParams:(NSDictionary *)params Success:(void (^)(WebNoticeDetailResponse *))success {
    [WebClient requestWithMethod:RequestMethodGET PathString:@"io_getNoticeByCode.action" Params:params MapClassName:@"WebNoticeDetailResponse" Success:success];
}

#pragma mark 公共发送请求方法
+ (void)requestWithMethod:(RequestMethod)method
               PathString:(NSString*)path
                   Params:(id)params
             MapClassName:(NSString*)mapClass
                  Success:(SuccessResponse)success
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",REQUEST_SERVER_URL,path];
    
    [ProjectUtil showLog:@"requestHeaders:%@\nrequestUrl:%@\nparams:%@",
     manager.requestSerializer.HTTPRequestHeaders, urlStr,
     params];
    manager.requestSerializer.timeoutInterval = 10.0f;
    if (![UIApplication sharedApplication].networkActivityIndicatorVisible) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }

    switch (method) {
        case RequestMethodGET:
        {
            
            [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                [WebClient dealWithSuccessResponse:responseObject Path:path MapClassName:mapClass Success:success];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [ProjectUtil showLog:@"%@---error:%@", path, error];
                [WebClient dealWithFailResponse:error Success:success];
            }];
        }
            break;
        case RequestMethodPOST:
        {
            [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [WebClient dealWithSuccessResponse:responseObject Path:path MapClassName:mapClass Success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [ProjectUtil showLog:@"%@---error:%@", path, error];
                [WebClient dealWithFailResponse:error Success:success];
            }];
        }
            break;
        
        default:
            break;
    }
}

#pragma mark 上传图片的公共请求方法
+(void)requestUploadPhotosWithParams:(WebUploadPhotoParams *)params
                        PathString:(NSString*)path
                      MapClassName:(NSString*)mapClass
                           Progress:(void (^)(NSProgress *progress))progress
                           Success:(SuccessResponse)success{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",REQUEST_SERVER_URL,path];
    [ProjectUtil showLog:@"requestHeaders:%@\nrequestUrl:%@\nparams:%@",
     manager.requestSerializer.HTTPRequestHeaders, urlStr,
     params];
    
    manager.requestSerializer.timeoutInterval = 20.0f;
    if (![UIApplication sharedApplication].networkActivityIndicatorVisible) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    WebUploadPhotoParams *paramsInfo = (WebUploadPhotoParams *)params;
    [manager POST:urlStr parameters:paramsInfo.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (WebUploadPhotoInfo *info in paramsInfo.photos) {
            [formData appendPartWithFileData:info.imageData name:info.name fileName:info.fileName mimeType:info.mimeType];
        }
        
    } progress:^(NSProgress *uploadProgress) {
        
        if (progress) {
            progress (uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WebClient dealWithSuccessResponse:responseObject Path:path MapClassName:mapClass Success:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProjectUtil showLog:@"%@---error:%@", path, error];
        [WebClient dealWithFailResponse:error Success:success];
    }];
    
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
    NSString *jsonStr = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
//    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
//    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];

    [ProjectUtil showLog:@"%@---responseJson:%@",path,jsonStr];
#endif
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    [ProjectUtil showLog:@"%@---responseObject:%@", path, responseObject];
    
    SuccessResponse finalSuccess = [success copy];
    if (finalSuccess) {
       
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
        finalSuccess([NSClassFromString(@"WebNomalResponse") mj_objectWithKeyValues:responseObject]);
    }
}




@end
