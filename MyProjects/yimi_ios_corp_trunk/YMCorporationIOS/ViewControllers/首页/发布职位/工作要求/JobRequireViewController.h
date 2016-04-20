//
//  JobRequireViewController.h
//  YMCorporationIOS
//
//  Created by test on 15/6/26.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ModelTableViewController.h"
typedef void(^JobRequireBlock)(NSMutableDictionary *jobRequireInfo);
@interface JobRequireViewController : ModelTableViewController
@property (nonatomic,strong) NSMutableDictionary *jobRequireDic;

-(void)handleRequireInfo:(JobRequireBlock)requireInfoBlock;
@end
