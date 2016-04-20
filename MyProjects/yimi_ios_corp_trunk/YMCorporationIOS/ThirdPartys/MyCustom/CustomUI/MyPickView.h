//
//  MyPickView.h
//  YMCorporationIOS
//
//  Created by test on 15/6/26.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyPickHandleBlock)(NSArray *selectedArr);
typedef void(^MyPickDateHandleBlock)(NSDate *date);
typedef void(^MyPickWorkTimeHandleBlock)(NSString *timeStr);

@interface MyPickView : UIView

/**
 *普通的picker
 */
@property (nonatomic,strong) UIPickerView *pickView;
/**
 *日期选择picker
 */
@property (nonatomic,strong) UIDatePicker *datePicker;
/**
 *是否区域选择的picker
 */
@property (nonatomic,assign) BOOL isAreaPicker;
/**
 *创建普通的pickview
 */
-(instancetype)initWithTitle:(NSString *)title Items:(NSArray *)items;
/**
 *创建时间pickview
 */
-(instancetype)initDatePickerWithTitle:(NSString *)title;
/**
 *创建兼职时间的pickview
 */
-(instancetype)initWorkTimePickerWithTitle:(NSString *)title;

/**
 *兼职时间选中项目
 */
-(void)workTimeSeletedTimeStr:(NSString *)timeStr;

/**
 *根据时间字符串获取信息字符串
 */
+(NSString *)getTimeInfoStrWithTimeStr:(NSString *)timeStr;

/**
 *显示
 */
-(void)show;
/**
 *处理确认动作
 */
-(void)handleConfirm:(MyPickHandleBlock)confirm;
/**
 *日期处理确认动作
 */
-(void)handleDateConfirm:(MyPickDateHandleBlock)dateConfirm;
/**
 *兼职时间处理确认动作
 */
-(void)handleWorkTimeConfirm:(MyPickWorkTimeHandleBlock)workTimeConfirm;

@end
