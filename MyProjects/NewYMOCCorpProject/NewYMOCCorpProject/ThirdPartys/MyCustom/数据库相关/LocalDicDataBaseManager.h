//
//  LocalDBHelper.h
//  YimiJob
//
//  Created by test on 15/5/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "DataBaseManager.h"

typedef NS_ENUM(NSInteger, LocalDicType)
{
    LocalDicTypeCorpIndustry, ///<企业所属产业：餐饮...
    LocalDicTypeCorpProperty, ///<企业性质：国有企业...
    LocalDicTypeCorpSize, ///<企业规模：20人以下...
    LocalDicTypeCorpType, ///<企业类型：商家...
    LocalDicTypeJobPayUnit, ///<工作支付工资的单位：元/小时...
    LocalDicTypeJobSettleType, ///<工作结算类型：日结...
    LocalDicTypeJobType, ///<工作类型：派单...
    LocalDicTypeJobTypeLogo, ///<工作类型logo：派单...
    LocalDicTypeJobStudentGrade, ///<工作学历要求：大专...
    LocalDicTypeJobStatus, ///<职位状态：待邀约...
    LocalDicTypeShareTitle, ///<分享内容
    
};


@interface LocalDicDataBaseManager : DataBaseManager

/**
 *插入或更新本地字典数据
 */
+(void)insertLocalDicDataWith:(NSArray *)arr;

/**
 *获取本地字典版本信息
 */
+(NSArray *)getLocalVerArr;

/**
 *获取企业所属产业：餐饮...
 */
+(NSArray *)getCorpIndustry;

/**
 *获取企业性质：国有企业...
 */
+(NSArray *)getCorpProperty;

/**
 *获取企业规模：20人以下...
 */
+(NSArray *)getCorpSize;

/**
 *获取企业类型：商家...
 */
+(NSArray *)getCorpType;

/**
 *获取工作支付工资的单位：元/小时...
 */
+(NSArray *)getJobPayUnit;

/**
 *获取工作结算类型：日结...
 */
+(NSArray *)getJobSettleType;

/**
 *获取工作类型：派单...
 */
+(NSArray *)getJobType;

/**
 *获取工作学历要求：大专...
 */
+(NSArray *)getJobStudentGrade;

/**
 *获取职位状态：待邀约...
 */
+(NSArray *)getJobStatus;

/**
 *根据VersionId获取name
 */
+(NSString *)getNameWithType:(LocalDicType)type VersionId:(NSInteger)versionId;

@end
