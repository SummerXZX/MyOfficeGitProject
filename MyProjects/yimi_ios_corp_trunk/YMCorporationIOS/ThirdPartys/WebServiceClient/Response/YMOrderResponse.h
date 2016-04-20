//
//  YMWorkResponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/7.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMOrderSummary : NSObject

/**职位名称*/
@property (nonatomic,strong) NSString *jobName;

/**职位地址*/
@property (nonatomic,strong) NSString *jobAddress;

/**薪资*/
@property (nonatomic) int jobPay;

/**薪资单位*/
@property (nonatomic) int jobPayUnit;

/**学生头像*/
@property (nonatomic,strong) NSString *photoscale;

/**学生名字*/
@property (nonatomic,strong) NSString *stuName;

/**学生ID*/
@property (nonatomic) int stuId;

/**订单ID*/
@property (nonatomic) int id;

/**职位ID*/
@property (nonatomic) int jobId;

/**学生性别*/
@property (nonatomic) int sex;

/**学生年龄*/
@property (nonatomic) int age;

/**学生电话*/
@property (nonatomic,strong) NSString *stuPhone;

/**工作开始时间*/
@property (nonatomic) int workStartTime;

/**工作时长*/
@property (nonatomic) double workTimes;

/**工作时间单位*/
@property (nonatomic) int workTimesUnit;

/**支付金额*/
@property (nonatomic) double pay;

/**订单状态 0 未确认 1 待上岗 2 未上岗 3 已支付 4 已取消*/
@property (nonatomic) int status;

/**支付类型 0 线下支付 1 线上支付*/
@property (nonatomic) int payType;

/**订单创建时间*/
@property (nonatomic) int creatTime;

@end


@interface YMOrderData : NSObject

/**数据数*/
@property (nonatomic) int count;
/**数据list*/
@property (nonatomic,strong) NSArray *list;

@end

@interface YMOrderResponse : YMResponse


@property (nonatomic,strong) YMOrderData *data;

@end
