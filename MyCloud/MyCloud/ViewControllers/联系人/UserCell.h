//
//  UserCell.h
//  MyCloud
//
//  Created by test on 15/7/27.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end
