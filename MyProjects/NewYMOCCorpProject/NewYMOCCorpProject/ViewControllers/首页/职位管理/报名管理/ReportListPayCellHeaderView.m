//
//  ReportListPayCellHeaderView.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/31.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "ReportListPayCellHeaderView.h"

@interface ReportListPayCellHeaderView ()

@property (nonatomic,strong) UIView *lineView;

@end

@implementation ReportListPayCellHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"zwgl_xz"] forState:UIControlStateSelected];//选中时的图片
        [_selectButton setImage:[UIImage imageNamed:@"zwgl_wxz"] forState:UIControlStateNormal];//未选中时的图片
        _selectButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _selectButton;
}

#pragma mark 时间lable的懒加载
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = DefaultGrayTextColor;
        _timeLabel.font = FONT(15);
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return _timeLabel;
}

#pragma mark lineView
-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = DefaultBackGroundColor;
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _lineView;
}


#pragma mark 重写初始化方法
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    //必须调用父类的方法
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.selectButton];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

#pragma mark 布局约束样式必须要在这里写
- (void)layoutSubviews {
    [super layoutSubviews];
    NSDictionary *spaceDictionary = @{@"vspace":@0,@"hspace":@0,@"btnwidth":@40};
    NSDictionary *viewsDictionary = @{@"timeLabe":self.timeLabel,@"selectButton":self.selectButton};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hspace-[selectButton(btnwidth)]-hspace-[timeLabe]-hspace-|" options:0 metrics:spaceDictionary views:viewsDictionary]];//横向的约束：selectButton左右10，宽度40
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vspace-[selectButton]-vspace-|" options:0 metrics:spaceDictionary views:viewsDictionary]];//selectButton距上距下0
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vspace-[timeLabe]-vspace-|" options:0 metrics:spaceDictionary views:viewsDictionary]];//timeLabe距上距下0
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lineView]-0-|" options:0 metrics:nil views:@{@"lineView":self.lineView}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView(0.5)]" options:0 metrics:nil views:@{@"lineView":self.lineView}]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-0.5]];
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

@end
