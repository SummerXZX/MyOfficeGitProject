//
//  WebContactListResponse.m
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebContactListResponse.h"

@implementation WebContactInfo

@end

@implementation WebContactListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [WebContactInfo class]};
}


@end

@implementation WebContactListResponse

@end
