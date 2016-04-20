//
//  ReportListCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "ReportListCell.h"

@interface ReportListCell ()

@property (weak, nonatomic) IBOutlet UIView *swipeView;

@end

@implementation ReportListCell

- (void)awakeFromNib {
    if (_swipeView) {
        UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [_swipeView addGestureRecognizer:leftSwipeGesture];
        [_swipeView addGestureRecognizer:rightSwipeGesture];
    }
}

#pragma mark 初始化方法
-(instancetype)initWithType:(ReportListCellType)type {
    switch (type) {
        case ReportListCellTypeWaitSign:
            return [[[NSBundle mainBundle]loadNibNamed:@"ReportListCellTypeWaitSign" owner:nil options:nil] lastObject];
            break;
        case ReportListCellTypeWaitSignEdit:
            return [[[NSBundle mainBundle]loadNibNamed:@"ReportListCellTypeWaitSignEdit" owner:nil options:nil] lastObject];
            break;
        case ReportListCellTypeWaitPay:
            return [[[NSBundle mainBundle]loadNibNamed:@"ReportListCellTypeWaitPay" owner:nil options:nil] lastObject];
            break;
        case ReportListCellTypeWaitPayEdit:
            return [[[NSBundle mainBundle]loadNibNamed:@"ReportListCellTypeWaitPayEdit" owner:nil options:nil] lastObject];
            break;
        case ReportListCellTypeWaitEvaluate:
            return [[[NSBundle mainBundle]loadNibNamed:@"ReportListCellTypeWaitEvaluate" owner:nil options:nil] lastObject];
            break;
        case ReportListCellTypeNomal:
            return [[[NSBundle mainBundle]loadNibNamed:@"ReportListCellTypeNomal" owner:nil options:nil] lastObject];
            break;
        case ReportListCellTypeCheckEvaluate:
            return [[[NSBundle mainBundle]loadNibNamed:@"ReportListCellTypeCheckEvaluate" owner:nil options:nil]lastObject];
            break;
        default:
            break;
    }

}

#pragma mark  获取重用标识符
+(NSString *)getReuserIdentifierWithType:(ReportListCellType)type {
    switch (type) {
        case ReportListCellTypeWaitSign:
            return @"ReportListCellTypeWaitSign";
            break;
        case ReportListCellTypeWaitSignEdit:
            return @"ReportListCellTypeWaitSignEdit";
            break;
        case ReportListCellTypeWaitPay:
            return @"ReportListCellTypeWaitPay";
            break;
        case ReportListCellTypeWaitPayEdit:
            return @"ReportListCellTypeWaitPayEdit";
            break;
        case ReportListCellTypeWaitEvaluate:
            return @"ReportListCellTypeWaitEvaluate";
            break;
        case ReportListCellTypeNomal:
            return @"ReportListCellTypeNomal";
            break;
        case ReportListCellTypeCheckEvaluate:
            return @"ReportListCellTypeCheckEvaluate";
            break;
        default:
            break;
    }
}

#pragma mark 轻扫手势动作
- (void)swipeAction:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self changeSwipeViewLeft:0];
    }
    else {
        [self changeSwipeViewLeft:-(_swipeView.width-SCREEN_WIDTH)];
    }
    
}


-(void)changeSwipeViewLeft:(CGFloat)left {
    [UIView animateWithDuration:0.3 animations:^{
        _swipeView.left = left;
    }];
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
