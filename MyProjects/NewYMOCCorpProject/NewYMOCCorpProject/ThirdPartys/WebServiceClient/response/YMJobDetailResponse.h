//
//  YMJobDetailResponse.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/22.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMJobDateInfo : NSObject

@property (nonatomic,assign) NSInteger total;///<人数

@property (nonatomic,assign) NSInteger workDate;///<日期时间戳


@end

@interface YMJobInfo : NSObject

@property (nonatomic,assign) NSInteger id;///<职位id

@property (nonatomic,copy) NSString *name;///<职位名称

@property (nonatomic,assign) NSInteger jobtypeId;///<职位类型

@property (nonatomic,assign) NSInteger count;///<招聘总人数

@property (nonatomic,copy) NSArray *jobDates;///<工作日期数组YMJobDateInfo

@property (nonatomic,copy) NSString *workTime;///<工作时间数组

@property (nonatomic,assign) double pay;///<职位薪资

@property (nonatomic,assign) NSInteger payUnit;///<职位薪资单位

@property (nonatomic,assign) NSInteger jobsettletypeId;///<结算方式

@property (nonatomic,copy) NSString *tel;///<联系方式

@property (nonatomic,copy) NSString *contact;///<联系人

@property (nonatomic,assign) NSInteger areaId;///<区域id

@property (nonatomic,assign) NSInteger cityId;///<城市id

@property (nonatomic,copy) NSString *address;///<详细地址

@property (nonatomic,copy) NSString *street;///<街道地址

@property (nonatomic,assign) NSInteger sex;///<性别

@property (nonatomic,assign) NSInteger grade;///<学历

@property (nonatomic,assign) NSInteger minAge;///<最小年龄

@property (nonatomic,assign) NSInteger maxAge;///<最大年龄

@property (nonatomic,assign) NSInteger height;///<身高

@property (nonatomic,copy) NSString *workContent;///<工作内容

@property (nonatomic,assign) NSInteger isCheck;///<是否审核 1、待审核  2、审核通过   3、审核拒绝   4、停招、5、已过期

@property (nonatomic,assign) NSInteger defaultCount;///<默认每天招聘人数

@end

@interface YMJobDetailResponse : YMResponse

@property (nonatomic,strong) YMJobInfo *data;

@end
