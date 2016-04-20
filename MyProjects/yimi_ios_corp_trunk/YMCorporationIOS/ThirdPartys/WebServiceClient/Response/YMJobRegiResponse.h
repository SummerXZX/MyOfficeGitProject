//
//  YMJobRegiResponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/7.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMJobRegiOrderSummary : NSObject

/**订单状态*/
@property (nonatomic) int status;

/**订单id*/
@property (nonatomic) int id;

/**上岗时间*/
@property (nonatomic) int workStartTime;

/**工作时长*/
@property (nonatomic) double workTimes;

/**工作时间单位*/
@property (nonatomic) int workTimesUnit;

/**支付金额*/
@property (nonatomic) double pay;

/**支付类型*/
@property (nonatomic) int payType;

@end


@interface YMJobRegiSummary : NSObject

/**报名信息ID*/
@property (nonatomic) int id;
/**学生名字*/
@property (nonatomic,strong) NSString *stuName;

/**学生ID*/
@property (nonatomic) int stuId;

/**学生性别*/
@property (nonatomic) int sex;

/**学生年龄*/
@property (nonatomic) int age;

/**学生头像*/
@property (nonatomic,strong) NSString *stuPhotoScale;

/**学生电话*/
@property (nonatomic,strong) NSString *stuPhone;

/**职位名称*/
@property (nonatomic,strong) NSString *jobName;

/**职位地址*/
@property (nonatomic,strong) NSString *address;

/**薪资*/
@property (nonatomic) int pay;

/**薪资单位*/
@property (nonatomic) int payUnit;

/**报名时间*/
@property (nonatomic) int regiTime;

/**职位状态*/
@property (nonatomic) int status;

/**创建时间*/
@property (nonatomic) int creatTime;

/**上岗订单列表*/
@property (nonatomic,strong) NSArray *jobRegiOrderList;
@end

@interface YMJobRegiData : NSObject

/**数据数*/
@property (nonatomic) int count;
/**数据list*/
@property (nonatomic,strong) NSArray *list;

@end


@interface YMJobRegiResponse : YMResponse

@property (nonatomic,strong) YMJobRegiData *data;

@end
