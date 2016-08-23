//
//  WebDepListResponse.h
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebNomalResponse.h"

@interface WebDepInfo : NSObject

@property (nonatomic, assign) NSInteger departmentStatus;

@property (nonatomic, assign) NSInteger departmentOrder;

@property (nonatomic, copy) NSString *departmentCode;

@property (nonatomic, copy) NSString *departmentFullName;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *companyFullName;

@property (nonatomic, copy) NSString *createTime;

@end

@interface WebDepListData : NSObject

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray<WebDepListData *> *list;

@end


@interface WebDepListResponse : WebNomalResponse

@property (nonatomic, strong) WebDepListData *data;

@end
