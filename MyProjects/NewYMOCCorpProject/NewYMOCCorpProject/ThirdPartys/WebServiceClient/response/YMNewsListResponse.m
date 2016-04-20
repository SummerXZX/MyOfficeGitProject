//
//  YMNewsListResponse.m
//  NewYMOCProject
//
//  Created by test on 16/3/17.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMNewsListResponse.h"

@implementation YMNewsListResponse


@end


@implementation YMNewsListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [YMNewsInfo class]};
}

@end


@implementation YMNewsInfo

@end


