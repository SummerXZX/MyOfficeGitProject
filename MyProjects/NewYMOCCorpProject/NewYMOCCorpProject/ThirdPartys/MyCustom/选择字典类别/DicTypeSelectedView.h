//
//  DicTypeSelectedView.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/13.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DicTypeSelectedView : UIView


@property (nonatomic, strong) NSArray* itemArr;///<字典数据数组

@property (nonatomic, assign) NSInteger selectedDicId;///<选中的字典id

/**
 *  显示
 */
-(void)show;



/**
 *  获取选择结果
 */
- (void)getSelectedResult:(GetDicSelectedResultBlock)result;


@end
