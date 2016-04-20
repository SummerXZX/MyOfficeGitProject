//
//  DataBaseManager.h
//  YimiJob
//
//  Created by test on 15/5/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface BookDataBaseManager : NSObject

/**
 *获取本地数据库地址
 */
+ (NSString*)getBookDBPath;

/**
 *获取图书文件缓存地址
 */
+ (NSString*)getBookFilesPath;

/**
 *创建所有的本地数据库表
 */
+ (void)creatLocalTables;

/**
 *  插入图书数据
 */
+ (void)insertBooksWithBookInfo:(HomeBookInfo *)info;

/**
 *  获取图书是否存在
 */
+ (BOOL)getBookIsExistWithBookName:(NSString *)bookName;

/**
 *  获取图书是否需要更新
 */
+ (BOOL)getBookIsNeedUpdateWithModifyTime:(NSString *)modifyTime;

/**
 *  获取这本书的所有单元目录
 */
+ (NSArray *)getAllBookUnitWithBookName:(NSString *)bookname;

/**
 *  获取单元下所有课程
 */
+ (NSArray *)getAllBookUnitCourseWithUnitName:(NSString *)unitname;

@end
