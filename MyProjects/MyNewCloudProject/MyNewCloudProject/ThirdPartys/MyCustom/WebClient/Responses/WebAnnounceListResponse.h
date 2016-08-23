//
//  WebAnnounceListResponse.h
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebNomalResponse.h"

@class WebAnnounceListData,WebAnnounceInfo;
@interface WebAnnounceListResponse : WebNomalResponse

@property (nonatomic, strong) WebAnnounceListData *data;

@end
@interface WebAnnounceListData : NSObject

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray<WebAnnounceInfo *> *list;

@end

@interface WebAnnounceInfo : NSObject

@property (nonatomic, copy) NSString *sendUserName;

@property (nonatomic, copy) NSString *afficheTitle;

@property (nonatomic, assign) BOOL isHaveRead;

@property (nonatomic, copy) NSString *afficeCode;

@property (nonatomic, copy) NSString *create_time;

@end

