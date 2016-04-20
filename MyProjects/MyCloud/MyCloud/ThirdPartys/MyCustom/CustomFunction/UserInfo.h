//
//  LoginInfo.h
//  CityCloud
//
//  Created by test on 15/5/9.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>

@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *officeMob;
@property (nonatomic,strong)NSString *officeTel;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *pwd;
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *times;
@property (nonatomic,strong)NSString *truename;
@property (nonatomic,strong)NSString *uGroup;
@property (nonatomic,strong)NSString *uLID;
@property (nonatomic,strong)NSString *uLevID;
@property (nonatomic,strong)NSString *zwtnum;
@property (nonatomic,strong)NSString *zwtnum2;
@property (nonatomic,strong)NSString *deptid;
@property (nonatomic,strong)NSString *userface;
@property (nonatomic,strong)NSString *DEPTIDS;
@property (nonatomic,strong)NSString *DEPTNAME;

/**
 *初始化方法
 */
-(instancetype)initWithDic:(NSDictionary *)dic;

@end
