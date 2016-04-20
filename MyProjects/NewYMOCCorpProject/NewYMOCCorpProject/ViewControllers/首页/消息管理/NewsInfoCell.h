//
//  NewsInfoCell.h
//  NewYMOCProject
//
//  Created by test on 16/3/3.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *NewsInfoCellIdentifier = @"NewsInfoCell";

@interface NewsInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;///<消息类型imageview
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;///<标题label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;///<时间label

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;///<内容label
@property (weak, nonatomic) IBOutlet UIImageView *isReadImageView;///<是否已读标记

@end
