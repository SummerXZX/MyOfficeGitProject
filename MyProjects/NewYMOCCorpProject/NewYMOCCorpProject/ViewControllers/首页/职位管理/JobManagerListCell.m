//
//  JobManagerListCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/24.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "JobManagerListCell.h"

@interface JobManagerListCell ()

@property (weak, nonatomic) IBOutlet UIView *swipeView;///<侧滑view


@end


@implementation JobManagerListCell

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
-(instancetype)initWithType:(JobManagerListCellType)type {
    switch (type) {
        case JobManagerListCellTypeChecking:
            return [[[NSBundle mainBundle]loadNibNamed:@"JobManagerListCellTypeChecking" owner:nil options:nil]lastObject];
            break;
        case JobManagerListCellTypeRecruiting:
            return [[[NSBundle mainBundle]loadNibNamed:@"JobManagerListCellTypeRecruiting" owner:nil options:nil]lastObject];
            break;
        case JobManagerListCellTypeEnd:
            return [[[NSBundle mainBundle]loadNibNamed:@"JobManagerListCellTypeEnd" owner:nil options:nil]lastObject];
            break;
            
        default:
            break;
    }
    
}



#pragma mark  获取重用标识符
+(NSString *)getReuserIdentifierWithType:(JobManagerListCellType)type {
    switch (type) {
        case JobManagerListCellTypeChecking:
            return @"JobManagerListCellTypeRecruiting";
            break;
        case JobManagerListCellTypeRecruiting:
            return @"JobManagerListCellTypeRecruiting";
            break;
        case JobManagerListCellTypeEnd:
            return @"JobManagerListCellTypeEnd";
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

@end
