//
//  CallRecordCell.h
//  MyCloud
//
//  Created by test on 15/8/4.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *callUserInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *callTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *callAvatarImageView;

@end
