//
//  PostOtherRequireCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RequireChangedBlock)();

@interface PostOtherRequireCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;///<标题label

@property (nonatomic,strong) NSArray *itemArr;///<数据数组

@property (nonatomic,assign) NSInteger selectedDicId;///<选中字典的值

/**
 *  根据项目数目获取高度
 */
+(CGFloat)getCellHeightWithDataCount:(NSInteger)dataCount;


/**
 *  要求变更
 */
- (void)requireChanged:(RequireChangedBlock)changeBlock;

@end
