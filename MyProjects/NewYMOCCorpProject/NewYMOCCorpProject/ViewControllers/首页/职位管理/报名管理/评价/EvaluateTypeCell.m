//
//  EvaluateTypeCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/27.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "EvaluateTypeCell.h"

@implementation EvaluateTypeCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setEvaluateType:(EvaluateType)evaluateType {
    if (_evaluateType!=0) {
        UIButton *lastBtn = (UIButton *)[self.contentView viewWithTag:_evaluateType];
        if (lastBtn) {
            lastBtn.selected = NO;
        }
    }
    _evaluateType = evaluateType;
    
    UIButton *currentBtn = (UIButton *)[self.contentView viewWithTag:evaluateType];
    if ([currentBtn isKindOfClass:[UIButton class]]) {
        currentBtn.selected = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

@end
