//
//  ReportStuInfoCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportStuInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;///<性别图片

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;///<信息label

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@end
