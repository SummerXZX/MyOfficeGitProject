//
//  WebClient.m
//  CityCloud
//
//  Created by Summer on 15/5/7.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "WebClient.h"
#import "WebServiceHelper.h"

@interface WebClient ()<WebServiceDelegate>
{
    WebClientSuccess _success;
    WebClientFail _fail;
}
@end

@implementation WebClient

#pragma mark 实例化对象
+(WebClient *)shareClient
{
    
    return [[WebClient alloc]init];
    
}

#pragma mark 登录接口
-(void)loginWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"UserLogin" Parameters:params Success:success Fail:fail];
}

#pragma mark 首页记录数接口
-(void)getHomeIndexWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"UserIndex" Parameters:params Success:success Fail:fail];
}

#pragma mark 公告列表
-(void)getAnnounceListWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"AnnounceList" Parameters:params Success:success Fail:fail];

}

#pragma mark 公告详情
-(void)getAnnounceDetailWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"AnnounceView" Parameters:params Success:success Fail:fail];
    
}

#pragma mark 通知列表
-(void)getNoticeListWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"NoticeList" Parameters:params Success:success Fail:fail];
    
}

#pragma mark 通知详情
-(void)getNoticeDetailWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"NoticeView" Parameters:params Success:success Fail:fail];
}

#pragma mark 通知接收status:0-未收;1-已收
-(void)checkNoticeWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"NoticeLz" Parameters:params Success:success Fail:fail];
}

#pragma mark 附件列表TypeId:1-公告;2-通知
-(void)getAttachListWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"AttachList" Parameters:params Success:success Fail:fail];
}

#pragma mark 用户列表
-(void)getUserListWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"UserList" Parameters:params Success:success Fail:fail];
}

#pragma mark 用户详情
-(void)getUserDetailWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"UserView" Parameters:params Success:success Fail:fail];
}

#pragma mark 上传用户头像
-(void)uploadUserAvatarWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"UserPicUpload" Parameters:params Success:success Fail:fail];
}

#pragma mark 获取部门列表
-(void)getSectionListParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    [self requestInterfaceWithFunctionName:@"DeptList" Parameters:params Success:success Fail:fail];
}

#pragma mark 请求接口的公共方法
-(void)requestInterfaceWithFunctionName:(NSString *)functionName Parameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail
{
    //给block赋值
    _success = success;
    _fail = fail;
    
    //给参数中添加ConPass
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [tempDic setObject:REQUEST_ConPass forKey:@"ConPass"];
    params = [NSDictionary dictionaryWithDictionary:tempDic];
    WebServiceHelper *service = [[WebServiceHelper alloc]initWebService:functionName];
    [service addParameterWithDictionary:params];
    [service addParameterForString:@"ConPass" value:REQUEST_ConPass];
    service.delegate = self;
    [service startASynchronous];
}

#pragma mark WebServiceDelegate
-(void)requestFailed:(WebServiceHelper *)helper
{
    if (_fail)
    {
        _fail(helper.error);
    }
}

-(void)requestFinished:(WebServiceHelper *)helper
{
    if (_success)
    {
        NSData *data = [[helper getSimpleResult] dataUsingEncoding:NSUTF8StringEncoding];
        id responseObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        _success(responseObj);
    }
}

@end
