//
//  PostWorkTimeChooseView.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostWorkTimeChooseView : UIView

/**
 *  显示
 */
-(void)show;

/**
 *  获取选择结果
 */
- (void)getSelectedResult:(GetDicSelectedResultBlock)result;

@end
