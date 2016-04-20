//
//  MyTopInfoCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/15.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "MyTopInfoCell.h"

@implementation MyTopInfoCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
