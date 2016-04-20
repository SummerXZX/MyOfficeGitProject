//
//  CorpTextFieldInputCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *CorpTextFieldInputCellTypeNomalIdentifier = @"CorpTextFieldInputCellTypeNomal";
static NSString *CorpTextFieldInputCellTypeUnitIdentifier = @"CorpTextFieldInputCellTypeUnit";
static NSString *CorpTextFieldInputCellTypeChooseUnitIdentifier = @"CorpTextFieldInputCellTypeChooseUnit";

typedef enum : NSUInteger {
    CorpTextFieldInputCellTypeNomal,///<普通
    CorpTextFieldInputCellTypeUnit,///<有单位
    CorpTextFieldInputCellTypeChooseUnit,///<有可选择单位
} CorpTextFieldInputCellType;

@interface CorpTextFieldInputCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;///<标题label

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;///<输入框

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;///<单位label
@property (weak, nonatomic) IBOutlet UIButton *unitBtn;

/**
 *  初始化方法
 */
-(instancetype)initWithType:(CorpTextFieldInputCellType)type;

@end
