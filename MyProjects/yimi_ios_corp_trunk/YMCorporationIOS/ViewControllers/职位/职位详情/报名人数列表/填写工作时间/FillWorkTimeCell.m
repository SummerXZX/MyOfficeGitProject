//
//  FillWorkTimeCell.m
//  YMCorporationIOS
//
//  Created by test on 15/7/8.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "FillWorkTimeCell.h"

@implementation FillWorkTimeCell

- (void)awakeFromNib {
    self.chooseWorkTimeBtn.layer.borderColor = DefaultLightGrayTextColor.CGColor;
    self.chooseWorkTimeBtn.layer.borderWidth = 1.0;
    self.chooseWorkTimeUnitBtn.layer.borderWidth = 1.0;
    self.chooseWorkTimeUnitBtn.layer.borderColor = DefaultLightGrayTextColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
