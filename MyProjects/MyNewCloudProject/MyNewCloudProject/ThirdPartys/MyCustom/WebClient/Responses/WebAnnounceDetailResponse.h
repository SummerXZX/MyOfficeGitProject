//
//  WebAnnounceDetailResponse.h
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebNomalResponse.h"

@class WebAnnounceDetailInfo;
@interface WebAnnounceDetailResponse : WebNomalResponse

@property (nonatomic, strong) WebAnnounceDetailInfo *data;

@end

@interface WebAnnounceDetailInfo : NSObject

@property (nonatomic, copy) NSString *afficheContent;

@property (nonatomic, copy) NSString *afficheTitle;

@property (nonatomic, assign) NSInteger isHaveRead;

@property (nonatomic, copy) NSString *afficeCode;

@property (nonatomic, copy) NSString *create_time;

@end

