//
//  WebNoticeListResponse.h
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebNomalResponse.h"

@class WebNoticeListData,WebNoticeInfo;
@interface WebNoticeListResponse : WebNomalResponse

@property (nonatomic, strong) WebNoticeListData *data;

@end
@interface WebNoticeListData : NSObject

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray<WebNoticeInfo *> *list;

@end

@interface WebNoticeInfo : NSObject

@property (nonatomic, copy) NSString *notice_code;

@property (nonatomic, copy) NSString *send_userName;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, assign) BOOL if_read;

@property (nonatomic, assign) BOOL if_haveFile;

@property (nonatomic, assign) BOOL if_havePic;

@property (nonatomic, copy) NSString *notice_title;

@end

