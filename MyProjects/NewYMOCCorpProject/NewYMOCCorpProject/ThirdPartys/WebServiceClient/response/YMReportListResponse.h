//
//  YMReportListResponse.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMReportInfo : NSObject

@property (nonatomic,assign) NSInteger id;///<订单id

@property (nonatomic,copy) NSString *stuName;///<学生名称

@property (nonatomic,assign) NSInteger sex;///<性别

@property (nonatomic,copy) NSString *stuPhone;///<电话

@property (nonatomic,assign) NSInteger stuId;///<学生id

@property (nonatomic,assign) NSInteger status;///<状态

@property (nonatomic,assign) NSInteger praise;///<好评率

@property (nonatomic,copy) NSString *signAddress;///<签到地址

@property (nonatomic,assign) NSInteger signType;///<签到类别，0:未签到，1:手动签到，2:自动签到

@property (nonatomic,assign) NSInteger date;///<工作日期

@property (nonatomic,assign) double pay;///<支付金额

@property (nonatomic,assign) NSInteger regiId;///<报名id

@property (nonatomic,copy) NSString *serialNum;///<流水号

@end

@interface YMPayListItemInfo : NSObject

@property (nonatomic,assign) NSInteger date;

@property (nonatomic,assign) NSInteger selectedCount;///<选中的数量

@property (nonatomic,copy) NSArray<YMReportInfo *> *list;///<列表记录

@end

@interface YMReportListData : NSObject

@property (nonatomic,copy) NSArray<YMReportInfo *> *list;///<列表记录
@property (nonatomic,assign) NSInteger count;///<列表总数

@end


@interface YMReportListResponse : YMResponse

@property (nonatomic,strong) YMReportListData *data;///<数据


@end
