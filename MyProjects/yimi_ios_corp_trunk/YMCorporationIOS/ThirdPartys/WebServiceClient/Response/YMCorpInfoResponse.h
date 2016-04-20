//
//  YMCorpInfoResponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/10.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMCorpSummary : NSObject
/**企业地址*/
@property (nonatomic,strong) NSString *address;//企业地址
/**营业执照缩略图*/
@property (nonatomic,strong) NSString *businumberscale;
/**城市id*/
@property (nonatomic,assign) int cityId;
/**联系人*/
@property (nonatomic,strong) NSString *contact;
/**商家类别Id*/
@property (nonatomic,assign) int ctypeId;
/**邮箱地址*/
@property (nonatomic,strong) NSString *email;
/**身份证缩略图*/
@property (nonatomic,strong) NSString *idnumberscale;
/**商家所属行业*/
@property (nonatomic,assign) int industryId;
/**商家介绍*/
@property (nonatomic,strong) NSString *intro;
/**是否认证  1未认证  2已认证*/
@property (nonatomic,assign) int isCheck;
/**用户名*/
@property (nonatomic,strong) NSString *loginName;
/**商家logo缩略图*/
@property (nonatomic,strong) NSString *logoscale;
/**商家名*/
@property (nonatomic,strong) NSString *name;
/**商家手机号码*/
@property (nonatomic,strong) NSString *phone;
/**商家属性*/
@property (nonatomic,assign) int propertyId;
/**评级*/
@property (nonatomic,assign) int rank;
/**商家规模*/
@property (nonatomic,assign) int sizeId;
/**商家电话*/
@property (nonatomic,strong) NSString *tel;
/**商家公告*/
@property (nonatomic,strong) NSString *notice;

@end

@interface YMCorpInfoData : NSObject
/**是否提交商家信息 0.未提交 1.已提交*/
@property (nonatomic) int isPublish;
/**商家信息*/
@property (nonatomic,strong) YMCorpSummary *corp;
/**商家余额*/
@property (nonatomic,strong) NSString *amount;

@end


@interface YMCorpInfoResponse : YMResponse

@property (nonatomic,strong) YMCorpInfoData *data;

@end
