//
//  PostJobWorkDateItemCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/22.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PostJobWorkDateItemCellTypeDelete,///<带删除操作的
    PostJobWorkDateItemCellTypeDetail,///<详情展示
} PostJobWorkDateItemCellType;

@interface PostJobWorkDateItemCell : UITableViewCell

/**
 *  初始化方法
 */
-(instancetype)initWithType:(PostJobWorkDateItemCellType)type;

/**
 *  获取重用标识符
 */
+(NSString *)getReuserIdentifierWithType:(PostJobWorkDateItemCellType)type;

@property (weak, nonatomic) IBOutlet UIButton *deleteCellBtn;///<删除按钮

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;///<日期label

@property (weak, nonatomic) IBOutlet UITextField *countField;///<人数label

@end
