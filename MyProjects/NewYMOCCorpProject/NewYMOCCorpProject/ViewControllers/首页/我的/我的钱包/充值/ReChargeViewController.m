//
//  ChargeViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/13.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ReChargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface ReChargeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//余额
@property (weak, nonatomic) IBOutlet UITextField *chargeField;//充值金额输入框
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

@end

@implementation ReChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}


-(void)layoutSubViews
{
    //查询余额
    [self checkBalance];
    //支付成功后的更新数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chargeSuccessNotification) name:ChargeSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textfieldDidChanged)
     name:UITextFieldTextDidChangeNotification
     object:nil];
    
}

-(void)dealloc
{
    [ProjectUtil showLog:NSStringFromClass([self class])];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:ChargeSuccessNotification object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark 监听TextField变化
- (void)textfieldDidChanged
{
    if (_chargeField.text.length!=0) {
        _rechargeBtn.backgroundColor = DefaultOrangeColor;
        _rechargeBtn.userInteractionEnabled = YES;
    }
    else {
        _rechargeBtn.backgroundColor = DefaultUnTouchButtonColor;
        _rechargeBtn.userInteractionEnabled = NO;
    }
}

#pragma mark 充值成功通知更新数据
-(void)chargeSuccessNotification
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 查询余额
-(void)checkBalance
{
    
    [YMWebClient checkBalanceWithSuccess:^(YMNomalResponse *response) {
        if(response.code==ERROR_OK){
            _moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[response.data doubleValue]];
        }else{
            _moneyLabel.text = @"";
            [self handleErrorWithErrorResponse:response ShowHint:NO];
        }
        [self.tableView reloadData];
    }];
}


#pragma mark 充值动作
- (IBAction)chargeAction
{
    [self.view endEditing:YES];
    
        [self.view showSuccessHintWith:@"充值中"];
        [YMWebClient getChargeOrderNumWithParams:@{@"amount":_chargeField.text} Success:^(YMNomalResponse *response) {
            [self.view dismissProgress];
            if(response.code==ERROR_OK){
                NSString *orderStr = [response.data stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"NewYMOCCorpProject" callback:^(NSDictionary *resultDic) {
                    [ProjectUtil showLog:@"支付--reslut = %@",resultDic];
                }];
            }else{
                [self handleErrorWithErrorResponse:response ShowHint:YES];

            }
        }];
}



#pragma mark tableViewDelegate,datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    view.tintColor = [UIColor clearColor];
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
