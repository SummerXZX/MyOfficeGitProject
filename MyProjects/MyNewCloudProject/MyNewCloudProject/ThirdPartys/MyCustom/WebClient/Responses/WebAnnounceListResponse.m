//
//  WebAnnounceListResponse.m
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebAnnounceListResponse.h"

@implementation WebAnnounceListResponse

@end
@implementation WebAnnounceListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [WebAnnounceInfo class]};
}

@end


@implementation WebAnnounceInfo

@end


