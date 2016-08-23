//
//  WebDepContactListResponse.m
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebDepContactListResponse.h"

@implementation WebDepContactInfo


@end

@implementation WebDepContactListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [WebDepContactInfo class]};
}

@end

@implementation WebDepContactListResponse

@end
