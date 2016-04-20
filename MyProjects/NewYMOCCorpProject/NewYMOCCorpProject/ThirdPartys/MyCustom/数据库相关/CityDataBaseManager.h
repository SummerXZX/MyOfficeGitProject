//
//  CityDataBaseManager.h
//  YMCorporationIOS
//
//  Created by test on 15/7/2.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, CityType)
{
    CityTypeCity = 2,
    CityTypeCounty = 3,
};

@interface CityDataBaseManager : NSObject

/**
 *获取省级数据
 */
+(NSArray *)getProvince;

/**
 *  获取所有城市
 */
+(NSArray *)getCity;

/**
 *  获取城市letter
 */
+(NSArray *)getCityLetters;

/**
 *获取市级数据
 */
+(NSArray *)getCityWithParentId:(NSInteger)parentId;

/**
 *获取县级数据
 */
+(NSArray *)getCountyWithParentId:(NSInteger)parentId;

/**
 *根据ID获取城市名字
 */
+(NSString *)getCityNameWithType:(CityType)type CityId:(NSInteger)cityId;

@end
