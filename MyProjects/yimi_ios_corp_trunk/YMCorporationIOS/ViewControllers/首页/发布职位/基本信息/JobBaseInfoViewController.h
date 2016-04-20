//
//  JobBaseInfoViewController.h
//  YMCorporationIOS
//
//  Created by test on 15/6/26.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ModelTableViewController.h"

typedef void(^JobBaseInfoBlock)(NSMutableDictionary *baseInfo);

@interface JobBaseInfoViewController : ModelTableViewController

@property (nonatomic,strong) NSMutableDictionary *baseInfoDic;

-(void)handleBaseInfo:(JobBaseInfoBlock)baseInfoBlock;
@end
