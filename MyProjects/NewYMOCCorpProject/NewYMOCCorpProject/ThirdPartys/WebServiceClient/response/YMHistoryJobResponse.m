//
//  YMHistoryJobResponse.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/25.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMHistoryJobResponse.h"

@implementation YMHistoryJobInfo

@end

@implementation YMHistoryJobResponse

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [YMHistoryJobInfo class]};
}


@end
