//
//  ReportBottomSelectedView.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/27.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "ReportBottomSelectedView.h"

@implementation ReportBottomSelectedView


#pragma mark selectedAllBtn
-(UIButton *)selectedAllBtn {
    if (!_selectedAllBtn) {
        _selectedAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedAllBtn.frame = CGRectMake(0, 0, self.width*0.4, self.height);
        _selectedAllBtn.backgroundColor = [UIColor whiteColor];
        [_selectedAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectedAllBtn setTitle:@"全选" forState:UIControlStateSelected];
        [_selectedAllBtn setTitleColor:DefaultGrayTextColor forState:UIControlStateNormal];
        [_selectedAllBtn setTitleColor:DefaultGrayTextColor forState:UIControlStateNormal];
        [_selectedAllBtn setImage:[UIImage imageNamed:@"zwgl_wx"] forState:UIControlStateNormal];
        [_selectedAllBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_selectedAllBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [_selectedAllBtn setImage:[UIImage imageNamed:@"zwgl_yxz"] forState:UIControlStateSelected];
    }
    return _selectedAllBtn;
}

#pragma mark selectedAllBtn
-(UIButton *)doBtn {
    if (!_doBtn) {
        _doBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doBtn.frame = CGRectMake(_selectedAllBtn.right, 0, self.width-_selectedAllBtn.width, self.height);
        _doBtn.backgroundColor = RGBCOLOR(225, 120, 28);
        [_doBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _doBtn;
}



-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.selectedAllBtn];
        [self addSubview:self.doBtn];
    }
    return self;
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
