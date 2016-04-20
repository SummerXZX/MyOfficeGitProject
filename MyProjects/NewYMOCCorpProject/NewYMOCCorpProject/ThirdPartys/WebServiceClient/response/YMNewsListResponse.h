//
//  YMNewsListResponse.h
//  NewYMOCProject
//
//  Created by test on 16/3/17.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMResponse.h"

@class YMNewsListData,YMNewsInfo;
@interface YMNewsListResponse : YMResponse

@property (nonatomic, strong) YMNewsListData *data;


@end

@interface YMNewsListData : NSObject

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger t;

@property (nonatomic, strong) NSArray<YMNewsInfo *> *list;

@end

@interface YMNewsInfo : NSObject

@property (nonatomic, copy) NSString *action;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger isRead;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger pushId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger stuId;

@property (nonatomic, assign) NSInteger createTime;

@end

