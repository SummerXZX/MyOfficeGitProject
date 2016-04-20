//
//  YMRechargeReponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/15.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMRechargeSummary : NSObject

/**创建时间*/
@property (nonatomic) int creatTime;

/**充值金额*/
@property (nonatomic,strong) NSString *amount;

/**充值记录状态0 : 未支付，1：充值成功，2：充值失败，3：已关闭*/
@property (nonatomic) int status;

/**充值记录id*/
@property (nonatomic) int id;

@end

@interface YMRechargeData : NSObject
/**数据数*/
@property (nonatomic) int count;
/**数据list*/
@property (nonatomic,strong) NSArray *list;

@end

@interface YMRechargeReponse : YMResponse

@property (nonatomic,strong) YMRechargeData *data;

@end
