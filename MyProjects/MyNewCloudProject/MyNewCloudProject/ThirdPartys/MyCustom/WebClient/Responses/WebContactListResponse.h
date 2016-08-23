//
//  WebContactListResponse.h
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebNomalResponse.h"

@interface WebContactInfo : NSObject

@property (nonatomic, copy) NSString *departmentCall;

@property (nonatomic, copy) NSString *departmentFullName;

@property (nonatomic, copy) NSString *userCode;

@property (nonatomic, copy) NSString *userIcon;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userPhone;

@property (nonatomic, copy) NSString *postName;


@end

@interface WebContactListData : NSObject

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray<WebContactInfo *> *list;


@end

@interface WebContactListResponse : WebNomalResponse

@property (nonatomic, strong) WebContactListData *data;


@end
