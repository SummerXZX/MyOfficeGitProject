//
//  MyWalletViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/13.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "MyWalletViewController.h"
#import "ReChargeViewController.h"
#import "WithdrawViewController.h"
#import "RechargeRecordViewController.h"
#import "WithdrawRecordViewController.h"
#import "WithdrawAccountViewController.h"
#import "RechargeRecordViewController.h"
#import "WithdrawRecordViewController.h"
#import "PayPassViewController.h"
#import "UIView+Hint.h"

@interface MyWalletViewController ()<UIAlertViewDelegate>
{
    NSArray *_dataArr;
    BOOL _isLoad;
}
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *isSetPaypwdLabel;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    //查询余额
    [self checkBalance];
}

-(void)layoutSubViews
{
    _dataArr = [NSArray array];
}

#pragma mark 查询余额
-(void)checkBalance
{
    if (_dataArr.count==0)
    {
        [self.tableView showLoadingImageWithStatus:LoadingStatusOnLoading];
    }
    [YMWebServiceClient checkBalanceWithSuccess:^(YMNomalResponse *response) {
        if(response.code==ERROR_OK){
            [self.tableView hiddenLoadingView];
            if (_dataArr.count==0)
            {
                _dataArr = @[@"",@""];
                [self.tableView reloadData];
            }
            _moneyLabel.text = [NSString stringWithFormat:@"%.2f",[response.data doubleValue]];
            
            if (!_isLoad)
            {
                //查询是否设置支付密码
                [self checkIsSetPayPwd];
                _isLoad = YES;
            }
        }else{
            _dataArr = [NSArray array];
            [self.tableView reloadData];
            [self handleErrorWithErrorResponse:response];
            __block MyWalletViewController *blockVC = self;
            [self.tableView handleReload:^{
                [blockVC checkBalance];
            }];
        }
        
    }];
}

#pragma mark 查询是否设置支付密码
-(void)checkIsSetPayPwd
{
    BOOL isSet = [ProjectUtil isSetPayPwd];
    if (isSet)
    {
        _isSetPaypwdLabel.text = @"忘记密码？";
    }
    else
    {
        [YMWebServiceClient isSetPayPwdWithSuccess:^(YMNomalResponse *response) {
            if(response.code==ERROR_OK){
                if ([response.data intValue]==0)
                {
                    [self showAlertToSetPayPass];
                }
                else if ([response.data intValue]==1)
                {
                     YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
                    loginInfo.ispwd = 1;
                    [ProjectUtil saveLoginInfo:loginInfo];
                     _isSetPaypwdLabel.text = @"忘记密码？";
                }
            }
        }];
    }
}

#pragma mark 去设置支付密码
-(void)showAlertToSetPayPass
{
    _isSetPaypwdLabel.text = @"点击设置";
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有设置支付密码，将不能进行支付提现等操作！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
    alertView.tag = 1000;
    [alertView show];
}

#pragma mark 跳转下级页面
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushApplyWithdrawVC"])
    {
        WithdrawViewController *withdrawVC = segue.destinationViewController;
        [withdrawVC handleWithdrawBackError:^(int errorCode) {
            if (errorCode==0)
            {
                [self showAlertToSetPayPass];
            }
            else if (errorCode==1)
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您还没设置提现账户不可以提现" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                alertView.tag = 1001;
                [alertView show];
            }
        }];
       
    }
    else if ([segue.identifier isEqualToString:@"PushWithdrawPassVC"])
    {
        PayPassViewController *payVC = segue.destinationViewController;
        payVC.isSet = [ProjectUtil isSetPayPwd];
    }
}

#pragma mark tableviewdelegate,datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        return 6;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1)
    {
        if (indexPath.row==1)
        {
            RechargeRecordViewController *rechargeRecordVC = [[RechargeRecordViewController alloc]init];
            rechargeRecordVC.title = @"充值记录";
            [self.navigationController pushViewController:rechargeRecordVC animated:YES];
        }
        if (indexPath.row==4)
        {
            WithdrawRecordViewController *withdrawRecordVC = [[WithdrawRecordViewController alloc]init];
            withdrawRecordVC.title = @"提现记录";
            [self.navigationController pushViewController:withdrawRecordVC animated:YES];
        }
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex)
    {
        if (alertView.tag==1000)
        {
            PayPassViewController *payPassVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WithdrawPassVC"];
            payPassVC.isSet = NO;
            [self.navigationController pushViewController:payPassVC animated:YES];
        }
        else if (alertView.tag==1001)
        {
            WithdrawAccountViewController *withdrawAccountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"withdrawAccountVC"];
            [self.navigationController pushViewController:withdrawAccountVC animated:YES];
        }
    }
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
