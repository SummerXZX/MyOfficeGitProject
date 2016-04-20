//
//  YMHomeResponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/1.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMHomeSummary : NSObject
/**待审核数*/
@property (nonatomic) int notCheckCount;
/**已审核数*/
@property (nonatomic) int jobCheckCount;
/**待签约数*/
@property (nonatomic) int toBeInvitedCount;
/**待上岗数*/
@property (nonatomic) int toBeWorkCount;

@end


@interface YMHomeResponse : YMResponse

@property (nonatomic,strong)YMHomeSummary *data;

@end
