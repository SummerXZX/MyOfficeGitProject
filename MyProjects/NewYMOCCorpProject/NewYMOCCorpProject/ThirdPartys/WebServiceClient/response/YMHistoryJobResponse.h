//
//  YMHistoryJobResponse.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/25.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMHistoryJobInfo : NSObject

@property (nonatomic,assign) NSInteger id;///<职位id

@property (nonatomic,copy) NSString *name;///<职位名称

@end

@interface YMHistoryJobResponse : YMResponse

@property (nonatomic,copy) NSArray *data;///<YMHistoryJobInfo数组

@end
