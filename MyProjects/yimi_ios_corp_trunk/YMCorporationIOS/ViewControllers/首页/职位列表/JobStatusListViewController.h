//
//  OnRecruitViewController.h
//  YMCorporationIOS
//
//  Created by test on 15/7/3.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ModelViewController.h"
typedef NS_ENUM(NSInteger, JobStatus)
{
    JobStatusChecked = 2,
    JobStatusUnChecked = 1,
};
@interface JobStatusListViewController : ModelViewController

@property (nonatomic)JobStatus jobStatus;

@end
