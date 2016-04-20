//
//  PostJobWorkDateFootCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/22.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostJobWorkDateFootCell.h"

@implementation PostJobWorkDateFootCell

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
