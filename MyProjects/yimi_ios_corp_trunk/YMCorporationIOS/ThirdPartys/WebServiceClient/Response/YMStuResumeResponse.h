//
//  YMStuResumeResponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/7.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMStuResumeSummary : NSObject

/**学生名字*/
@property (nonatomic,strong) NSString *name;
/**学生性别*/
@property (nonatomic) int sex;
/**学生身高*/
@property (nonatomic) int height;
/**学生体重*/
@property (nonatomic) int weight;
/**学生生日*/
@property (nonatomic,strong) NSString *birthday;
/**学生自我描述*/
@property (nonatomic,strong) NSString *intro;
/**城市id*/
@property (nonatomic) int cityId;
/**学生头像*/
@property (nonatomic,strong) NSString *photoscale;
/**城市名字*/
@property (nonatomic,strong) NSString *city;
/**学校id*/
@property (nonatomic) int schoolId;
/**学校名字*/
@property (nonatomic,strong) NSString *school;
/**学生专业*/
@property (nonatomic,strong) NSString *major;
/**学生学历*/
@property (nonatomic) int grade;
/**学生电话*/
@property (nonatomic,strong) NSString *phone;
/**学生qq*/
@property (nonatomic,strong) NSString *qq;
/**学生邮箱*/
@property (nonatomic,strong) NSString *email;

@end

@interface YMStuResumeResponse : YMResponse

@property (nonatomic,strong) YMStuResumeSummary *data;

@end
