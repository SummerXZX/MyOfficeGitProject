//
//  EvaluateEditCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/31.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EvaluateEditCellAddBlock)();

@interface EvaluateEditCell : UITableViewCell

@property (nonatomic,strong) YMMyEvaluateInfo *evaluateInfo;///<我的评价信息

/**
 *  增加点评
 */
-(void)evaluateEditCellAddEvaluate:(EvaluateEditCellAddBlock)addBlock;

/**
 *  获取cell高度
 */
+(CGFloat)getCellHeightWithMyEvaluateInfo:(YMMyEvaluateInfo *)evaluateInfo;

@end
