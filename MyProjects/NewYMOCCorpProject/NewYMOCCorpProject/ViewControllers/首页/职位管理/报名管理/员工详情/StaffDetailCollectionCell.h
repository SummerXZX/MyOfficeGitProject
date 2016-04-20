//
//  StaffDetailCollectionCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/31.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffDetailCollectionCell : UITableViewCell

@property (nonatomic,assign) BOOL isExperience;///<是否是兼职经历

@property (nonatomic,strong) NSArray *itemArr;


/**
 *  获取cell高度
 */
+(CGFloat)getCellHeightWithDataCount:(NSInteger)dataCount;





@end
