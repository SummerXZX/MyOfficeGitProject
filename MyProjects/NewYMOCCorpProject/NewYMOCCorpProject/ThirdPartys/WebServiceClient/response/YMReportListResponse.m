//
//  YMReportListResponse.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMReportListResponse.h"

@implementation YMPayListItemInfo

@end

@implementation YMReportInfo

@end

@implementation YMReportListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [YMReportInfo class]};
}

@end

@implementation YMReportListResponse

@end
