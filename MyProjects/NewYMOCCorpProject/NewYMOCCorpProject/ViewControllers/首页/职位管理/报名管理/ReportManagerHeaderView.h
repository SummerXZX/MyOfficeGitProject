//
//  ReportManagerHeaderView.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/29.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportManagerHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *jobTypeImageView;///<公司logo
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;///<职位名称label
@property (weak, nonatomic) IBOutlet UILabel *jobInfoLabel;///<职位信息label
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;///<薪资label
@property (weak, nonatomic) IBOutlet UIButton *allBtn;///<全部
@property (weak, nonatomic) IBOutlet UIButton *waitSignBtn;///<待签约
@property (weak, nonatomic) IBOutlet UIButton *waitPayBtn;///<待支付
@property (weak, nonatomic) IBOutlet UIButton *waitEvaluateBtn;///<待评价

@end
