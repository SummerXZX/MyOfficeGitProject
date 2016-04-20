//
//  MyWalletCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/5.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "MyWalletCell.h"

@implementation MyWalletCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

@end
