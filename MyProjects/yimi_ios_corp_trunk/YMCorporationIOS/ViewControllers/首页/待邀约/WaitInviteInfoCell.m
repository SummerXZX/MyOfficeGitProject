//
//  WaitInviteInfoCell.m
//  YMCorporationIOS
//
//  Created by test on 15/7/6.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "WaitInviteInfoCell.h"

@interface WaitInviteInfoCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineVIewHeight;

@end

@implementation WaitInviteInfoCell

- (void)awakeFromNib {
    self.lineVIewHeight.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
