//
//  YMWebServiceClient.h
//  YimiJob
//
//  Created by test on 15/4/13.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YMNomalResponse.h"
#import "YMLoginResponse.h"
#import "YMHomeResponse.h"
#import "YMJobListResponse.h"
#import "YMJobDetailResponse.h"
#import "YMWaitInviteListReponse.h"
#import "YMStuResumeResponse.h"
#import "YMOrderResponse.h"
#import "YMJobRegiResponse.h"
#import "YMCorpInfoResponse.h"
#import "YMCompleteCorpInfoResponse.h"
#import "YMBankResponse.h"
#import "YMRechargeReponse.h"
#import "YMWithdrawResponse.h"
#import "YMStartAdResponse.h"
typedef void(^SuccessResponse)(id response);

@interface YMWebServiceClient : NSObject

/**
 *注册获取验证码接口
 */
+(void)getRegistCaptchaWithParams:(NSDictionary *)params Success:(void (^) (YMNomalResponse *response))success;
/**
 *注册接口
 */
+(void)registWithParams:(NSDictionary *)params Success:(void (^) (YMNomalResponse *response))success;
/**
 *登陆接口
 */
+(void)loginWithParams:(NSDictionary *)params Success:(void(^)(YMLoginResponse *response))success ;
/**
 *忘记密码接口
 */
+(void)forgetPassWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;
/**
 *修改密码接口
 */
+(void)changePassWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *修改用户名
 */
+(void)changeUserNameWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *同步本地字典
 */
+(void)syncLocalDicWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success;

/**
 *获取首页数据
 */
+(void)getHomeInfoSuccess:(void(^)(YMHomeResponse *response))success ;

/**
 *发布职位
 */
+(void)postJobWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *更新职位
 */
+(void)updateJobWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *获取职位列表
 */
+(void)getJobListWithParams:(NSDictionary *)params Success:(void(^)(YMJobListResponse *response))success ;

/**
 *获取职位详情
 */
+(void)getJobDetailWithParams:(NSDictionary *)params Success:(void(^)(YMJobDetailResponse *response))success ;
/**
 *刷新职位
 */
+(void)refreshJobWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;
/**
 *重新发布职位
 */
+(void)repostJobWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;
/**
 *停招职位
 */
+(void)stopJobWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *获取待签约列表数据
 */
+(void)getWaitInviteListWithParams:(NSDictionary *)params Success:(void(^)(YMWaitInviteListReponse *response))success ;

/**
 *获取学生简历信息
 */
+(void)getStuResumeWithParams:(NSDictionary *)params Success:(void(^)(YMStuResumeResponse *response))success ;

/**
 *获取上岗订单数据
 */
+(void)getWorkOrderListWithParams:(NSDictionary *)params Success:(void(^)(YMOrderResponse *response))success ;

/**
 *获取职位的报名信息
 */
+(void)getJobRegiListWithParams:(NSDictionary *)params Success:(void(^)(YMJobRegiResponse *response))success ;

/**
 *获取当前开通城市列表
 */
+(void)getCityListSuccess:(void(^)(YMNomalResponse *response))success ;
/**
 *更新商家用户名
 */
+(void)updateCorpLoginNameWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *更新商家logo
 */
+(void)updateCorpLogoWithImage:(UIImage *)image Success:(void(^)(YMNomalResponse *response))success ;
/**
 *获取商家信息
 */
+(void)getCorpInfoSuccess:(void(^)(YMCorpInfoResponse *response))success;

/**
 *更新商家信息
 */
+(void)updateCorpInfoWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *获取是否完善商家信息
 */
+(void)getIsCompleteCorpInfoSuccess:(void(^)(YMCompleteCorpInfoResponse *response))success ;

/**
 *支付该订单
 */
+(void)payOrderWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *标记未上岗订单
 */
+(void)markUnWorkOrderWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *取消订单
 */
+(void)cancelOrderWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *邀约学生
 */
+(void)inviteStuWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *拒绝学生
 */
+(void)refuserStuWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *充值获取订单号
 */
+(void)getChargeOrderNumWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *查询余额接口
 */
+(void)checkBalanceWithSuccess:(void(^)(YMNomalResponse *response))success ;

/**
 *获取提现账户信息
 */
+(void)getWithdrawAcountInfoSuccess:(void(^)(YMBankResponse *response))success ;

/**
 *获取充值记录
 */
+(void)getRechargeRecordWithParams:(NSDictionary *)params Success:(void(^)(YMRechargeReponse *response))success ;

/**
 *充值记录继续支付
 */
+(void)rechargeRecordChargeWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *获取提现记录
 */
+(void)getWithdrawRecordParams:(NSDictionary *)params Success:(void(^)(YMWithdrawResponse *response))success ;

/**
 *保存提现账户信息
 */
+(void)saveWithdrawInfoWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *提现操作
 */
+(void)withdrawWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *上传身份证照片
 */
+(void)uploadIdentityWithImage:(UIImage *)image Success:(void(^)(YMNomalResponse *response))success ;

/**
 *上传营业执照照片
 */
+(void)uploadBusinessWithImage:(UIImage *)image Success:(void (^)(YMNomalResponse *response))success ;

/**
 *意见反馈
 */
+(void)feedbackWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

/**
 *获取启动页广告图片
 */
+(void)getStartAdWithSuccess:(void(^)(YMStartAdResponse *response))success ;

/**
 *是否设置支付密码
 */
+(void)isSetPayPwdWithSuccess:(void(^)(YMNomalResponse *response))success ;

/**
 *获取支付密码验证码
 */
+(void)getPayPwdCaptchaWithSuccess:(void(^)(YMNomalResponse *response))success ;

/**
 *设置支付密码
 */
+(void)updatePayPwdWithParams:(NSDictionary *)params Success:(void(^)(YMNomalResponse *response))success ;

@end
