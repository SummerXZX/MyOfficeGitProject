//
//  DataBaseManager.m
//  YimiJob
//
//  Created by test on 15/5/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "BookDataBaseManager.h"
#import <FMDB.h>

@implementation BookDataBaseManager

#pragma mark 获取本地数据库地址
+ (NSString*)getBookDBPath
{
    NSString* path = [[NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
        stringByAppendingPathComponent:@"BookDB"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];

    return path;
}

#pragma mark 获取图书文件缓存地址
+(NSString *)getBookFilesPath {
    NSString* path = [[NSSearchPathForDirectoriesInDomains(
                                                           NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
                      stringByAppendingPathComponent:@"BookFiles"];
    return path;
}

#pragma mark 完整数据库地址
+ (NSString*)bookDBPath
{
    return [[BookDataBaseManager getBookDBPath]
            stringByAppendingPathComponent:@"Book.db"];
}

#pragma mark 创建所有的本地数据库表
+ (void)creatLocalTables
{
    //创建本地字典表
    NSString* path = [BookDataBaseManager bookDBPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        FMDatabase* bookDB = [[FMDatabase alloc] initWithPath:path];
        if ([bookDB open]) {
            [ProjectUtil showLog:@"打开本地字典数据库成功"];
            NSString* creatMyBookTableSqlStr = @"CREATE TABLE MyBook (id integer, name varchar(100)  PRIMARY KEY, modifyTime varchar(100))";
            BOOL result = [bookDB executeUpdate:creatMyBookTableSqlStr];
            if (result) {
                [ProjectUtil showLog:@"创建MyBook表成功"];
            }
            else {
                [ProjectUtil showLog:@"创建MyBook表失败"];
            }
            NSString *creatBookUnitSql = @"CREATE TABLE BookUnit (id integer,name varchar(100) PRIMARY KEY,bookname varchar(100))";
             result = [bookDB executeUpdate:creatBookUnitSql];
            if (result) {
                [ProjectUtil showLog:@"创建BookUnit表成功"];
            }
            else {
                [ProjectUtil showLog:@"创建BookUnit表失败"];
            }
            NSString* creatBookCourseTableSqlStr =
                @"CREATE TABLE UnitCourse (name varchar(100),unitname varchar(100), totalname varchar(100) PRIMARY KEY)";
            result = [bookDB executeUpdate:creatBookCourseTableSqlStr];

            if (result) {
                [ProjectUtil showLog:@"创建UnitCourse表成功"];
            }
            else {
                [ProjectUtil showLog:@"创建UnitCourse表失败"];
            }

            NSString* creatCourseFileTableSqlStr = @"CREATE TABLE CourseFile (name varchar(100),size integer,type varchar(30),url varchar(100) PRIMARY KEY,coursename varchar(100))";
            result = [bookDB executeUpdate:creatCourseFileTableSqlStr];

            if (result) {
                [ProjectUtil showLog:@"创建CourseFile表成功"];
            }
            else {
                [ProjectUtil showLog:@"创建CourseFile表失败"];
            }
        }
        [bookDB close];
    }
}

#pragma mark 插入图书数据
+(void)insertBooksWithBookInfo:(HomeBookInfo *)info{
    
    NSString* path = [BookDataBaseManager bookDBPath];
    FMDatabase* bookDB = [FMDatabase databaseWithPath:path];
    if ([bookDB open]) {
        //插入数据
        BOOL result = [bookDB executeUpdate:[NSString stringWithFormat:@"REPLACE INTO MyBook (id,name,modifyTime) VALUES (%d,'%@','%@')",info.id,info.name,info.modifyTime]];
        if (result == YES) {
            [ProjectUtil showLog:@"MyBook表中插入或者更新数据成功"];
        }
        else {
            [ProjectUtil showLog:@"MyBook表中插入或者更新数据失败"];
        }
        for (BookUnitInfo *unitInfo in info.units) {
    
            BOOL result = [bookDB executeUpdate:[NSString stringWithFormat:@"REPLACE INTO BookUnit (id,name,bookname) VALUES (%d,'%@','%@')",unitInfo.id,unitInfo.name,info.name]];
            if (result == YES) {
                [ProjectUtil showLog:@"BookUnit表中插入或者更新数据成功"];
            }
            else {
                [ProjectUtil showLog:@"BookUnit表中插入或者更新数据失败"];
            }
            for (UnitCourseInfo *courseInfo in unitInfo.courses) {
                
                BOOL result = [bookDB executeUpdate:[NSString stringWithFormat:@"REPLACE INTO UnitCourse (name,unitname,totalname) VALUES ('%@','%@','%@')",courseInfo.name,unitInfo.name,[NSString stringWithFormat:@"%@%@",unitInfo.name,courseInfo.name]]];
                if (result == YES) {
                    [ProjectUtil showLog:@"UnitCourse表中插入或者更新数据成功"];
                }
                else {
                    [ProjectUtil showLog:@"UnitCourse表中插入或者更新数据失败"];
                }
                for (CourseFileInfo *fileInfo in courseInfo.coursefiles) {
                    BOOL result = [bookDB executeUpdate:[NSString stringWithFormat:@"REPLACE INTO CourseFile (name,size,type,url,coursename) VALUES ('%@',%d,'%@','%@','%@')",fileInfo.name,fileInfo.size,fileInfo.type,fileInfo.url,courseInfo.name]];
                    if (result == YES) {
                        [ProjectUtil showLog:@"CourseFile表中插入或者更新数据成功"];
                    }
                    else {
                        [ProjectUtil showLog:@"CourseFile表中插入或者更新数据失败"];
                    }
                }
            }

        }
}
    [bookDB close];
}

#pragma mark 获取图书是否存在
+(BOOL)getBookIsExistWithBookName:(NSString *)bookName {
    NSString* path = [BookDataBaseManager bookDBPath];
    FMDatabase* bookDB = [FMDatabase databaseWithPath:path];
    BOOL exist = NO;
    if ([bookDB open]) {
        NSString *selectedSql = [NSString stringWithFormat:@"SELECT id FROM MyBook WHERE name = '%@'",bookName];
        FMResultSet *result = [bookDB executeQuery:selectedSql];
        
        while ([result next]) {
            exist = YES;
        }
    }
    [bookDB close];
    return exist;
}

#pragma mark 获取图书是否需要更新
+(BOOL)getBookIsNeedUpdateWithModifyTime:(NSString *)modifyTime {
    NSString* path = [BookDataBaseManager bookDBPath];
    FMDatabase* bookDB = [FMDatabase databaseWithPath:path];
    BOOL update = YES;
    if ([bookDB open]) {
        NSString *selectedSql = [NSString stringWithFormat:@"SELECT modifyTime FROM MyBook WHERE modifyTime = '%@'",modifyTime];
        FMResultSet *result = [bookDB executeQuery:selectedSql];
        while ([result next]) {
            update = NO;
        }
    }
    [bookDB close];
    return update;
}

#pragma mark 获取这本书的所有单元目录
+(NSArray *)getAllBookUnitWithBookName:(NSString *)bookname {
    NSString* path = [BookDataBaseManager bookDBPath];
    FMDatabase* bookDB = [FMDatabase databaseWithPath:path];
    NSMutableArray *tempArr = [NSMutableArray array];
    if ([bookDB open]) {
        NSString *selectedSql = [NSString stringWithFormat:@"SELECT * FROM BookUnit WHERE bookname = '%@'",bookname];
        FMResultSet *result = [bookDB executeQuery:selectedSql];
        while ([result next]) {
            BookUnitInfo *unitInfo = [[BookUnitInfo alloc]init];
            unitInfo.id = [result intForColumn:@"id"];
            unitInfo.name = [result stringForColumn:@"name"];
            [tempArr addObject:unitInfo];
        }
    }
    [bookDB close];
    return [NSArray arrayWithArray:tempArr];
}

#pragma mark 获取单元下所有课程
+(NSArray *)getAllBookUnitCourseWithUnitName:(NSString *)unitname {
    NSString* path = [BookDataBaseManager bookDBPath];
    FMDatabase* bookDB = [FMDatabase databaseWithPath:path];
    NSMutableArray *tempArr = [NSMutableArray array];
    if ([bookDB open]) {
        NSString *selectedSql = [NSString stringWithFormat:@"SELECT * FROM UnitCourse WHERE unitname = '%@'",unitname];
        FMResultSet *result = [bookDB executeQuery:selectedSql];
        while ([result next]) {
            UnitCourseInfo *courseInfo = [[UnitCourseInfo alloc]init];
            courseInfo.name = [result stringForColumn:@"name"];
            [tempArr addObject:courseInfo];
        }
    }
    [bookDB close];
    return [NSArray arrayWithArray:tempArr];
}

@end
