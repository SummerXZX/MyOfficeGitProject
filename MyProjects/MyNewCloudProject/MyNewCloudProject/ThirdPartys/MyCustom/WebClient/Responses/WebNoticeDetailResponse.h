//
//  WebNoticeDetailResponse.h
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebNomalResponse.h"

@class WebNoticeDetailInfo,WebNoticeImgInfo,WebNoticeFileInfo;
@interface WebNoticeDetailResponse : WebNomalResponse

@property (nonatomic, strong) WebNoticeDetailInfo *data;

@end
@interface WebNoticeDetailInfo : NSObject

@property (nonatomic, copy) NSString *notice_content;

@property (nonatomic, copy) NSString *notice_code;

@property (nonatomic, assign) NSInteger issend;

@property (nonatomic, strong) NSArray<WebNoticeImgInfo *> *noticeImg_list;

@property (nonatomic, strong) NSArray<WebNoticeFileInfo *> *noticeFile_list;

@property (nonatomic, copy) NSString *user_code;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *send_user;

@property (nonatomic, copy) NSString *send_userName;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *notice_title;

@property (nonatomic, assign) NSInteger isdel;

@end

@interface WebNoticeImgInfo : NSObject

@property (nonatomic, copy) NSString *notice_code;

@property (nonatomic, copy) NSString *notice_img_addr;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, assign) NSInteger isdel;

@property (nonatomic, assign) NSInteger notice_img_id;

@end

@interface WebNoticeFileInfo : NSObject

@property (nonatomic, copy) NSString *notice_code;

@property (nonatomic, assign) NSInteger notice_file_id;

@property (nonatomic, copy) NSString *notice_file_title;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, assign) NSInteger isdel;

@property (nonatomic, copy) NSString *notice_file_addr;

@end

