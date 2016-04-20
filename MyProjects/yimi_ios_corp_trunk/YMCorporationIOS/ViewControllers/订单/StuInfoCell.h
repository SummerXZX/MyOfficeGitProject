//
//  OrderStuInfoCell.h
//  YMCorporationIOS
//
//  Created by test on 15/7/13.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StuInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stuNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stuAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *stuPhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIImageView *stuSexImageView;

@end
