//
//  DataBaseManager.h
//  YimiJob
//
//  Created by test on 15/5/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataBaseManager : NSObject

/**
 *获取本地数据库地址
 */
+(NSString *)getLocalDBPath;

/**
 *创建所有的本地数据库表
 */
+(void)creatLocalTables;


@end
