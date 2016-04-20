//
//  ChargeViewController.h
//  YMCorporationIOS
//
//  Created by test on 15/7/15.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ModelTableViewController.h"
typedef void(^PayErrorBackHandle)(int errorCode);
typedef NS_ENUM(NSInteger, FormVCType)
{
    FormVCTypeOrderList,
    FormVCTypeReportDetail,
    FormVCTypeOrderStatusList
};

@interface PayViewController : ModelTableViewController

@property (nonatomic) int orderId;

@property (nonatomic) FormVCType formVcType;

@property (nonatomic,strong) NSDictionary *payInfoDic;

/**支付错误返回*/
-(void)handlePayErrorBackHandle:(PayErrorBackHandle)handle;

@end
