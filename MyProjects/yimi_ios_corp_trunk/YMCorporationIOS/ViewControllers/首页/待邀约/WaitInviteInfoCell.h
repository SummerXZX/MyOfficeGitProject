//
//  WaitInviteInfoCell.h
//  YMCorporationIOS
//
//  Created by test on 15/7/6.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitInviteInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;

@end
