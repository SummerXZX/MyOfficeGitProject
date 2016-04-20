//
//  PostJobWorkTimeCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/22.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PostJobWorkTimeChangeBlock)();

@interface PostJobWorkTimeCell : UITableViewCell


@property (nonatomic,strong) NSMutableArray *workTimes;///<工作时间字符串

@property (nonatomic,strong) UIButton *unLimitBtn;///<不限按钮

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
 *  获取选择后的时间字符串
 */
-(void)postWorkTimeChanged:(PostJobWorkTimeChangeBlock)changeBlock;

@end
