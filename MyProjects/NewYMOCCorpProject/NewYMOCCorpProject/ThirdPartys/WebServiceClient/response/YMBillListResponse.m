//
//  YMBillListResponse.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/21.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMBillListResponse.h"

@implementation YMBillInfo

@end


@implementation YMBillListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [YMBillInfo class]};
}

@end


@implementation YMBillListResponse

@end
