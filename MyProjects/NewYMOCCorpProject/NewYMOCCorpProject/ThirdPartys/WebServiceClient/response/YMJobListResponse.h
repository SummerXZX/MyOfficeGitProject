//
//  YMJobListResponse.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/24.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMJobListInfo : NSObject

@property (nonatomic,assign) NSInteger id;///<职位id
@property (nonatomic,copy) NSString *name;///<职位名称
@property (nonatomic,assign) NSInteger jobtypeId;///<职位类型
@property (nonatomic,assign) NSInteger areaId;///<区域
@property (nonatomic,assign) NSInteger count;///<总招聘人数
@property (nonatomic,assign) NSInteger creatTime;///<创建时间
@property (nonatomic,assign) NSInteger regiNum;///<报名人数
@property (nonatomic,assign) NSInteger workNum;///<上岗人次
@property (nonatomic,assign) double totalPay;///<总共支付
@property (nonatomic,assign) double pay;///<职位薪资
@property (nonatomic,assign) NSInteger payUnit;///<职位薪资单位
@end

@interface YMJobListData : NSObject

@property (nonatomic,copy) NSArray<YMJobListInfo *> *list;///<列表记录
@property (nonatomic,assign) NSInteger count;///<列表总数

@end


@interface YMJobListResponse : YMResponse

@property (nonatomic,strong) YMJobListData *data;///<数据


@end
