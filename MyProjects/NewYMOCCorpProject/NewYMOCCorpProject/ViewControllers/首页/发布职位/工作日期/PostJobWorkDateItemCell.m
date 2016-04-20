//
//  PostJobWorkDateItemCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/22.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostJobWorkDateItemCell.h"

@implementation PostJobWorkDateItemCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark 初始化方法
-(instancetype)initWithType:(PostJobWorkDateItemCellType)type {
    switch (type) {
        case PostJobWorkDateItemCellTypeDelete:
            return [[[NSBundle mainBundle]loadNibNamed:@"PostJobWorkDateItemCell" owner:nil options:nil]lastObject];
            break;
        case PostJobWorkDateItemCellTypeDetail:
            return [[[NSBundle mainBundle]loadNibNamed:@"PostJobWorkDateDetailItemCell" owner:nil options:nil] lastObject];
            break;
        default:
            break;
    }
}

#pragma mark 获取重用标识符
+(NSString *)getReuserIdentifierWithType:(PostJobWorkDateItemCellType)type {
    switch (type) {
        case PostJobWorkDateItemCellTypeDelete:
            return @"PostJobWorkDateItemCell";
            break;
        case PostJobWorkDateItemCellTypeDetail:
            return @"PostJobWorkDateDetailItemCell";
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
