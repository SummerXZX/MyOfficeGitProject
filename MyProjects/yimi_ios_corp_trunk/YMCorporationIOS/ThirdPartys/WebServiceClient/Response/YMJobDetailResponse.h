//
//  YMJobDetailResponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/4.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMJobDetailSummary : NSObject
/**职位ID*/
@property (nonatomic) int id;
/**职位名称*/
@property (nonatomic,strong) NSString *name;
/**职位状态1、待审核  2、审核通过   3、审核拒绝   4、停招、5、已过期*/
@property (nonatomic) int isCheck;
/**薪资*/
@property (nonatomic) int pay;
/**薪资单位*/
@property (nonatomic) int payUnit;
/**结算方式*/
@property (nonatomic) int jobsettletypeId;
/**招聘人数*/
@property (nonatomic) int count;
/**有效起始时间*/
@property (nonatomic) int startTime;
/**有效结束时间*/
@property (nonatomic) int endTime;
/**商家联系电话*/
@property (nonatomic,strong) NSString *tel;
/**城市Id*/
@property (nonatomic) int cityId;
/**区域Id*/
@property (nonatomic) int areaId;
/**岗位类型*/
@property (nonatomic) int jobtypeId;
/**街道地址*/
@property (nonatomic,strong) NSString *street;
/**商家联系人*/
@property (nonatomic,strong) NSString *contact;
/**地址*/
@property (nonatomic,strong) NSString *address;
/**性别*/
@property (nonatomic) int sex;
/**学历*/
@property (nonatomic) int grade;
/**最小年龄*/
@property (nonatomic) int minAge;
/**最大年龄*/
@property (nonatomic) int maxAge;
/**身高*/
@property (nonatomic) int height;
/**兼职时间*/
@property (nonatomic,strong) NSString *jobTime;
/**工作描述*/
@property (nonatomic,strong) NSString *workContent;
/**报名数*/
@property (nonatomic) int regiNum;
/**签约数*/
@property (nonatomic) int confirmNum;

@end



@interface YMJobDetailResponse : YMResponse

@property (nonatomic,strong) YMJobDetailSummary *data;

@end
