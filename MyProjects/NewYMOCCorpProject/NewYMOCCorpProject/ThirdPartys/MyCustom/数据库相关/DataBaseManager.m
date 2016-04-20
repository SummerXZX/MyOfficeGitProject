//
//  DataBaseManager.m
//  YimiJob
//
//  Created by test on 15/5/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "DataBaseManager.h"

@implementation DataBaseManager

#pragma mark 获取本地数据库地址
+ (NSString*)getLocalDBPath
{
    NSString* path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"localdb"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];

    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"localdb"];
}

#pragma mark 创建所有的本地数据库表
+ (void)creatLocalTables
{
    //创建本地字典表
    NSString* path = [DataBaseManager getLocalDBPath];
    path = [path stringByAppendingPathComponent:@"localDic.db"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        FMDatabase* localDicDB = [[FMDatabase alloc] initWithPath:path];
        if ([localDicDB open]) {
            [ProjectUtil showLog:@"打开本地字典数据库成功"];
            NSString* creatLocalDicTableSqlStr = @"CREATE TABLE LocalDic(dicName VARCHAR(20) PRIMARY KEY,dicVer INTEGER)";

            BOOL result = [localDicDB executeUpdate:creatLocalDicTableSqlStr];
            if (result) {
                [ProjectUtil showLog:@"创建LocalDic表成功"];
            }
            else {
                [ProjectUtil showLog:@"创建LocalDic表失败"];
            }

            NSString* creatVersionTableSqlStr = @"CREATE TABLE DicVersions (versionsId INTEGER,name VARCHAR(30) , dicName VARCHAR(20) ,versionsSign VARCHAR(30) PRIMARY KEY)";
            result = [localDicDB executeUpdate:creatVersionTableSqlStr];

            if (result) {
                [ProjectUtil showLog:@"创建versions表成功"];
            }
            else {
                [ProjectUtil showLog:@"创建versions表失败"];
            }

        }
        [localDicDB close];
    }
}

@end
