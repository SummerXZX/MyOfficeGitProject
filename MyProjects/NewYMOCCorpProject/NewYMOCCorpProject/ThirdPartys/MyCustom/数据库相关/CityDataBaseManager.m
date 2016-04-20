//
//  CityDataBaseManager.m
//  YMCorporationIOS
//
//  Created by test on 15/7/2.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "CityDataBaseManager.h"
#import "FMDatabase.h"
#import <PinYin4Objc.h>

@implementation CityDataBaseManager

#pragma mark 获取省级数据
+(NSArray *)getProvince
{
    return [CityDataBaseManager getArrWithLevel:1 ParentId:0];
}

#pragma mark 获取所有城市
+(NSArray *)getCity {
    return [CityDataBaseManager getSortArrWithLevel:2];
}

#pragma mark 获取城市letter
+(NSArray *)getCityLetters {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yimi_city" ofType:@".db"];
    FMDatabase *cityDB = [FMDatabase databaseWithPath:path];
    NSMutableArray *tempArr = [NSMutableArray array];
    if ([cityDB open]) {
        FMResultSet *result = [cityDB executeQuery:@"SELECT DISTINCT letter FROM v1city WHERE level = 2 ORDER BY letter"];
        while ([result next])
        {
            NSString *letter = [result stringForColumn:@"letter"];
            [tempArr addObject:letter];
        }
    }
    [cityDB close];
    return [NSArray arrayWithArray:tempArr];
}

#pragma mark 获取市级数据
+(NSArray *)getCityWithParentId:(NSInteger)parentId
{
    return [CityDataBaseManager getArrWithLevel:2 ParentId:parentId];
}

#pragma mark 获取县级数据
+(NSArray *)getCountyWithParentId:(NSInteger)parentId
{
    return [CityDataBaseManager getArrWithLevel:3 ParentId:parentId];
}

#pragma mark 根据ID获取城市名字
+(NSString *)getCityNameWithType:(CityType)type CityId:(NSInteger)cityId
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yimi_city" ofType:@".db"];
    FMDatabase *cityDB = [FMDatabase databaseWithPath:path];
    NSString *name = @"";
    if ([cityDB open])
    {
        NSString *checkSql = [NSString stringWithFormat:@"SELECT *FROM v1city WHERE level = %ld AND id = %ld",(long)type,(long)cityId];
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
+(NSArray *)getArrWithLevel:(NSInteger)level ParentId:(NSInteger)parentId
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yimi_city" ofType:@".db"];
    FMDatabase *cityDB = [FMDatabase databaseWithPath:path];
    NSMutableArray *tempArr = [NSMutableArray array];
    if ([cityDB open])
    {
        NSString *checkSql = @"";
        if (parentId==0) {
            checkSql = [NSString stringWithFormat:@"SELECT *FROM v1city WHERE level = %ld ORDER BY letter",(long)level];
        }
        else {
            checkSql = [NSString stringWithFormat:@"SELECT *FROM v1city WHERE level = %ld AND parentId = %ld ORDER BY letter",(long)level,(long)parentId];
        }
        FMResultSet *result = [cityDB executeQuery:checkSql];
        while ([result next])
        {
            NSInteger cityId = [result intForColumn:@"id"];
            NSString *name = [result stringForColumn:@"name"];
            NSString *letter = [result stringForColumn:@"letter"];
            [tempArr addObject:@{@"id":[NSNumber numberWithInteger:cityId],@"name":name,@"letter":letter}];
        }
    }
    [cityDB close];
    return [NSArray arrayWithArray:tempArr];
}


+(NSArray *)getSortArrWithLevel:(NSInteger)level {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yimi_city" ofType:@".db"];
    FMDatabase *cityDB = [FMDatabase databaseWithPath:path];
    NSMutableArray *tempArr = [NSMutableArray array];
    if ([cityDB open]) {
        NSString *checkSql = [NSString stringWithFormat:@"SELECT DISTINCT letter FROM v1city WHERE level = %ld ORDER BY letter",(long)level];
        FMResultSet *result = [cityDB executeQuery:checkSql];
        
        while ([result next])
        {
            NSString *letter = [result stringForColumn:@"letter"];
            NSString *checkSql1 = [NSString stringWithFormat:@"SELECT *FROM v1city WHERE level = %ld AND letter = '%@' ORDER BY name",(long)level,letter];
            FMResultSet *result1 = [cityDB executeQuery:checkSql1];
            NSMutableArray *letterArr = [NSMutableArray array];
            while ([result1 next]) {
                NSInteger cityId = [result1 intForColumn:@"id"];
                NSString *name = [result1 stringForColumn:@"name"];
                NSString *letter = [result1 stringForColumn:@"letter"];
                HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
                [outputFormat setToneType:ToneTypeWithoutTone];
                [outputFormat setVCharType:VCharTypeWithV];
                [outputFormat setCaseType:CaseTypeLowercase];
                NSString *cityPinYinName = [PinyinHelper toHanyuPinyinStringWithNSString:name withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
                [letterArr addObject:@{@"id":@(cityId),@"name":name,@"letter":letter,@"ename":cityPinYinName}];
            }
            [tempArr addObject:@{@"letter":letter,@"items":letterArr}];
        }
    }
    return [NSArray arrayWithArray:tempArr];
}




@end
