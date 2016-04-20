//
//  PayViewCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/29.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;///<选中按钮
@property (weak, nonatomic) IBOutlet UITextField *payCountField;///<支付金额输入框

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;///<信息label

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;///<查看签到按钮

@end
