//
//  MyCalendarCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/21.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "MyCalendarCell.h"

static NSInteger InsertViewTag = 100;

@implementation MyCalendarCell

- (void)awakeFromNib {
    // Initialization code
    self.type = MyCalendarCellTypeNone;
}

-(void)setType:(MyCalendarCellType)type {
    _type = type;
    UIView *insertView = [self.contentView viewWithTag:InsertViewTag];
    if (!insertView) {
        //添加背景view
        insertView = [[UIView alloc]init];
        insertView.tag = InsertViewTag;
        insertView.backgroundColor = DefaultBlueTextColor;
        [self.contentView insertSubview:insertView atIndex:0];
    }
    [self changeInsertView:insertView WithType:type];
}

#pragma mark 根据类别改变InsertView
-(void)changeInsertView:(UIView *)insertView WithType:(MyCalendarCellType)type {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        switch (type) {
            case MyCalendarCellTypeSemiCircle:
            {
                insertView.frame = CGRectMake((self.width-self.height)/2.0, 0, self.height, self.height);
                insertView.layer.cornerRadius = self.height/2.0;
                self.itemLabel.textColor = [UIColor whiteColor];
            }
                break;
            case MyCalendarCellTypeLeftSide:
            {
                insertView.frame = CGRectMake(0, 0, self.width+self.height/2.0, self.height);
                insertView.layer.cornerRadius = self.height/2.0;
                self.itemLabel.textColor = [UIColor whiteColor];

            }
                break;
            case MyCalendarCellTypeRectangle:
            {
                insertView.frame = CGRectMake(0, 0, self.width, self.height);
                insertView.layer.cornerRadius = 0.0;
                self.itemLabel.textColor = [UIColor whiteColor];
            }
                break;
            case MyCalendarCellTypeRightSide:
            {
                insertView.frame = CGRectMake(-self.height/2.0, 0, self.width+self.height/2.0, self.height);
                insertView.layer.cornerRadius = self.height/2.0;
                self.itemLabel.textColor = [UIColor whiteColor];
            }
                break;
            case MyCalendarCellTypeNone:
            {
                self.itemLabel.textColor = [UIColor blackColor];
                [insertView removeFromSuperview];
            }
                break;
            case MyCalendarCellTypeUnTouch:
            {
                self.itemLabel.textColor = DefaultLightGrayTextColor;
                [insertView removeFromSuperview];
            }
                break;
            default:
                break;
        }

    }];
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

@end
