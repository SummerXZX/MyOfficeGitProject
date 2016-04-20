//
//  CallRecordDBManager.m
//  MyCloud
//
//  Created by test on 15/8/3.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "CallRecordDBManager.h"
#import <FMDB.h>

@implementation CallRecordDBManager
#pragma mark 创建通话记录表
+(void)creatCallRecordTable
{
    NSString *path = [CallRecordDBManager getCallRecordDBPath];
    [ProjectUtil showLog:@"通话记录本地数据库地址：%@",path];
    path = [path stringByAppendingPathComponent:@"CallRecord.db"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        FMDatabase *callRecordDB = [[FMDatabase alloc]initWithPath:path];
        if ([callRecordDB open])
        {
            [ProjectUtil showLog:@"打开通话记录本地数据库成功"];
            NSString *creatLocalDicTableSqlStr = @"CREATE TABLE CallRecord (calluserid int PRIMARY KEY,callnum varchar(20),callname varchar(20),callavatar varchar(200),calltime int)";
            BOOL success = [callRecordDB executeUpdate:creatLocalDicTableSqlStr];
            if (success)
            {
                [ProjectUtil showLog:@"创建通话记录表成功"];
            }
            else
            {
                [ProjectUtil showLog:@"创建通话记录表失败"];
            }
        }
        [callRecordDB close];
    }
}

#pragma mark 获取本地数据库地址
+(NSString *)getCallRecordDBPath
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"CallRecordDB"];
    [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    return path;
}

#pragma mark 插入或者更新通话记录数据
+(BOOL)updateCallRecordWith:(NSDictionary *)record
{
    NSString *path = [CallRecordDBManager getCallRecordDBPath];
    path = [path stringByAppendingPathComponent:@"CallRecord.db"];
    FMDatabase *callRecordDB = [[FMDatabase alloc]initWithPath:path];
    if ([callRecordDB open])
    {
        NSString *checkSql = [NSString stringWithFormat:@"SELECT * FROM CallRecord WHERE calluserid = %d",[record[@"calluserid"]intValue]];
        FMResultSet *checkResult = [callRecordDB executeQuery:checkSql];
        NSString *updateSql = @"";
        if (![checkResult next])
        {
            [ProjectUtil showLog:@"插入通话记录表数据"];
            updateSql = [NSString stringWithFormat:@"INSERT INTO CallRecord VALUES (%d,'%@','%@','%@',%d)",[record[@"calluserid"]intValue],record[@"callnum"],record[@"callname"],record[@"callavatar"],[record[@"calltime"]intValue]];
        }
        else
        {
            [ProjectUtil showLog:@"更新通话记录表数据"];
            updateSql = [NSString stringWithFormat:@"UPDATE CallRecord SET callnum = '%@',callname = '%@',callavatar = '%@',calltime = %d WHERE calluserid = %d",record[@"callnum"],record[@"callname"],record[@"callavatar"],[record[@"calltime"]intValue],[record[@"calluserid"]intValue]];
        }
        BOOL success = [callRecordDB executeUpdate:updateSql];
        if (success)
        {
            [ProjectUtil showLog:@"更新通话记录表数据成功"];
        }
        else
        {
            [ProjectUtil showLog:@"更新通话记录表数据失败"];
        }
        [callRecordDB close];
        return success;
    }
    else
    {
        [ProjectUtil showLog:@"打开通话记录表失败"];
        return NO;
    }
    
}

#pragma mark 获取通话记录数组
+(NSArray *)getCallRecordArr
{
    NSString *path = [CallRecordDBManager getCallRecordDBPath];
    path = [path stringByAppendingPathComponent:@"CallRecord.db"];
    FMDatabase *callRecordDB = [[FMDatabase alloc]initWithPath:path];
    NSMutableArray *tempArr = [NSMutableArray array];
    if ([callRecordDB open])
    {
        NSString *sql = @"SELECT * FROM CallRecord LIMIT 0,30";
        FMResultSet *reslut = [callRecordDB executeQuery:sql];
        while ([reslut next])
        {
            int calluserid = [reslut intForColumn:@"calluserid"];
            NSString *callnum = [reslut stringForColumn:@"callnum"];
            NSString *callname = [reslut stringForColumn:@"callname"];
            NSString *callavatar = [reslut stringForColumn:@"callavatar"];
            int calltime = [reslut intForColumn:@"calltime"];
        [tempArr addObject:@{@"calluserid":[NSNumber numberWithInt:calluserid],@"callnum":callnum,@"callname":callname,@"callavatar":callavatar,@"calltime":[NSNumber numberWithInt:calltime]}];
        }
        [callRecordDB close];
    }
    return [NSArray arrayWithArray:tempArr];
}

#pragma mark 删除通话记录数据
+(BOOL)deleteCallRecordWithUserId:(int)userId
{
    NSString *path = [CallRecordDBManager getCallRecordDBPath];
    path = [path stringByAppendingPathComponent:@"CallRecord.db"];
    FMDatabase *callRecordDB = [[FMDatabase alloc]initWithPath:path];
    if ([callRecordDB open])
    {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM CallRecord WHERE calluserid = %d",userId];
        BOOL success = [callRecordDB executeUpdate:sql];
        if (success)
        {
            [ProjectUtil showLog:@"删除通话记录用户id为%d数据成功",userId];
            
        }
        else
        {
            [ProjectUtil showLog:@"删除通话记录用户id为%d数据失败",userId];
        }
        [callRecordDB close];
        return success;
    }
    return NO;
    
}

#pragma mark 清空所有的通话记录
+(BOOL)deleteAllCallRecord
{
    NSString *path = [CallRecordDBManager getCallRecordDBPath];
    path = [path stringByAppendingPathComponent:@"CallRecord.db"];
    FMDatabase *callRecordDB = [[FMDatabase alloc]initWithPath:path];
    if ([callRecordDB open])
    {
        NSString *sql = @"DELETE FROM CallRecord";
        BOOL success = [callRecordDB executeUpdate:sql];
        if (success)
        {
            [ProjectUtil showLog:@"删除通话记录用户数据成功"];
            
        }
        else
        {
            [ProjectUtil showLog:@"删除通话记录用户数据失败"];
        }
        [callRecordDB close];
        return success;
    }
    return NO;
}



@end
