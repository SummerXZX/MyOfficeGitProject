//
//  ReportManagerViewController.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportManagerViewController : UIViewController

@property (nonatomic,strong) YMJobListInfo *jobInfo;///<职位信息

/**
 *  获取报名列表
 */
-(void)getReportListWithIsUpdate:(BOOL)isUpdate;

@end
