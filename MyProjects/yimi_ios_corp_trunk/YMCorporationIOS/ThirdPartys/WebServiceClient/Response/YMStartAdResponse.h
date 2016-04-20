//
//  YMStartAdResponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/18.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMStartAdData : NSObject

@property (nonatomic,strong) NSString *startscreen;

@end

@interface YMStartAdResponse : YMResponse

@property (nonatomic,strong) YMStartAdData*data;

@end
