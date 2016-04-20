//
//  YMWaitInviteReponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/6.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMWaitInviteSummary : NSObject

/**邀约id*/
@property (nonatomic) int id;
/**职位ID*/
@property (nonatomic) int jobId;

/**学生ID*/
@property (nonatomic) int stuId;

/**学生性别*/
@property (nonatomic) int sex;

/**学生年龄*/
@property (nonatomic) int age;

/**学生电话*/
@property (nonatomic,strong) NSString *stuPhone;

/**学生头像*/
@property (nonatomic,strong) NSString *stuPhotoScale;

/**学生名字*/
@property (nonatomic,strong) NSString *stuName;

/**职位名字*/
@property (nonatomic,strong) NSString *jobName;

/**职位类别*/
@property (nonatomic) int jobtypeId;

/**薪资*/
@property (nonatomic) int pay;

/**薪资单位*/
@property (nonatomic) int payUnit;

/**报名时间*/
@property (nonatomic) int regiTime;

@end


@interface YMWaitInviteData : NSObject

/**数据数*/
@property (nonatomic) int count;
/**数据list*/
@property (nonatomic,strong) NSArray *list;

@end


@interface YMWaitInviteListReponse : YMResponse

@property (nonatomic,strong) YMWaitInviteData *data;

@end
