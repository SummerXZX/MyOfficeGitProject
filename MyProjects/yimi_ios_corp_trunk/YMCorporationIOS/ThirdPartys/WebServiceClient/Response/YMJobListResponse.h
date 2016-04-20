//
//  YMJobListResponse.h
//  YMCorporationIOS
//
//  Created by test on 15/7/4.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMJobSummary : NSObject
/**职位Id*/
@property (nonatomic) int id;
/**职位名称*/
@property (nonatomic,strong) NSString *name;
/**职位是否审核，0.未审核 1.已审核*/
@property (nonatomic) int isCheck;
/**职位薪资*/
@property (nonatomic) int pay;
/**职位薪资单位*/
@property (nonatomic) int payUnit;
/**招聘人数*/
@property (nonatomic) int count;
/**有效起始时间*/
@property (nonatomic) int startTime;
/**有效结束时间*/
@property (nonatomic) int endTime;
/**创建时间*/
@property (nonatomic) int creatTime;
/**地址*/
@property (nonatomic,strong) NSString *address;
@end


@interface YMJobListData : NSObject
/**数据数*/
@property (nonatomic) int count;
/**数据list*/
@property (nonatomic,strong) NSArray *list;

@end


@interface YMJobListResponse : YMResponse

@property (nonatomic,strong)YMJobListData *data;

@end
