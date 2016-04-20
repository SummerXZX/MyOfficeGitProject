//
//  YMCompleteCorpInfoResponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/10.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMCompleteCorpInfoData : NSObject

/**是否完善商家信息*/
@property (nonatomic) int isPublish;

@end


@interface YMCompleteCorpInfoResponse : YMResponse

@property (nonatomic,strong) YMCompleteCorpInfoData *data;
@end
