//
//  WithdrawViewController.h
//  YMCorporationIOS
//
//  Created by test on 15/7/13.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ModelTableViewController.h"

typedef void(^WithdrawErrorHandle)(int errorCode);

@interface WithdrawViewController : ModelTableViewController

/**处理获取提现账户信息*/
-(void)handleWithdrawBackError:(WithdrawErrorHandle)handle;

@end
