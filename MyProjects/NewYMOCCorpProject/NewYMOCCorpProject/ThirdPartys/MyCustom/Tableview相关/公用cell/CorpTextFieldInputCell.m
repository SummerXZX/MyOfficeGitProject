//
//  CorpTextFieldInputCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "CorpTextFieldInputCell.h"

@implementation CorpTextFieldInputCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark 初始化方法
-(instancetype)initWithType:(CorpTextFieldInputCellType)type {
    
    switch (type) {
        case CorpTextFieldInputCellTypeNomal:
        {
            return [[[NSBundle mainBundle]loadNibNamed:CorpTextFieldInputCellTypeNomalIdentifier owner:nil options:nil]lastObject];
        }
            break;
        case CorpTextFieldInputCellTypeUnit: {
            return [[[NSBundle mainBundle]loadNibNamed:CorpTextFieldInputCellTypeUnitIdentifier owner:nil options:nil]lastObject];
        }
        case CorpTextFieldInputCellTypeChooseUnit: {
            return [[[NSBundle mainBundle]loadNibNamed:CorpTextFieldInputCellTypeChooseUnitIdentifier owner:nil options:nil]lastObject];

        }
            break;
        default:
            return nil;
            break;
    }
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
