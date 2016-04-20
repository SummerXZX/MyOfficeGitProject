//
//  PostJobWorkTimeItemCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/22.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostJobWorkTimeItemCell.h"

@implementation PostJobWorkTimeItemCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithType:(PostJobWorkTimeItemCellType)type {
    switch (type) {
        case PostJobWorkTimeItemCellTypeDelete:
            return [[[NSBundle mainBundle]loadNibNamed:@"PostJobWorkTimeItemCell" owner:nil options:nil]lastObject];
            break;
        case PostJobWorkTimeItemCellTypeDetail:
            return [[[NSBundle mainBundle]loadNibNamed:@"PostJobWorkTimeDetailItemCell" owner:nil options:nil]lastObject];
            break;
        default:
            break;
    }
}

#pragma mark 获取重用标识符
+(NSString *)getReuserIdentifierWithType:(PostJobWorkTimeItemCellType)type {
    switch (type) {
        case PostJobWorkTimeItemCellTypeDelete:
            return @"PostJobWorkTimeItemCell";
            break;
        case PostJobWorkTimeItemCellTypeDetail:
            return @"PostJobWorkTimeDetailItemCell";
            break;
        default:
            break;
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
