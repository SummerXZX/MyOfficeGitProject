//
//  MyConfirmInfoView.h
//  YimiJob
//
//  Created by test on 15/4/20.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ConfirmCancel) ();
typedef void (^ConfirmAffirm) ();

@interface MyConfirmInfoView : UIView
{
    ConfirmAffirm _affirm;
    ConfirmCancel _cancel;
}


@property (nonatomic,retain) NSArray *contentArr;//中间显示内容数组
@property (nonatomic,retain) NSString *title;//显示标题

/**
 * 初始化方法
 */
-(instancetype)initWithBound:(CGFloat)bound Title:(NSString *)title;

/**
 * 显示confirmView
 */
-(void)showFromView:(UIView *)view WithContentArr:(NSArray *)contentArr;

/**
 * 处理取消确认结果
 */
-(void)handleWithCancel:(ConfirmCancel)cancel Affirm:(ConfirmAffirm)affirm;
@end
