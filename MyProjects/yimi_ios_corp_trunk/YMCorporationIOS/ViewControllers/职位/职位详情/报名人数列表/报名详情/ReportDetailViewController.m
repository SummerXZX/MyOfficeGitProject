//
//  ReportDetailViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/15.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ReportDetailViewController.h"
#import "OrderInfoCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "LocalDicDataBaseManager.h"
#import "PayViewController.h"
#import "MyConfirmInfoView.h"
#import "PayPassViewController.h"
#import "THOrderListCell.h"
@interface ReportDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSInteger _currentPage;
    int _totalCount;
}
@property (weak, nonatomic) IBOutlet UIImageView *stuAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *stuNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stuPhoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stuSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    [_stuAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,_info.stuPhotoScale]] placeholderImage:[UIImage imageNamed:@"stu_avatar"]];
    if (_info.sex==1)
    {
        _stuSexImageView.image = [UIImage imageNamed:@"sex_man"];
    }
    else if (_info.sex==2)
    {
        _stuSexImageView.image = [UIImage imageNamed:@"sex_woman"];
    }
    _stuNameLabel.text = [NSString stringWithFormat:@"%@",_info.stuName];
    _stuPhoneLabel.text = _info.stuPhone;
    _statusLabel.text = [LocalDicDataBaseManager getNameWithType:LocalDicTypeJobStatus VersionId:_info.status];
    if (_info.status==0|_info.status==3)
    {
        _statusLabel.textColor = DefaultOrangeTextColor;
    }
    else if (_info.status==4)
    {
        _statusLabel.textColor = DefaultGreenTextColor;
    }
    else
    {
        _statusLabel.textColor = DefaultRedTextColor;
    }
    self.tableView.frame = CGRectMake(0, 60.0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0-60.0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark 拨打电话
- (IBAction)callAction:(id)sender {
    
    [self callWithPhoneNum:_info.stuPhone];
}


#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _info.jobRegiOrderList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YMJobRegiOrderSummary *info = _info.jobRegiOrderList[section];
    if (info.status==1)
    {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 90.0;
    }
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        static NSString *identifier = @"OrderInfoCell";
        OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderInfoCell" owner:nil options:nil]lastObject];
        }
        YMJobRegiOrderSummary *info = _info.jobRegiOrderList[indexPath.section];
        NSString *timeStr = [ProjectUtil changeStandardDateStrWithSp:info.workStartTime];
        cell.dateLabel.text = [timeStr substringToIndex:10];
        cell.weekLabel.text = [ProjectUtil getWeekDayStrWithTimeSp:info.workStartTime];
        cell.timeLabel.text = [[timeStr substringFromIndex:11]substringToIndex:5];
        cell.workTimesLabel.text = [NSString stringWithFormat:@"%g%@",info.workTimes,[ProjectUtil getWorkTimeUnitStrWithUnitId:info.workTimesUnit]];
        if (info.status==3)
        {
            cell.payMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",info.pay];
            if (info.payType==0)
            {
                cell.statusLabel.text = @"现金支付";
            }
            else if (info.payType==1)
            {
                cell.statusLabel.text = @"在线支付";
            }
            cell.payMoneyLabelTop.constant = 25.0;
        }
        else
        {
            cell.payMoneyLabel.text = @"";
            cell.payMoneyLabelTop.constant = 15.0;
            cell.statusLabel.text = [ProjectUtil getOrderStatusStrWithStatus:info.status];
        }
        if (info.status==3)
        {
            cell.statusLabel.textColor = DefaultGreenTextColor;
        }
        else if (info.status==4)
        {
            cell.statusLabel.textColor = DefaultGrayTextColor;
        }
        else
        {
            cell.statusLabel.textColor = DefaultOrangeTextColor;
        }

        return cell;
    }
    else
    {
        static NSString *identifier = @"ChargeCell";
        THOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"THOrderListCell" owner:nil options:nil]lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.btn_cancel.tag=indexPath.section;
        cell.btn_downBoard.tag=indexPath.section;
        cell.btn_pay.tag=indexPath.section;
        [cell.btn_pay addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_downBoard addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_cancel addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
}

#pragma mark 创建底部按钮
-(UIButton *)getBottomBtnWithFrame:(CGRect)frame Title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = Default_Font_15;
    btn.backgroundColor = RGBCOLOR(255, 102, 51);
    btn.layer.cornerRadius = 2.0;
    [btn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark 底部按钮方法
-(void)bottomBtnAction:(UIButton *)sender
{
    YMJobRegiOrderSummary *info = _info.jobRegiOrderList[sender.tag];
    if ([sender.titleLabel.text isEqualToString:@"支付"])
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        PayViewController *payVC = [storyBoard instantiateViewControllerWithIdentifier:@"payVC"];
        payVC.title = @"支付";
        payVC.orderId = info.id;
        [payVC handlePayErrorBackHandle:^(int errorCode) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有设置支付密码，将不能进行支付提现等操作！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            [alertView show];
        }];
        payVC.formVcType = FormVCTypeReportDetail;
        NSString *timeStr = [ProjectUtil changeStandardDateStrWithSp:info.workStartTime];
        
        NSString *salaryCountStr = [NSString stringWithFormat:@"%d元",_info.pay];
        
        NSString *salaryStr = [NSString stringWithFormat:@"%@%@",salaryCountStr,[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:_info.payUnit]];
        NSMutableAttributedString *salaryAttStr = [[NSMutableAttributedString alloc]initWithString:salaryStr attributes:@{NSFontAttributeName:Default_Font_12,NSForegroundColorAttributeName:DefaultGrayTextColor}];
        [salaryAttStr addAttribute:NSForegroundColorAttributeName value:DefaultOrangeTextColor range:NSMakeRange(0, salaryCountStr.length)];
        payVC.payInfoDic = @{@"jobName":_info.jobName,@"salary":salaryAttStr,@"address":_info.address,@"stuName":_info.stuName,@"time":[NSString stringWithFormat:@"%@ %@",[timeStr substringToIndex:10],[ProjectUtil getWeekDayStrWithTimeSp:info.workStartTime]],@"timeDetail":[[timeStr substringFromIndex:11]substringToIndex:5],@"worktime":[NSString stringWithFormat:@"%g%@",info.workTimes,[ProjectUtil getWorkTimeUnitStrWithUnitId:info.workTimesUnit]]};
        [self.navigationController pushViewController:payVC animated:YES];

    }
    else if ([sender.titleLabel.text isEqualToString:@"未上岗"])
    {
        MyConfirmInfoView *confirmInfoView = [[MyConfirmInfoView alloc]initWithBound:15.0 Title:@"确认未上岗"];
        
        [confirmInfoView showFromView:self.view WithContentArr:@[[NSString stringWithFormat:@"职位名称：%@",_info.jobName],[NSString stringWithFormat:@"学生姓名：%@",_info.stuName],[NSString stringWithFormat:@"工作时间：%@",[ProjectUtil changeToDefaultDateStrWithSp:info.workStartTime]],[NSString stringWithFormat:@"工作时长：%@",[NSString stringWithFormat:@"%g%@",info.workTimes,[ProjectUtil getWorkTimeUnitStrWithUnitId:info.workTimesUnit]]]]];
        [confirmInfoView handleWithCancel:nil Affirm:^{
            [self.view makeProgress:@"确认中..."];
            [YMWebServiceClient markUnWorkOrderWithParams:@{@"id":[NSNumber numberWithInt:info.id]} Success:^(YMNomalResponse *response) {
                [self.view hiddenProgress];
                if(response.code==ERROR_OK){
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:JumpReportListNotification object:nil];
                    [self.view makeToast:@"确认未上岗成功"];
                }else{
                    [self handleErrorWithErrorResponse:response];
                }
            }];

        }];
    }
    else if ([sender.titleLabel.text isEqualToString:@"取消"])
    {
        MyConfirmInfoView *confirmInfoView = [[MyConfirmInfoView alloc]initWithBound:15.0 Title:@"确认取消订单"];
        [confirmInfoView showFromView:self.view WithContentArr:@[[NSString stringWithFormat:@"职位名称：%@",_info.jobName],[NSString stringWithFormat:@"学生姓名：%@",_info.stuName],[NSString stringWithFormat:@"工作时间：%@",[ProjectUtil changeToDefaultDateStrWithSp:info.workStartTime]],[NSString stringWithFormat:@"工作时长：%@",[NSString stringWithFormat:@"%g%@",info.workTimes,[ProjectUtil getWorkTimeUnitStrWithUnitId:info.workTimesUnit]]]]];
        [confirmInfoView handleWithCancel:nil Affirm:^{
            [self.view makeProgress:@"取消中..."];
            [YMWebServiceClient cancelOrderWithParams:@{@"id":[NSNumber numberWithInt:info.id]} Success:^(YMNomalResponse *response) {
                [self.view hiddenProgress];
                if(response.code==ERROR_OK){
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:JumpReportListNotification object:nil];
                    [self.view makeToast:@"您已成功取消该订单"];
                }else{
                    [self handleErrorWithErrorResponse:response];

                }
            }];

        }];
    }

}

#pragma mark alertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PayPassViewController *payPassVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WithdrawPassVC"];
    payPassVC.isSet = NO;
    [self.navigationController pushViewController:payPassVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
