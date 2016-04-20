//
//  MyCalendarCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/21.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MyCalendarCellTypeNone, ///<没有任何类型
    MyCalendarCellTypeUnTouch,///<不可点击
    MyCalendarCellTypeSemiCircle,///<半圆
    MyCalendarCellTypeLeftSide,///<左半边
    MyCalendarCellTypeRightSide,///<右半边
    MyCalendarCellTypeRectangle,///<矩形
} MyCalendarCellType;

@interface MyCalendarCell : UICollectionViewCell


@property (nonatomic,assign) MyCalendarCellType type;///<cell类型

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;///<显示的label
@end
