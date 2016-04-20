//
//  JobCell.h
//  YMCorporationIOS
//
//  Created by test on 15/6/29.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *recuitCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *validDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
