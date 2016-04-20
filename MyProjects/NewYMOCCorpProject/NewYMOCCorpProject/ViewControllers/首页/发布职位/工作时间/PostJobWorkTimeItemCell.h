//
//  PostJobWorkTimeItemCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/22.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PostJobWorkTimeItemCellTypeDelete,///<带删除操作的
    PostJobWorkTimeItemCellTypeDetail,///<详情展示
} PostJobWorkTimeItemCellType;

@interface PostJobWorkTimeItemCell : UITableViewCell
/**
 *  初始化方法
 *
 *  @param type 
 */
-(instancetype)initWithType:(PostJobWorkTimeItemCellType)type;

/**
 *  获取重用标识符
 */
+(NSString *)getReuserIdentifierWithType:(PostJobWorkTimeItemCellType)type;

@property (weak, nonatomic) IBOutlet UIButton *deleteCellBtn;///<删除按钮

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;///<日期label



@end
