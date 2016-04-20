//
//  StaffDetailWorkDateCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/28.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffDetailWorkDateCell : UITableViewCell

@property (nonatomic,strong) NSArray *workDates;///<工作日期

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;///<展开收起按钮

/**
 *  获取cell高度
 */
+(CGFloat)getStaffDetailWorkDateCellHeightWithDataCount:(NSInteger)count;
@end
