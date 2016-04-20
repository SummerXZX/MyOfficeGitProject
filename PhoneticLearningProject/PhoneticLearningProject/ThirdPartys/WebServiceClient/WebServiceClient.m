//
//  WebServiceClient.m
//  WuHanConstructProject
//
//  Created by test on 15/10/27.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "WebServiceClient.h"
#import <AFNetworking.h>
#import <MJExtension.h>

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,///<GET请求
    RequestMethodPOST,///<POST请求
    RequestMethodUploadImage///<上传图片请求
};

@implementation WebServiceClient

#pragma mark 登陆接口
+(void)loginWithParams:(NSDictionary *)params success:(void (^)(WebLoginResponse *))success Fail:(FailResponse)fail {
      [WebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/Login/valid.dhtml" Params:params MapClassName:@"WebLoginResponse" Success:success Fail:fail];
}

#pragma mark 获取首页书本列表
+(void)getHomeBookListWithParams:(NSDictionary *)params success:(void (^)(WebHomeBookListResponse *))success Fail:(FailResponse)fail {
    
    [WebHomeBookListData mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"data":@"HomeBookInfo"};
    }];
    [WebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/Index/main.dhtml" Params:params MapClassName:@"WebHomeBookListResponse" Success:success Fail:fail];
}

#pragma mark 下载书本信息
+(void)downloadBookInfoWithParams:(NSDictionary *)params success:(void (^)(WebNomalResponse *))success Fail:(FailResponse)fail {
    NSString* urlStr =
    [NSString stringWithFormat:@"%@/Index/indexXml.dhtml", REQUEST_SERVER_URL];
    [ProjectUtil showLog:@"url:%@\n params:%@",urlStr,params];
    AFHTTPRequestOperationManager* manager =
    [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 6;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (success) {
            WebNomalResponse *response = [[WebNomalResponse alloc]init];
            response.data = responseObject;
            success (response);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (fail) {
            fail (error);
        }
    }];
}

#pragma mark 更新用户信息
+(void)updateUserInfoWithParams:(NSDictionary *)params success:(void (^)(WebNomalResponse *))success Fail:(FailResponse)fail {
    [WebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/Account/modifyUser.dhtml" Params:params MapClassName:@"WebNomalResponse" Success:success Fail:fail];
}

#pragma mark 修改用户登陆密码
+(void)changeLoginPassWithParams:(NSDictionary *)params success:(void (^)(WebNomalResponse *))success Fail:(FailResponse)fail {
    [WebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/Account/modifyPwd.dhtml" Params:params MapClassName:@"WebNomalResponse" Success:success Fail:fail];
}

#pragma mark 意见反馈
+(void)feedbackWithParams:(NSDictionary *)params success:(void (^)(WebNomalResponse *))success Fail:(FailResponse)fail {
     [WebServiceClient requestWithMethod:RequestMethodPOST PathString:@"/Account/Feedback.dhtml" Params:params MapClassName:@"WebNomalResponse" Success:success Fail:fail];
}

#pragma mark 公共发送请求方法
+ (void)requestWithMethod:(RequestMethod)method
               PathString:(NSString*)path
                   Params:(NSDictionary*)params
             MapClassName:(NSString*)mapClass
                  Success:(SuccessResponse)success
                     Fail:(FailResponse)fail
{
    AFHTTPRequestOperationManager* manager =
    [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    manager.requestSerializer.timeoutInterval = 6;
  
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
          NSString* urlStr =
            [NSString stringWithFormat:@"%@%@", REQUEST_SERVER_URL, path];
    
    [ProjectUtil showLog:@"requestHeaders:%@\nrequestUrl:%@\nparams:%@",
     manager.requestSerializer.HTTPRequestHeaders, urlStr,
     params];
    if (![UIApplication sharedApplication].networkActivityIndicatorVisible) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    if (method == RequestMethodGET) {
        [manager GET:urlStr
          parameters:params
             success:^(AFHTTPRequestOperation* operation, id responseObject) {
                 [[UIApplication sharedApplication]
                  setNetworkActivityIndicatorVisible:NO];
                 [ProjectUtil showLog:@"%@---responseObject:%@", path, responseObject];
                 [WebServiceClient dealWithResponse:responseObject
                                  MapClassName:mapClass
                                       Success:success
                                          Fail:fail];
             }
             failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                 [[UIApplication sharedApplication]
                  setNetworkActivityIndicatorVisible:NO];
                 [ProjectUtil showLog:@"%@---error:%@", path, error];
                 if (fail) {
                     NSString *errorDomain;
                     if (error.code==NSURLErrorTimedOut) {
                         errorDomain = HintWithTimeOut;
                     }
                     else {
                         errorDomain = HintWithNetError;
                     }
                     fail([NSError errorWithDomain:errorDomain
                                              code:error.code
                                          userInfo:nil]);
                 }
                 
             }];
    }
    else if (method == RequestMethodPOST) {
        [manager POST:urlStr
           parameters:params
              success:^(AFHTTPRequestOperation* operation, id responseObject) {
                  [[UIApplication sharedApplication]
                   setNetworkActivityIndicatorVisible:NO];
                  [ProjectUtil showLog:@"%@---responseObject:%@", path, responseObject];
                  [WebServiceClient dealWithResponse:responseObject
                                   MapClassName:mapClass
                                        Success:success
                                           Fail:fail];
                  
              }
              failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                  [[UIApplication sharedApplication]
                   setNetworkActivityIndicatorVisible:NO];
                  [ProjectUtil showLog:@"%@---error:%@", path, error];
                  if (fail) {
                      
                      NSString *errorDomain;
                      if (error.code==NSURLErrorTimedOut) {
                          errorDomain = HintWithTimeOut;
                      }
                      else {
                          errorDomain = HintWithNetError;
                      }
                      fail([NSError errorWithDomain:errorDomain
                                               code:error.code
                                           userInfo:nil]);
                  }
              }];
    }
    else if (method == RequestMethodUploadImage) {
        [manager POST:urlStr
           parameters:@{
                        @"id" : params[@"id"]
                        }
constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
    UIImage* photo = params[@"photo"];
    [formData appendPartWithFileData:UIImagePNGRepresentation(photo)
                                name:@"article[image]"
                            fileName:@"photo.png"
                            mimeType:@"image/png"];
}
              success:^(AFHTTPRequestOperation* _Nonnull operation,
                        id _Nonnull responseObject) {
                  [[UIApplication sharedApplication]
                   setNetworkActivityIndicatorVisible:NO];
                  [ProjectUtil showLog:@"%@---responseObject:%@", path, responseObject];
                  [WebServiceClient dealWithResponse:responseObject
                                   MapClassName:mapClass
                                        Success:success
                                           Fail:fail];
              }
              failure:^(AFHTTPRequestOperation* _Nonnull operation,
                        NSError* _Nonnull error) {
                  [[UIApplication sharedApplication]
                   setNetworkActivityIndicatorVisible:NO];
                  [ProjectUtil showLog:@"%@---error:%@", path, error];
                  if (fail) {
                      NSString *errorDomain;
                      if (error.code==NSURLErrorTimedOut) {
                          errorDomain = HintWithTimeOut;
                      }
                      else {
                          errorDomain = HintWithNetError;
                      }
                      fail([NSError errorWithDomain:errorDomain
                                               code:error.code
                                           userInfo:nil]);
                  }
              }];
    }
}

#pragma mark 处理返回数据
+ (void)dealWithResponse:(id)responseObject
            MapClassName:(NSString*)mapClass
                 Success:(SuccessResponse)success
                    Fail:(FailResponse)fail
{
    if ([responseObject[@"code"] intValue] == WebErrorCodeOK) {
        if (success) {
            success([NSClassFromString(mapClass) mj_objectWithKeyValues:responseObject]);
        }
    }
    else {
       
        NSError* error =
        [NSError errorWithDomain:responseObject[@"msg"]
                            code:[responseObject[@"code"] integerValue]
                        userInfo:nil];
        if (fail) {
            fail(error);
        }
    }
}


@end
