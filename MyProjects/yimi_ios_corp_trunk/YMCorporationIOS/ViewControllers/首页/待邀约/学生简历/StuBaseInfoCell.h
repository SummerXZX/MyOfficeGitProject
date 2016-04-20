//
//  StuBaseInfoCell.h
//  YMCorporationIOS
//
//  Created by test on 15/7/6.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StuBaseInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *stuSexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stuHeightLabel;

@end
