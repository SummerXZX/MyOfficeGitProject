//
//  WebNoticeListResponse.m
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebNoticeListResponse.h"

@implementation WebNoticeListResponse

@end
@implementation WebNoticeListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [WebNoticeInfo class]};
}

@end


@implementation WebNoticeInfo

@end


