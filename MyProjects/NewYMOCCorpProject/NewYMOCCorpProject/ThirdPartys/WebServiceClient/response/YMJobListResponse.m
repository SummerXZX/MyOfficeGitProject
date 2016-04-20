//
//  YMJobListResponse.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/24.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMJobListResponse.h"

@implementation YMJobListResponse

@end


@implementation YMJobListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [YMJobListInfo class]};
}

@end

@implementation YMJobListInfo



@end