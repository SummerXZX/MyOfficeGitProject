//
//  YMLoginResponse.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/4.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMResponse.h"


@interface YMLoginInfo : NSObject

/**是否提交商家信息 0.未提交 1.已提交*/
@property (nonatomic) NSInteger isPublish;
/**商家用户token*/
@property (nonatomic,copy) NSString *token;
/**商家名*/
@property (nonatomic,copy) NSString *name;
/**商家logo缩略图*/
@property (nonatomic,copy) NSString *logo;
@property (nonatomic,copy) NSString *contact;///<联系人
@property (nonatomic,copy) NSString *phone;///<联系电话
@property (nonatomic,assign) NSInteger areaId;///<区域id
@property (nonatomic,assign) NSInteger cityId;///<城市id
/**1：未认证，2：已认证，3：认证不通过，4:认证中*/
@property (nonatomic,assign) NSInteger checkStatus;

@end

@interface YMLoginResponse : YMResponse

@property (nonatomic,strong) YMLoginInfo *data;

@end
