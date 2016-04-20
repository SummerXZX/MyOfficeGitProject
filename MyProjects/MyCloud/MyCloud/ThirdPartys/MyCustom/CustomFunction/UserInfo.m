//
//  LoginInfo.m
//  CityCloud
//
//  Created by test on 15/5/9.
//  Copyright (c) 2015年 Summer. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

#pragma mark 初始化方法
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.uid = dic[@"id"];
        self.mobile = dic[@"mobile"];
        self.officeMob = dic[@"officeMob"];
        self.officeTel = dic[@"officeTel"];
        self.phone = dic[@"phone"];
        self.pwd = dic[@"pwd"];
        self.sex = dic[@"sex"];
        self.status = dic[@"status"];
        self.times = dic[@"times"];
        self.truename = dic[@"truename"];
        self.uGroup = dic[@"uGroup"];
        self.uLID = dic[@"uLID"];
        self.uLevID = dic[@"uLevID"];
        self.zwtnum = dic[@"zwtnum"];
        self.zwtnum2 = dic[@"zwtnum2"];
        self.deptid = dic[@"deptid"];
        self.userface = dic[@"userface"];
        self.DEPTIDS = dic[@"DEPTIDS"];
        self.DEPTNAME = dic[@"DEPTNAME"];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.uid = [aDecoder decodeObjectForKey:@"id"];
    self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
    self.officeMob = [aDecoder decodeObjectForKey:@"officeMob"];
    self.officeTel = [aDecoder decodeObjectForKey:@"officeTel"];
    self.phone = [aDecoder decodeObjectForKey:@"phone"];
    self.pwd = [aDecoder decodeObjectForKey:@"pwd"];
    self.sex = [aDecoder decodeObjectForKey:@"sex"];
    self.status = [aDecoder decodeObjectForKey:@"status"];
    self.times = [aDecoder decodeObjectForKey:@"times"];
    self.truename = [aDecoder decodeObjectForKey:@"truename"];
    self.uGroup = [aDecoder decodeObjectForKey:@"uGroup"];
    self.uLID = [aDecoder decodeObjectForKey:@"uLID"];
    self.uLevID = [aDecoder decodeObjectForKey:@"uLevID"];
    self.zwtnum = [aDecoder decodeObjectForKey:@"zwtnum"];
    self.zwtnum2 = [aDecoder decodeObjectForKey:@"zwtnum2"];
    self.deptid = [aDecoder decodeObjectForKey:@"deptid"];
    self.userface = [aDecoder decodeObjectForKey:@"userface"];
    self.DEPTIDS = [aDecoder decodeObjectForKey:@"DEPTIDS"];
    self.DEPTNAME = [aDecoder decodeObjectForKey:@"DEPTNAME"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"id"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.officeMob forKey:@"officeMob"];
    [aCoder encodeObject:self.officeTel forKey:@"officeTel"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.pwd forKey:@"pwd"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.times forKey:@"times"];
    [aCoder encodeObject:self.truename forKey:@"truename"];
    [aCoder encodeObject:self.uGroup forKey:@"uGroup"];
    [aCoder encodeObject:self.uLID forKey:@"uLID"];
    [aCoder encodeObject:self.uLevID forKey:@"uLevID"];
    [aCoder encodeObject:self.zwtnum forKey:@"zwtnum"];
    [aCoder encodeObject:self.zwtnum2 forKey:@"zwtnum2"];
    [aCoder encodeObject:self.deptid forKey:@"deptid"];
    [aCoder encodeObject:self.userface forKey:@"userface"];
    [aCoder encodeObject:self.DEPTIDS forKey:@"DEPTIDS"];
    [aCoder encodeObject:self.DEPTNAME forKey:@"DEPTNAME"];
}

@end
