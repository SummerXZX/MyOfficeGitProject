//
//  WebHomeInfoResponse.h
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebNomalResponse.h"

@interface WebHomeInfo : NSObject

@property (nonatomic, copy) NSString *raffiche_number;///<通知条数

@property (nonatomic, copy) NSString *receipt_number;///<公告条数

@property (nonatomic, copy) NSString *user_number;///<单位人员总数


@end

@interface WebHomeInfoResponse : WebNomalResponse

@property (nonatomic, strong) WebHomeInfo *data;

@end
