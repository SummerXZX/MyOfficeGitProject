//
//  WebDepContactListResponse.h
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebNomalResponse.h"

@interface WebDepContactInfo : NSObject

@property (nonatomic, copy) NSString *gaCall;

@property (nonatomic, assign) NSInteger userGender;

@property (nonatomic, assign) NSInteger userStatus;

@property (nonatomic, copy) NSString *userPhone;

@property (nonatomic, copy) NSString *departmentCall;

@property (nonatomic, copy) NSString *departmentCode;

@property (nonatomic, assign) NSInteger userLock;

@property (nonatomic, copy) NSString *workCall;

@property (nonatomic, copy) NSString *userAlias;

@property (nonatomic, copy) NSString *departmentFullName;

@property (nonatomic, copy) NSString *officeCall;

@property (nonatomic, copy) NSString *userIcon;

@property (nonatomic, copy) NSString *userLoginPassword;

@property (nonatomic, copy) NSString *companyFullName;

@property (nonatomic, copy) NSString *appJoinTime;

@property (nonatomic, assign) NSInteger isExist;

@property (nonatomic, copy) NSString *userCode;

@property (nonatomic, copy) NSString *backupsUserPhone;

@property (nonatomic, copy) NSString *role;

@property (nonatomic, copy) NSString *postCode;

@property (nonatomic, copy) NSString *userLogin;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *backupsGaCall;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *roleCode;

@property (nonatomic, copy) NSString *postName;


@end

@interface WebDepContactListData : NSObject

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray<WebDepContactInfo *> *list;

@end


@interface WebDepContactListResponse : WebNomalResponse

@property (nonatomic, strong) WebDepContactListData *data;


@end
