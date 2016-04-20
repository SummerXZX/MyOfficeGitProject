//
//  HasEvaluateInfoCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/2/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HasEvaluateInfoCell : UITableViewCell


@property (nonatomic,strong) NSArray *evaluateArr;///>数据


/**
 *  获取cell的高度
 *
 *  @param evaluateArr
 *
 *  @return
 */
+ (CGFloat)getCellHeightWithEvaluateArr:(NSArray *)evaluateArr;

/**
 *  初始化方法
 */
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier IsMyEvaluate:(BOOL)isMyEvaluate;

@end
