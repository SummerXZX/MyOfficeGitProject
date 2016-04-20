//
//  YMStaffDetailResponse.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/28.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMResponse.h"


@interface YMEvaluateInfo : NSObject

@property (nonatomic,assign) NSInteger count;///<评价次数

@property (nonatomic,copy) NSString *describe;///<评价内容

@property (nonatomic,assign) NSInteger isMyEvaluate;///<是否是我的评价

@property (nonatomic,assign) BOOL isAdded;///<是否已增加过

@end

@interface YMStaffDetailExperienceInfo : NSObject

@property (nonatomic,assign) NSInteger workCount;///<工作次数

@property (nonatomic,assign) NSInteger jobTypeId;///<职位类型id


@end

@interface YMStuResumeInfo : NSObject

@property (nonatomic,assign) NSInteger age;///<年龄

@property (nonatomic,assign) NSInteger height;///<身高

@property (nonatomic,copy) NSString *school;///<学校名称

@property (nonatomic,copy) NSString *intro;///<描述

@property (nonatomic,assign) NSInteger workCount;///<兼职次数

@property (nonatomic,assign) NSInteger unworkCount;///<放鸽子次数

@property (nonatomic,copy) NSString *workdates;///<工作日期


@end

@interface YMStaffDetailInfo : NSObject


@property (nonatomic,copy) NSArray<YMStaffDetailExperienceInfo *> *workExperience;///<工作经历

@property (nonatomic,copy) NSArray<YMEvaluateInfo *> *evaluates;///<评价


@property (nonatomic,assign) BOOL isExpand;///<是否展开工作日期


@property (nonatomic,strong) YMStuResumeInfo *stuResumeItem;///<学生简历信息

@end

@interface YMStaffDetailResponse : YMResponse

@property (nonatomic,strong) YMStaffDetailInfo *data;

@end
