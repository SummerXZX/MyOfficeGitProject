//
//  FillWorkTimeCell.h
//  YMCorporationIOS
//
//  Created by test on 15/7/8.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillWorkTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseWorkTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseWorkTimeUnitBtn;
@property (weak, nonatomic) IBOutlet UITextField *workTimeField;
@property (weak, nonatomic) IBOutlet UIButton *addCellBtn;

@end
