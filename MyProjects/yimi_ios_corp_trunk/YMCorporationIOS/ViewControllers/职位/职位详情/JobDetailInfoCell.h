//
//  JobDetailInfoCell.h
//  YMCorporationIOS
//
//  Created by test on 15/7/3.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *recruitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *validTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
