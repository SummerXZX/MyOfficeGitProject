//
//  CityDataBaseManager.m
//  YMCorporationIOS
//
//  Created by test on 15/7/2.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "CityDataBaseManager.h"
#import "FMDatabase.h"
@implementation CityDataBaseManager

#pragma mark 获取省级数据
+(NSArray *)getProvince
{
    return [CityDataBaseManager getArrWithLevel:1 ParentId:0];
}

#pragma mark 获取市级数据
+(NSArray *)getCityWithParentId:(int)parentId
{
    return [CityDataBaseManager getArrWithLevel:2 ParentId:parentId];
}

#pragma mark 获取县级数据
+(NSArray *)getCountyWithParentId:(int)parentId
{
    return [CityDataBaseManager getArrWithLevel:3 ParentId:parentId];
}

#pragma mark 根据ID获取城市名字
+(NSString *)getCityNameWithType:(CityType)type CityId:(int)cityId
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yimi_city" ofType:@".db"];
    FMDatabase *cityDB = [FMDatabase databaseWithPath:path];
    NSString *name = @"";
    if ([cityDB open])
    {
        NSString *checkSql = [NSString stringWithFormat:@"SELECT *FROM v1city WHERE level = %ld AND id = %d",(long)type,cityId];
        FMResultSet *result = [cityDB executeQuery:checkSql];
        while ([result next])
        {
            name = [result stringForColumn:@"name"];
        }
    }
    [cityDB close];
    return name;
}

#pragma mark 根据level获取数据
+(NSArray *)getArrWithLevel:(int)level ParentId:(int)parentId
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yimi_city" ofType:@".db"];
    FMDatabase *cityDB = [FMDatabase databaseWithPath:path];
    NSMutableArray *tempArr = [NSMutableArray array];
    if ([cityDB open])
    {
        NSString *checkSql = [NSString stringWithFormat:@"SELECT *FROM v1city WHERE level = %d AND parentId = %d",level,parentId];
        FMResultSet *result = [cityDB executeQuery:checkSql];
        while ([result next])
        {
            int cityId = [result intForColumn:@"id"];
            NSString *name = [result stringForColumn:@"name"];
            [tempArr addObject:@{@"id":[NSNumber numberWithInt:cityId],@"name":name}];
        }
    }
    [cityDB close];
    return [NSArray arrayWithArray:tempArr];
}



@end
