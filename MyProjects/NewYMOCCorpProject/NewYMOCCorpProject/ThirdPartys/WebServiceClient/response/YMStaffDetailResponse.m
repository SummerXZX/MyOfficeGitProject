//
//  YMStaffDetailResponse.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/28.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMStaffDetailResponse.h"

@implementation YMEvaluateInfo


@end

@implementation YMStuResumeInfo


@end

@implementation YMStaffDetailExperienceInfo


@end

@implementation YMStaffDetailInfo

+ (NSDictionary *)objectClassInArray{
    return @{@"evaluates" : [YMEvaluateInfo class],@"workExperience":[YMStaffDetailExperienceInfo class]};
}



@end

@implementation YMStaffDetailResponse

@end
