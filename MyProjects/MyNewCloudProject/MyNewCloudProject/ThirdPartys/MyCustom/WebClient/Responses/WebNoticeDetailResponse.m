//
//  WebNoticeDetailResponse.m
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebNoticeDetailResponse.h"

@implementation WebNoticeDetailResponse

@end
@implementation WebNoticeDetailInfo

+ (NSDictionary *)objectClassInArray{
    return @{@"noticeImg_list" : [WebNoticeImgInfo class], @"noticeFile_list" : [WebNoticeFileInfo class]};
}

@end


@implementation WebNoticeImgInfo

@end


@implementation WebNoticeFileInfo

@end


