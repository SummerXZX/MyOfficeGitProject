//
//  MyCalenderView.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/20.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyCalendarViewConfirmActionBlock)();

@interface MyCalendarView : UIView

@property (nonatomic,strong) NSMutableArray *jobDates;///<选中的时间数组

@property (nonatomic,assign) NSInteger defaultCount;///<默认每个日期招聘人数

/**
 *  显示
 */
-(void)show;

/**
 *  确认动作
 */
-(void)calenderConfirmAction:(MyCalendarViewConfirmActionBlock)confirmAction;

@end
