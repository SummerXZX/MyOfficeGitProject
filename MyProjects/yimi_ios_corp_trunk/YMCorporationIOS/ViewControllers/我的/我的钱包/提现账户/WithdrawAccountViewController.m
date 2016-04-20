//
//  WithdrawAccountViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/16.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "WithdrawAccountViewController.h"
#import "UIView+Hint.h"

@interface WithdrawAccountViewController ()<UITextFieldDelegate>
{
    NSArray *_dataArr;
}
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@end

@implementation WithdrawAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    _dataArr = [NSArray array];
    //获取提现账户信息
    [self requestWithdrawAccountInfo];
}

#pragma mark 获取提现账户信息
-(void)requestWithdrawAccountInfo
{
    //获取提现账户信息
    if (_dataArr.count==0)
    {
        [self.tableView showLoadingImageWithStatus:LoadingStatusOnLoading];
    }
    [YMWebServiceClient getWithdrawAcountInfoSuccess:^(YMBankResponse *response) {
        if(response.code==ERROR_OK){
        [self.tableView hiddenLoadingView];
            if (_dataArr.count==0)
            {
                _dataArr = @[@""];
                [self.tableView reloadData];
            }
            _accountField.text = response.data.banknumber;
            _nameField.text = response.data.name;
        }else{
            _dataArr = [NSArray array];
            [self.tableView reloadData];
            [self handleErrorWithErrorResponse:response];
            __block WithdrawAccountViewController *blockVC = self;
            [self.tableView  handleReload:^{
                [blockVC requestWithdrawAccountInfo];
            }];
        }
    }];
}

#pragma mark 保存信息
- (IBAction)saveAction
{
    [self.view endEditing:YES];
    if (_accountField.text.length==0)
    {
        [self.view makeToast:@"请输入支付宝账号"];
    }
    else if (_nameField.text.length==0)
    {
        [self.view makeToast:@"请输入支付宝绑定姓名"];
    }
    else if (_accountField.text.length!=11&&![_accountField.text isType:SpecialStringTypeEmail])
    {
        [self.view makeToast:@"请输入正确的支付宝账号"];
    }
    else
    {
        [self.view makeProgress:@"保存中..."];
        [YMWebServiceClient saveWithdrawInfoWithParams:@{@"name":_nameField.text,@"bankNumber":_accountField.text} Success:^(YMNomalResponse *response) {
            [self.view hiddenProgress];
            if(response.code==ERROR_OK){
                [self.navigationController popViewControllerAnimated:YES];
                [self.view.window makeToast:@"保存成功"];
            }else{
                [self handleErrorWithErrorResponse:response];
            }
        }];
    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_accountField)
    {
        [_nameField becomeFirstResponder];
    }
    else if (textField==_nameField)
    {
        [self saveAction];
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tableViewDelegete,datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
