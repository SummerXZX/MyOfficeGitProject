//
//  MyWalletCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/5.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;///<类型imageview

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;///<标题label

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;///<时间label

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;///<金钱数量label

@end
