//
//  PostOtherRequireChooseAgeView.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PostOtherRequreAgeViewConfirmAction)();

@interface PostOtherRequireChooseAgeView : UIView

@property (nonatomic,assign) NSInteger minAge;///<最小年龄

@property (nonatomic,assign) NSInteger maxAge;///<最大年龄

/**
 *  显示
 */
-(void)show;

/**
 *  确认动作
 */
- (void)confirmAction:(PostOtherRequreAgeViewConfirmAction)confirmAction;


@end
