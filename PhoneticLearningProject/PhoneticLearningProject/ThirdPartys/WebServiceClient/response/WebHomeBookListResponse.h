//
//  WebHomeBookListResponse.h
//  PhoneticLearningProject
//
//  Created by test on 15/11/13.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "WebResponse.h"

@interface BookUnitInfo : NSObject

@property (nonatomic,assign) int id;///<单元id

@property (nonatomic,strong) NSString *name;///<单元名字

@property (nonatomic,strong) NSArray *courses;///<所有课程UnitCourseInfo

@end

@interface UnitCourseInfo : NSObject

@property (nonatomic,strong) NSString *name;///<课程名称

@property (nonatomic,strong) NSArray *coursefiles;///<课程文件CourseFileInfo

@end

@interface CourseFileInfo : NSObject

@property (nonatomic,strong) NSString *name;///<资源名称

@property (nonatomic,assign) int size;///<资源大小

@property (nonatomic,strong) NSString *type;///<资源类型

@property (nonatomic,strong) NSString *url;///<资源下载地址


@end

@interface HomeBookInfo : NSObject

@property (nonatomic,strong) NSString *imgUrl;///<课本图片url

@property (nonatomic,assign) int id;///<年纪分册id

@property (nonatomic,strong) NSString *dataXml;///<资源路径

@property (nonatomic,strong) NSString *bookSize;///<书本大小

@property (nonatomic,strong) NSString *subject;///<分类

@property (nonatomic,strong) NSString *name;///<书本名称

@property (nonatomic,strong) NSString *modifyTime;///<最后更新时间

@property (nonatomic,strong) NSString *stage;///<分册

@property (nonatomic,strong) NSArray *units;///<所有单元BookUnitInfo

@end

@interface WebHomeBookListData : NSObject

@property (nonatomic,strong) NSArray *data;///<HomeBookInfo数组

@property (nonatomic,assign) int totalNum;///<数据总数


@end


@interface WebHomeBookListResponse : WebResponse

@property (nonatomic,strong) WebHomeBookListData *data;///返回WebHomeBookListData数据

@end
