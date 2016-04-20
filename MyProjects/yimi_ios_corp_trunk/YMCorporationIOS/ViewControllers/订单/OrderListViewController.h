//
//  ShangGangViewController.h
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ModelViewController.h"


typedef NS_ENUM(NSInteger, OrderStatus)
{
    OrderStatusCharged = 3,
    OrderStatusUnCharged = 1,
    OrderStatusAll = 0
};

@interface OrderListViewController : ModelViewController

@end
