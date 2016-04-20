//
//  YMBankResponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/15.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMBankSummary : NSObject

/**账户号码*/
@property (nonatomic,strong) NSString *banknumber;

/**账户姓名*/
@property (nonatomic,strong) NSString *name;

@end


@interface YMBankResponse : YMResponse

@property (nonatomic,strong) YMBankSummary *data;

@end
