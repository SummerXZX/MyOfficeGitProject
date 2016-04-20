//
//  JobHistoryView.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/25.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JobHistoryChooseJobBlock)(NSInteger jobId);

@interface JobHistoryView : UIView

@property (nonatomic,strong) NSArray *itemArr;

/**
 *  显示
 */
-(void)show;

/**
 *  选择某个职位
 */
-(void)chooseJob:(JobHistoryChooseJobBlock)chooseJobBlock;

@end
