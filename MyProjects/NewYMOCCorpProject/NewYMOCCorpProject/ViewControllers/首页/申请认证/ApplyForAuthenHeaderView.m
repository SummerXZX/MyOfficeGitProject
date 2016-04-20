//
//  ApplyForAuthenHeaderView.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/6.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "ApplyForAuthenHeaderView.h"

@implementation ApplyForAuthenHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 34.5, SCREEN_WIDTH-10, 0.5)];
        lineView.backgroundColor = DefaultBackGroundColor;
        [self.contentView addSubview:lineView];
    }
    self.contentView.backgroundColor = [UIColor whiteColor];
    return self;
}

#pragma mark titleLabel
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
    }
    return _titleLabel;
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
