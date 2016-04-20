//
//  YMAllEvaluateListResponse.m
//  NewYMOCCorpProject
//
//  Created by test on 16/2/17.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMAllEvaluateListResponse.h"

@implementation YMAllEvaluateListResponse

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [YMEvaluateInfo class]};
}

@end
