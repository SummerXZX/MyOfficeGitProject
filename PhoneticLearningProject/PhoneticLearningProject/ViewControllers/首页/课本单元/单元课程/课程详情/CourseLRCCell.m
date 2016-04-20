//
//  CourseLRCCell.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/17.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "CourseLRCCell.h"

@interface CourseLRCCell ()

@property (nonatomic,strong) UILabel *readLabel;

@property (nonatomic,strong) UILabel *unReadLabel;

@end


@implementation CourseLRCCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.unReadLabel];
        [self.contentView addSubview:self.readLabel];
        
        //添加约束
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[unReadLabel]-0-|" options:0 metrics:nil views:@{@"unReadLabel":self.unReadLabel}]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.unReadLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[unReadLabel(>=0)]" options:0 metrics:nil views:@{@"unReadLabel":self.unReadLabel}]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[readLabel]-0-|" options:0 metrics:nil views:@{@"readLabel":self.readLabel}]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.readLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.unReadLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        self.readLrcWidthConstraint = [NSLayoutConstraint constraintWithItem:self.readLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        [self.contentView addConstraint:self.readLrcWidthConstraint];
        
    }
    return self;
}

#pragma mark readLabel
-(UILabel *)readLabel {
    if (!_readLabel) {
        _readLabel = [[UILabel alloc]init];
        _readLabel.textColor = NavigationBarColor;
        _readLabel.font = FONT(13);
        _readLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _readLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _readLabel.backgroundColor = [UIColor whiteColor];
    }
    return _readLabel;
}

#pragma mark unReadLabel
-(UILabel *)unReadLabel {
    if (!_unReadLabel) {
        _unReadLabel = [[UILabel alloc]init];
        _unReadLabel.textColor = [UIColor blackColor];
        _unReadLabel.font = FONT(13);
        _unReadLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _unReadLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _unReadLabel.clipsToBounds = YES;
    }
    return _unReadLabel;
}

#pragma mark lrc
-(void)setLrc:(NSString *)lrc {
    _lrc = lrc;
    _unReadLabel.text = lrc;
    _readLabel.text = lrc;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
