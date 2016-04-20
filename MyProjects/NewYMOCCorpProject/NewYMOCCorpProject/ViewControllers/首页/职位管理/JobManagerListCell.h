//
//  JobManagerListCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/24.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JobManagerListCellTypeChecking=100,///<审核中
    JobManagerListCellTypeRecruiting=101,///<招聘中
    JobManagerListCellTypeEnd=102,///<已结束

} JobManagerListCellType;


@interface JobManagerListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *jobTypeLogoImageView;///<职位类型imageview
@property (weak, nonatomic) IBOutlet UILabel *jobInfoLabel;///<职位信息label
@property (weak, nonatomic) IBOutlet UILabel *jobInfoDetailLabel;///<职位详细信息label
@property (weak, nonatomic) IBOutlet UILabel *statLabel;///<统计label
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;///<停招按钮

/**
 *  初始化方法
 *
 *  @param type
 *
 *  @return
 */
-(instancetype)initWithType:(JobManagerListCellType)type;

/**
 *  获取重用标识符
 */
+(NSString *)getReuserIdentifierWithType:(JobManagerListCellType)type;


@end
