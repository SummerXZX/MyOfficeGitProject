//
//  EvaluateInputView.m
//  NewYMOCCorpProject
//
//  Created by test on 16/2/1.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "EvaluateInputView.h"

@implementation EvaluateInputView

#pragma mark 
-(UITextField *)addField {
    if (!_addField) {
        _addField = [[UITextField alloc]initWithFrame:CGRectMake(10, (self.height-30.0)/2.0, self.width-70.0, 30.0)];
        _addField.borderStyle = UITextBorderStyleRoundedRect;
        _addField.placeholder = @"请输入评论内容（10字以内）";
        _addField.font = FONT(14);
        _addField.returnKeyType = UIReturnKeySend;
    }
    return _addField;
}

#pragma mark 
-(UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(self.width-60.0, 0, 60.0, self.height);
        [_addBtn setTitle:@"发送" forState:UIControlStateNormal];
        _addBtn.titleLabel.font = FONT(15);
        [_addBtn setTitleColor:DefaultBlueTextColor forState:UIControlStateNormal];
    }
    return _addBtn;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.addField];
        [self addSubview:self.addBtn];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
        lineView.backgroundColor = DefaultLightGrayTextColor;
        [self addSubview:lineView];
    }
    self.backgroundColor = RGBCOLOR(247, 249, 250);
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
