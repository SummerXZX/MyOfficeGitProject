//
//  OrderInfoCell.h
//  YMCorporationIOS
//
//  Created by test on 15/7/13.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payMoneyLabelTop;
@property (weak, nonatomic) IBOutlet UILabel *workTimesLabel;
@end
