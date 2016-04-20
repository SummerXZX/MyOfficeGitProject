//
//  WebClient.h
//  CityCloud
//
//  Created by Summer on 15/5/7.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WebClientSuccess)(id data);
typedef void(^WebClientFail)(NSError *error);

@interface WebClient : NSObject

/**
 *实例化对象
 */
+ (WebClient *)shareClient;

//接口部分

/**
 *1.登录接口
 */
-(void)loginWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

/**
 *2.首页记录数接口
 */
-(void)getHomeIndexWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

/**
 *3.公告列表
 */
-(void)getAnnounceListWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

/**
 *4.公告详情
 */
-(void)getAnnounceDetailWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

/**
 *5.通知列表status:0-未收;1-已收;
 */
-(void)getNoticeListWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

/**
 *6.通知详情
 */
-(void)getNoticeDetailWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

/**
 *7.通知接收
 */
-(void)checkNoticeWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

/**
 *8.附件列表TypeId:1-公告;2-通知
 */
-(void)getAttachListWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

/**
 *9.用户列表
 */
-(void)getUserListWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

/**
 *10.用户详情
 */
-(void)getUserDetailWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

/**
 *上传用户头像
 */
-(void)uploadUserAvatarWithParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

/**
 *获取部门列表
 */
-(void)getSectionListParameters:(NSDictionary *)params Success:(WebClientSuccess)success Fail:(WebClientFail)fail;

@end
