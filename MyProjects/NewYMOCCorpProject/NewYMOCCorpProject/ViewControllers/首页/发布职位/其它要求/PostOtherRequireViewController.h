//
//  PostOtherRequireViewController.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PostOtherReqireSaveAction)();

@interface PostOtherRequireViewController : UIViewController

@property (nonatomic,assign) NSInteger sex;///<性别

@property (nonatomic,assign) NSInteger grade;///<学历

@property (nonatomic,assign) NSInteger minAge;///<最小年龄

@property (nonatomic,assign) NSInteger maxAge;///<最大年龄

@property (nonatomic,assign) NSInteger height;///<身高

@property (nonatomic,assign) PostJobStatus jobStatus;///<当前职位状态
/**
 *  保存动作
 */
-(void)postOtherRequireSavaAction:(PostOtherReqireSaveAction)saveAction;

@end
