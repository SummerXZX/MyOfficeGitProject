//
//  ReportListCell.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    ReportListCellTypeWaitSign,///<待签约
    ReportListCellTypeWaitSignEdit,///<带筛选的待签约
    ReportListCellTypeWaitPay,///<待支付
    ReportListCellTypeWaitPayEdit,///<带筛选的待支付
    ReportListCellTypeWaitEvaluate,///<待评价
    ReportListCellTypeCheckEvaluate,///<查看评价
    ReportListCellTypeNomal,///<普通
} ReportListCellType;


@interface ReportListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;///<性别图片

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;///<信息label

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;///<查看签到按钮

@property (weak, nonatomic) IBOutlet UIButton *hireBtn;///<录用按钮

@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;///<拒绝按钮

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;///<选中按钮

@property (weak, nonatomic) IBOutlet UIButton *payBtn;///<支付按钮

@property (weak, nonatomic) IBOutlet UIButton *cashPayBtn;///<现金支付按钮

@property (weak, nonatomic) IBOutlet UIButton *unWorkBtn;///<未上岗按钮

@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;///<评价按钮

@property (weak, nonatomic) IBOutlet UIButton *checkEvaluateBtn;///<查看评价按钮

@property (weak, nonatomic) IBOutlet UITextField *payCountField;///<支付金额输入框

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

/**
 *  初始化方法
 *
 *  @param type
 *
 *  @return
 */
-(instancetype)initWithType:(ReportListCellType)type;

/**
 *  获取重用标识符
 */
+(NSString *)getReuserIdentifierWithType:(ReportListCellType)type;

@end
