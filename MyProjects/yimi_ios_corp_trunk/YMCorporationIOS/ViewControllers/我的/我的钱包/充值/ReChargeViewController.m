//
//  ChargeViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/13.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ReChargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIView+Hint.h"

@interface ReChargeViewController ()<UITextFieldDelegate>
{
    NSArray *_dataArr;
}
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *chargeField;

@end

@implementation ReChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    _dataArr = [NSArray array];
    //支付成功后的更新数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chargeSuccessNotification) name:ChargeSuccessNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ChargeSuccessNotification object:nil];
}

#pragma mark 通知更新数据
-(void)chargeSuccessNotification
{
    [self checkBalance];
}

-(void)viewWillAppear:(BOOL)animated
{
    //查询余额
    [self checkBalance];
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
        [self.view hiddenLoadingView];
     
            if (_dataArr.count==0)
            {
                _dataArr = @[@""];
                [self.tableView reloadData];
            }
            _moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[response.data doubleValue]];
        }else{
            _dataArr = [NSArray array];
            [self.tableView reloadData];
            __block ReChargeViewController *blockVC = self;
            [self handleErrorWithErrorResponse:response];
            [self.tableView handleReload:^{
                [blockVC checkBalance];
            }];
        }
       
    }];
}


#pragma mark 充值动作
- (IBAction)chargeAction
{
    [self.view endEditing:YES];
    if (_chargeField.text.length==0)
    {
        [self.view makeToast:@"请输入充值金额"];
    }
    else
    {

        [self.view makeProgress:@"充值中..."];
        [YMWebServiceClient getChargeOrderNumWithParams:@{@"amount":_chargeField.text} Success:^(YMNomalResponse *response) {
            [self.view hiddenProgress];
            if(response.code==ERROR_OK){
                NSString *orderStr = [response.data stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"YMCorporationIOSPay" callback:^(NSDictionary *resultDic) {
                }];
            }else{
                [self handleErrorWithErrorResponse:response];

            }
        }];
    }
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
    [_chargeField setInputAccessoryView:topView];
    
}

-(void)dismissKeyBoard
{
    [self.view endEditing:YES];
}

#pragma mark tableViewDelegate,datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
