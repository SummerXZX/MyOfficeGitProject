//
//  YMWithdrawResponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/16.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"


@interface YMWithdrawSummary : NSObject
/**创建时间*/
@property (nonatomic) int creatTime;

/**提现金额*/
@property (nonatomic,strong) NSString *amount;

/**提现记录id*/
@property (nonatomic) int id;

/**提现记录状态0，待审核，1，结算中 2，成功 3，失败*/
@property (nonatomic) int status;

/**状态说明*/
@property (nonatomic,strong) NSString *memo;

@end

@interface YMWithdrawData : NSObject
/**数据数*/
@property (nonatomic) int count;
/**数据list*/
@property (nonatomic,strong) NSArray *list;

@end


@interface YMWithdrawResponse : YMResponse

@property (nonatomic,strong) YMWithdrawData *data;

@end
