//
//  CallRecordDBManager.h
//  MyCloud
//
//  Created by test on 15/8/3.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallRecordDBManager : NSObject
/**
 *创建通话记录表
 */
+(void)creatCallRecordTable;

/**
 *插入或者更新通话记录数据
 */
+(BOOL)updateCallRecordWith:(NSDictionary *)record;

/**
 *获取通话记录数组
 */
+(NSArray *)getCallRecordArr;

/**
 *删除根据通话记录数据
 */
+(BOOL)deleteCallRecordWithUserId:(int)userId;

/**
 *清空所有的通话记录
 */
+(BOOL)deleteAllCallRecord;


@end
