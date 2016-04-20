//
//  PostJobWorkDateCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/22.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PostJobWorkDateDidChangeBlock)();

@interface PostJobWorkDateCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray *jobDates;///<时间数组

@property (nonatomic,assign) NSInteger defaultCount;///<默认每个日期招聘人数

@property (nonatomic,assign) NSInteger total;///<招聘总数

/**
 *  初始化方法
 *
 *  @param jobStatus
 *  @param reuseIdentifier
 *
 *  @return
 */
-(instancetype)initWithJobStatus:(PostJobStatus)jobStatus reuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  根据数据数量获取cell应展示高度
 */
+(CGFloat)getCellHeightWithDataCount:(NSInteger)dataCount PostJobStatus:(PostJobStatus)jobStatus;

/**
 *  获取改变的日期数组
 */
-(void)postJobWorkDateChanged:(PostJobWorkDateDidChangeBlock)changeBlock;

@end
