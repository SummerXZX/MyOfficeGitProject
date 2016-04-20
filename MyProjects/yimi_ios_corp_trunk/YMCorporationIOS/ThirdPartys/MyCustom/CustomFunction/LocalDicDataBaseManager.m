//
//  LocalDBHelper.m
//  YimiJob
//
//  Created by test on 15/5/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "LocalDicDataBaseManager.h"

@implementation LocalDicDataBaseManager

#pragma mark 插入本地字典数据
+ (void)insertLocalDicDataWith:(NSArray*)arr
{
    NSString* path = [LocalDicDataBaseManager localDicDBPath];
    FMDatabase* localDicDB = [FMDatabase databaseWithPath:path];

    if ([localDicDB open]) {
        for (int i = 0; i < arr.count; i++) {
            NSDictionary* localDic = arr[i];
            //判断表中是否有这个数据有则更新 无则插入
            NSString* replaceSql = [NSString stringWithFormat:@"REPLACE INTO LocalDic (dicName,dicVer) VALUES ('%@',%d)", localDic[@"tableName"], [localDic[@"tableVer"] intValue]];
            BOOL result = [localDicDB executeUpdate:replaceSql];
            if (result == YES) {
                [ProjectUtil showLog:@"LocalDic表中插入或者更新数据成功"];
            }
            else {
                [ProjectUtil showLog:@"LocalDic表中插入或者更新数据失败"];
            }
            //先清空数据
            NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM DicVersions WHERE dicName = '%@'",localDic[@"tableName"]];
            [localDicDB executeUpdate:deleteSql];
            
            NSArray* versionsArr = localDic[@"versions"];
            for (int j = 0; j < versionsArr.count; j++) {
                                
                NSDictionary* versionsDic = versionsArr[j];
                //判断表中是否有这个数据有则更新 无则插入
                NSString* versionsReplaceSql = [NSString stringWithFormat:@"REPLACE INTO DicVersions (dicName,name,versionsId,versionsSign) VALUES ('%@','%@',%d,'%@')", localDic[@"tableName"], versionsDic[@"name"], [versionsDic[@"id"] intValue], [NSString stringWithFormat:@"%d%@", [versionsDic[@"id"] intValue], localDic[@"tableName"]]];
                BOOL result = [localDicDB executeUpdate:versionsReplaceSql];
                if (result == YES) {
                    [ProjectUtil showLog:@"versions表中插入或更新数据成功"];
                }
                else {
                    [ProjectUtil showLog:@"versions表中插入或更新数据失败"];
                }
            }
        }
    }
    //关闭数据库
    [localDicDB close];
}

#pragma mark 完整数据库地址
+ (NSString*)localDicDBPath
{
    return [[LocalDicDataBaseManager getLocalDBPath] stringByAppendingPathComponent:@"localDic.db"];
}

+ (NSArray*)getLocalVerArr
{
    NSString* path = [LocalDicDataBaseManager localDicDBPath];
    [ProjectUtil showLog:@"dbPath:%@", path];
    FMDatabase* localDicDB = [FMDatabase databaseWithPath:path];
    NSMutableArray* tempArr = [NSMutableArray array];
    if ([localDicDB open]) {
        NSString* checkSql = @"SELECT * FROM LocalDic";
        FMResultSet* result = [localDicDB executeQuery:checkSql];
        while ([result next]) {
            int dicVer = [result intForColumn:@"dicVer"];
            NSString* dicName = [result stringForColumn:@"dicName"];
            [tempArr addObject:@{ @"tableName" : dicName,
                @"tableVer" : [NSNumber numberWithInt:dicVer] }];
        }
    }
    [localDicDB close];
    return [NSArray arrayWithArray:tempArr];
}

#pragma mark 获取企业所属产业
+ (NSArray*)getCorpIndustry
{
    return [LocalDicDataBaseManager getVersionArrWithDicType:LocalDicTypeCorpIndustry];
}

#pragma mark 获取企业性质
+ (NSArray*)getCorpProperty
{
    return [LocalDicDataBaseManager getVersionArrWithDicType:LocalDicTypeCorpProperty];
}

#pragma mark 获取企业规模
+ (NSArray*)getCorpSize
{
    return [LocalDicDataBaseManager getVersionArrWithDicType:LocalDicTypeCorpSize];
}

#pragma mark 获取企业类型
+ (NSArray*)getCorpType
{
    return [LocalDicDataBaseManager getVersionArrWithDicType:LocalDicTypeCorpType];
}

#pragma mark 获取工作支付工资的单位
+ (NSArray*)getJobPayUnit
{
    return [LocalDicDataBaseManager getVersionArrWithDicType:LocalDicTypeJobPayUnit];
}

#pragma mark 获取工作结算类型
+ (NSArray*)getJobSettleType
{
    return [LocalDicDataBaseManager getVersionArrWithDicType:LocalDicTypeJobSettleType];
}

#pragma mark 获取工作类型
+ (NSArray*)getJobType
{
    return [LocalDicDataBaseManager getVersionArrWithDicType:LocalDicTypeJobType];
}

#pragma mark 获取工作学历要求
+ (NSArray*)getJobStudentGrade
{
    return [LocalDicDataBaseManager getVersionArrWithDicType:LocalDicTypeJobStudentGrade];
}

#pragma mark 获取职位状态
+ (NSArray*)getJobStatus
{
    return [LocalDicDataBaseManager getVersionArrWithDicType:LocalDicTypeJobStatus];
}

#pragma mark 根据dicType获取versions数据
+ (NSArray*)getVersionArrWithDicType:(LocalDicType)dicType
{

    NSString* path = [LocalDicDataBaseManager localDicDBPath];
    FMDatabase* localDicDB = [FMDatabase databaseWithPath:path];
    NSMutableArray* tempArr = [NSMutableArray array];
    if ([localDicDB open]) {
        NSString* dicName = [LocalDicDataBaseManager getLocalDicNameWithType:dicType];
        NSString* checkSql = [NSString stringWithFormat:@"SELECT * FROM DicVersions WHERE dicName = '%@'", dicName];
        FMResultSet* result = [localDicDB executeQuery:checkSql];

        while ([result next]) {
            int versionsId = [result intForColumn:@"versionsId"];
            NSString* nameStr = [result stringForColumn:@"name"];
            [tempArr addObject:@{ @"id" : [NSNumber numberWithInt:versionsId],
                @"name" : nameStr }];
        }
    }
    [localDicDB close];

    return [NSArray arrayWithArray:tempArr];
}

#pragma mark 根据localType获取字典名字
+ (NSString*)getLocalDicNameWithType:(LocalDicType)type
{
    if (type == LocalDicTypeCorpIndustry) {
        return @"v1corpindustry";
    }
    else if (type == LocalDicTypeCorpProperty) {
        return @"v1corpproperty";
    }
    else if (type == LocalDicTypeCorpSize) {
        return @"v1corpsize";
    }
    else if (type == LocalDicTypeCorpType) {
        return @"v1corptype";
    }
    else if (type == LocalDicTypeJobPayUnit) {
        return @"v1jobpayunit";
    }
    else if (type == LocalDicTypeJobSettleType) {
        return @"v1jobsettletype";
    }
    else if (type == LocalDicTypeJobType) {
        return @"v1jobtype";
    }
    else if (type == LocalDicTypeJobStudentGrade) {
        return @"v1stugrade";
    }
    else if (type == LocalDicTypeJobStatus) {
        return @"v1jobregistatus";
    }
    else if (type == LocalDicTypeShareTitle) {
        return @"v1sharetitle";
    }
    return @"";
}

#pragma mark 根据TypeId获取name
+ (NSString*)getNameWithType:(LocalDicType)type VersionId:(int)versionId
{
    NSString* path = [LocalDicDataBaseManager localDicDBPath];
    FMDatabase* localDicDB = [FMDatabase databaseWithPath:path];
    NSString* nameStr = @"";
    if ([localDicDB open]) {
        NSString* dicName = [LocalDicDataBaseManager getLocalDicNameWithType:type];
        NSString* checkSql = [NSString stringWithFormat:@"SELECT * FROM DicVersions WHERE dicName = '%@' AND versionsId = %d", dicName, versionId];
        FMResultSet* result = [localDicDB executeQuery:checkSql];

        while ([result next]) {
            nameStr = [result stringForColumn:@"name"];
        }
    }
    [localDicDB close];
    return nameStr;
}
@end
