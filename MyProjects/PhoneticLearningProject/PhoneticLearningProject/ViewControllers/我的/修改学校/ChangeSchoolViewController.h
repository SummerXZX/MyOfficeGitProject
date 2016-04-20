//
//  ChangeSchoolViewController.h
//  PhoneticLearningProject
//
//  Created by test on 15/11/16.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "ModelTableViewController.h"

@interface ChangeSchoolViewController : ModelTableViewController

/**
 *  获取修改的学校
 */
-(void)getSelectedSchool:(ReturnObjectBlock)selectedSchool;

@end
