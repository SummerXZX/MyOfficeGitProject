//
//  YMAllEvaluateListResponse.h
//  NewYMOCCorpProject
//
//  Created by test on 16/2/17.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMAllEvaluateListResponse : YMResponse

@property (nonatomic,copy) NSArray<YMEvaluateInfo *> *data;///<列表记录

@end
