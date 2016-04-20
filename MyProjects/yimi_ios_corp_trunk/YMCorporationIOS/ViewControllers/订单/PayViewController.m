//
//  ChargeViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/15.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "PayViewController.h"
#import "UIView+Hint.h"


typedef NS_ENUM(NSInteger, PayType)
{
    PayTypeOnline = 1,
    PayTypeUnderline = 0
};


@interface PayViewController ()<UITextFieldDelegate>
{
    PayType _payType;
    UIButton *_selectedBtn;
    NSArray *_dataArr;
    PayErrorBackHandle _errorHandle;
    
}
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *jobAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *stuNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *workTimesLabel;

@property (weak, nonatomic) IBOutlet UITextField *moneyField;

@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;

@property (weak, nonatomic) IBOutlet UITextField *payPassField;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    _payType = PayTypeOnline;
    [self choosePayType:_chargeBtn];
    _jobNameLabel.text = _payInfoDic[@"jobName"];
    _salaryLabel.attributedText = _payInfoDic[@"salary"];
    _jobAddressLabel.text = _payInfoDic[@"address"];
    _stuNameLabel.text = _payInfoDic[@"stuName"];
    _timeLabel.text = _payInfoDic[@"time"];
    _timeDetailLabel.text = _payInfoDic[@"timeDetail"];
    _workTimesLabel.text = _payInfoDic[@"worktime"];
    
    _dataArr = [NSArray array];
}

-(void)viewDidAppear:(BOOL)animated
{
    //查询是否设置支付密码
    [self checkIsSetPayPwd];
}

#pragma mark 支付错误返回
-(void)handlePayErrorBackHandle:(PayErrorBackHandle)handle
{
    _errorHandle = handle;
}

#pragma mark 查询是否设置支付密码
-(void)checkIsSetPayPwd
{
    BOOL isSet = [ProjectUtil isSetPayPwd];
    if (isSet)
    {
        _dataArr = @[@"",@"",@""];
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView showLoadingImageWithStatus:LoadingStatusOnLoading];
        [YMWebServiceClient isSetPayPwdWithSuccess:^(YMNomalResponse *response) {
            [self.tableView hiddenLoadingView];
            if(response.code==ERROR_OK){
                if ([response.data intValue]==1)
                {
                    _dataArr = @[@"",@"",@""];
                    [self.tableView reloadData];
                }
                else
                {
                    if (_errorHandle)
                    {
                        _errorHandle(0);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }else{
                [self handleErrorWithErrorResponse:response];
                __block PayViewController *blockVC = self;
                [self.tableView handleReload:^{
                    [blockVC checkIsSetPayPwd];
                }];
            }
        }];
    }
}

#pragma mark 选择支付类型
- (IBAction)choosePayType:(UIButton *)sender
{
    if (_selectedBtn!=sender)
    {
        _selectedBtn.selected = NO;
        sender.selected = !sender.selected;
        if (sender.tag==100)
        {
            _payType = PayTypeOnline;
        }
        else if (sender.tag==101)
        {
            _payType = PayTypeUnderline;
        }
        _selectedBtn = sender;
        
        [self.tableView reloadData];
    }
}

- (IBAction)payAction {
     [self.view endEditing:YES];
    
    if (_moneyField.text.length==0)
    {
        [self.view makeToast:@"请输入金额"];
    }
    else if (_payPassField.text.length==0&&_payType==PayTypeOnline)
    {
        [self.view makeToast:@"请输入支付密码"];
    }
    else
    {
        [self.view makeProgress:@"支付中..."];
        [YMWebServiceClient payOrderWithParams:@{@"id":[NSNumber numberWithInt:_orderId],@"pay":_moneyField.text,@"payType":[NSNumber numberWithInt:_payType],@"password":[_payPassField.text changeToStringToMd5String]} Success:^(YMNomalResponse *response) {
            [self.view hiddenProgress];
            if(response.code==ERROR_OK){
                if (_formVcType==FormVCTypeOrderList)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                     [[NSNotificationCenter defaultCenter]postNotificationName:JumpOrderListNotification object:[NSNumber numberWithInt:2]];
                }
                else if (_formVcType==FormVCTypeReportDetail)
                {
                    NSArray *vcsArr = self.navigationController.viewControllers;
                    
                    [self.navigationController popToViewController:vcsArr[vcsArr.count-3] animated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:JumpReportListNotification object:nil];
                }
                else if (_formVcType==FormVCTypeOrderStatusList)
                {
                    self.tabBarController.selectedIndex = 2;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                     [[NSNotificationCenter defaultCenter]postNotificationName:JumpOrderListNotification object:[NSNumber numberWithInt:2]];
                }
                [self.view.window makeToast:@"支付成功"];
            }else{
                [self handleErrorWithErrorResponse:response];
            }
        } ];
    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==_payPassField) {
        [self payAction];
    }
    return YES;
}

#pragma mark tableViewdelegate,datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        if (_payType==PayTypeOnline)
        {
            return 3;
        }
        return 2;
    }
    return 1;
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
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
