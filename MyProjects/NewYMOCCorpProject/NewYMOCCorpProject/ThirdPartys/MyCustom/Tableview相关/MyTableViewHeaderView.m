//
//  ChooseCityHeaderView.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/13.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "MyTableViewHeaderView.h"

@interface MyTableViewHeaderView  ()

@property (nonatomic,strong) UIView *lineView;

@end

@implementation MyTableViewHeaderView



-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    self.contentView.backgroundColor = DefaultBackGroundColor;
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLabel]-10-|" options:0 metrics:nil views:@{@"titleLabel":self.titleLabel}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleLabel]-0-|" options:0 metrics:nil views:@{@"titleLabel":self.titleLabel}]];
    if (_lineView) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lineView]-0-|" options:0 metrics:nil views:@{@"lineView":self.lineView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView(0.5)]" options:0 metrics:nil views:@{@"lineView":self.lineView}]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-0.5]];
    }
   
}

-(instancetype)initAddLineViewWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.titleLabel];
    }
    self.contentView.backgroundColor = DefaultBackGroundColor;
    return self;

}

#pragma mark titleLabel
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = DefaultGrayTextColor;
        _titleLabel.font = FONT(15);
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
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
