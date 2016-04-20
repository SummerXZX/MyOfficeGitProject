//
//  WithdrawViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/13.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "WithdrawViewController.h"
#import "UIView+Hint.h"

@interface WithdrawViewController ()<UITextFieldDelegate>
{
    WithdrawErrorHandle _errorHandle;
    NSArray *_dataArr;
}
@property (weak, nonatomic) IBOutlet UITextField *withdrawField;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *payPassField;

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    _dataArr = [NSArray array];
}

-(void)viewDidAppear:(BOOL)animated
{
    //查询是否设置支付密码
    [self checkIsSetPayPwd];
}

#pragma mark 查询是否设置支付密码
-(void)checkIsSetPayPwd
{
     BOOL isSet = [ProjectUtil isSetPayPwd];
    if (isSet)
    {
        //获取提现账户信息
        [self requestWithdrawAccountInfo];
    }
    else
    {
        if (_errorHandle)
        {
            _errorHandle (0);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)handleWithdrawBackError:(WithdrawErrorHandle)handle
{
    _errorHandle = handle;
}

#pragma mark 提现方法
- (IBAction)withdrawAction
{
    [self.view endEditing:YES];
    if (_withdrawField.text.length==0)
    {
        [self.view makeToast:@"请输入提现金额"];
    }
    else if (_payPassField.text.length==0)
    {
        [self.view makeToast:@"请输入支付密码"];
    }
    else
    {
        [self.view makeProgress:@"申请中..."];
        [YMWebServiceClient withdrawWithParams:@{@"userName":_nameLabel.text,@"bankNumber":_accountLabel.text,@"amount":_withdrawField.text,@"password":[_payPassField.text changeToStringToMd5String]} Success:^(YMNomalResponse *response) {
            [self.view hiddenProgress];
            if(response.code==ERROR_OK){
                [self.navigationController popViewControllerAnimated:YES];
                [self.view.window makeToast:@"提现申请已受理"];
            }else{
                [self handleErrorWithErrorResponse:response];
            }
        }];
    }
}

#pragma mark 获取提现账户信息
-(void)requestWithdrawAccountInfo
{
    //获取提现账户信息
    [self.tableView showLoadingImageWithStatus:LoadingStatusOnLoading];
    [YMWebServiceClient getWithdrawAcountInfoSuccess:^(YMBankResponse *response) {
        [self.tableView hiddenLoadingView];
        if(response.code==ERROR_OK)
            {
                if (response.data.name.length==0|response.data.banknumber.length==0)
            {
                if (_errorHandle)
                {
                    _errorHandle(1);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
                else
            {
                _accountLabel.text = response.data.banknumber;
                _nameLabel.text = response.data.name;
                _dataArr = @[@"",@""];
                [self.tableView reloadData];
            }
        }else{
                [self handleErrorWithErrorResponse:response];
                __block WithdrawViewController *blockVC = self;
                [self.tableView handleReload:^{
                    [blockVC requestWithdrawAccountInfo];
                }];
            }
    }];
}


#pragma mark 添加回收键盘View
-(void)addReCycleKeyBoardView
{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    [doneButton setTitleTextAttributes:@{NSForegroundColorAttributeName:DefaultGrayTextColor} forState:UIControlStateNormal];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [_withdrawField setInputAccessoryView:topView];
    
}

-(void)dismissKeyBoard
{
    [self.view endEditing:YES];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self withdrawAction];
    return YES;
}



#pragma mark tableViewDelegate,datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 4;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
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
