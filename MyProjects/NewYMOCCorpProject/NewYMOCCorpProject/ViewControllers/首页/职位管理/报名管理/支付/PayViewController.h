//
//  PayViewController.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : UIViewController

@property (nonatomic,strong) YMReportInfo *reportInfo;///<报名信息

@property (nonatomic,assign) NSInteger jobId;///<职位id

@property (nonatomic,assign) NSInteger payType;///<职位类型

@end
