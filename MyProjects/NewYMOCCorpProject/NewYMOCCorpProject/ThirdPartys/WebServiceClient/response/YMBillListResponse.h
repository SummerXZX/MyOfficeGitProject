//
//  YMBillListResponse.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/21.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMResponse.h"


@interface YMBillInfo : NSObject

@property (nonatomic,copy) NSString *name;///<账单说明

@property (nonatomic,assign) double amount;///<账单金额

@property (nonatomic,assign) NSInteger time;///<账单时间

@end

@interface YMBillListData : NSObject

@property (nonatomic,copy) NSArray<YMBillInfo *> *list;///<列表记录

@property (nonatomic,assign) NSInteger count;///<列表总数

@end


@interface YMBillListResponse : YMResponse

@property (nonatomic,strong) YMBillListData *data;///<数据

@end
