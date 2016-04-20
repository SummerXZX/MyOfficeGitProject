//
//  YMMyEvaluateInfoResponse.h
//  NewYMOCCorpProject
//
//  Created by test on 16/2/17.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMResponse.h"

typedef enum : NSUInteger {
    EvaluateTypeGood=1,///<好评
    EvaluateTypeMiddle,///<中评
    EvaluateTypeBad,///<坏评
} EvaluateType;


@interface YMMyEvaluateInfo : NSObject

@property (nonatomic, assign) NSInteger corpId;///<商家id

@property (nonatomic, assign) NSInteger regiId;///<报名id

@property (nonatomic, assign) NSInteger id;///<评价id

@property (nonatomic, copy) NSString *describe;///<评价描述

@property (nonatomic, assign) NSInteger creatTime;///<创建时间

@property (nonatomic, assign) NSInteger level;///<类型 1 好评 2中评 3差评

@property (nonatomic, assign) NSInteger stuId;///<学生id

@property (nonatomic, assign) NSInteger jobId;///<职位id

@property (nonatomic, copy) NSArray *evaluateArr;///<存放评价的数组

@property (nonatomic, assign) NSInteger myEvaluateCount;///<我的评论次数

@end

@interface YMMyEvaluateInfoData : NSObject

@property (nonatomic,strong) YMMyEvaluateInfo *corpEvaluate;///<商家评价

@property (nonatomic,strong) YMMyEvaluateInfo *stuEvaluate;///<学生评价

@property (nonatomic,assign) NSInteger praise;///<好评率

@property (nonatomic,copy) NSString *stuPhone;///<电话

@property (nonatomic,copy) NSString *stuName;///<学生名称

@property (nonatomic,assign) NSInteger sex;///<学生性别

@end


@interface YMMyEvaluateInfoResponse : YMResponse

@property (nonatomic,strong) YMMyEvaluateInfoData *data;

@end
