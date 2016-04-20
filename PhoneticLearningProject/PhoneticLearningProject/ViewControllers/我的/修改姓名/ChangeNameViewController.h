//
//  ChangeNameViewController.h
//  PhoneticLearningProject
//
//  Created by test on 15/11/16.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "ModelTableViewController.h"

@interface ChangeNameViewController : ModelTableViewController

/**
 *  获取修改的姓名
 */
-(void)getSelectedName:(ReturnObjectBlock)selectedName;

@end
