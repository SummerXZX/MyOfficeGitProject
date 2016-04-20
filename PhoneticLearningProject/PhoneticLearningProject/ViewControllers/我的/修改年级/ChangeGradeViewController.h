//
//  ChangeGradeViewController.h
//  PhoneticLearningProject
//
//  Created by test on 15/11/16.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "ModelViewController.h"


@interface ChangeGradeViewController : ModelViewController

/**
 *  获取修改的年级
 */
- (void)getSelectedGradeInfo:(ReturnObjectBlock)selectedGradeInfo;

@end
