//
//  YMLoginResponse.h
//  YMCorporation
//
//  Created by test on 15/6/3.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "YMResponse.h"
#import "YMCorpInfoResponse.h"

@interface YMLoginInfo : NSObject

/**是否提交商家信息 0.未提交 1.已提交*/
@property (nonatomic) int isPublish;
/**商家用户token*/
@property (nonatomic,strong) NSString *token;
/**1.设置 0.未设置*/
@property (nonatomic) int ispwd;
/**商家信息*/
@property (nonatomic,strong) YMCorpSummary *corp;

@end

@interface YMLoginResponse : YMResponse

@property (nonatomic,strong) YMLoginInfo *data;

@end
