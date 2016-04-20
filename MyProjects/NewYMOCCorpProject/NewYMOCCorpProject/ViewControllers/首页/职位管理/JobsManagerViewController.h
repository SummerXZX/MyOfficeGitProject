//
//  JobsManagerViewController.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/15.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobManagerListCell.h"

@interface JobsManagerViewController : UIViewController

/**
 *  获取职位列表
 */
-(void)getJobListWithIsUpdate:(BOOL)isUpdate;

@property (nonatomic,assign) JobManagerListCellType cellType;

@end
