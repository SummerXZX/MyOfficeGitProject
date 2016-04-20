//
//  PayPassViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/8/14.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "PayPassViewController.h"

@interface PayPassViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *getIdentityCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *identityCodeField;
@property (weak, nonatomic) IBOutlet UITextField *passField;

@property (weak,nonatomic) IBOutlet UIButton *postBtn;
@end

@implementation PayPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isSet)
    {
        self.title = @"忘记支付密码";
        [_postBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    }
    else
    {
        self.title = @"设置支付密码";
        [_postBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    YMCorpSummary *corpInfo = [ProjectUtil getCorpInfo];
    _phoneLabel.text = corpInfo.phone;
}

#pragma mark 是否显示密码
- (IBAction)showPassAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        _passField.secureTextEntry = NO;
    }
    else
    {
        _passField.secureTextEntry = YES;
    }
}

#pragma mark 获取验证码按钮动作
- (IBAction)getIdentityCodeAction
{
    [self.view endEditing:YES];
    [self.view makeProgress:@"发送中..."];
    [YMWebServiceClient getPayPwdCaptchaWithSuccess:^(YMNomalResponse *response) {
        [self.view hiddenProgress];
        if(response.code==ERROR_OK){
            [self.view makeToast:@"验证码已发送，请主意查收"];
            
            _getIdentityCodeBtn.userInteractionEnabled = NO;
            NSString *timerStr = [NSString stringWithFormat:@"%ds",SendIdentityCodeTime];
            _getIdentityCodeBtn.titleLabel.text = timerStr;
            [_getIdentityCodeBtn setTitle:timerStr forState:UIControlStateNormal];
            [_getIdentityCodeBtn setTitleColor:DefaultGrayTextColor forState:UIControlStateNormal];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendIdentityCodeTimerAction:) userInfo:nil repeats:YES];
        }else{
            [self handleErrorWithErrorResponse:response];
        }
    }];
    
}

#pragma mark 发送验证码计时器方法
-(void)sendIdentityCodeTimerAction:(NSTimer *)timer
{
    int timeCount = [_getIdentityCodeBtn.titleLabel.text intValue];
    NSString *titleStr = @"";
    if (timeCount<=1)
    {
        titleStr = @"获取验证码";
        _getIdentityCodeBtn.titleLabel.text =titleStr;
        [_getIdentityCodeBtn setTitle:titleStr forState:UIControlStateNormal];
        [_getIdentityCodeBtn setTitleColor:NavigationBarColor forState:UIControlStateNormal];
        _getIdentityCodeBtn.userInteractionEnabled = YES;
        [timer invalidate];
        timer = nil;
    }
    else
    {
        titleStr = [NSString stringWithFormat:@"%ds",timeCount-1];
        _getIdentityCodeBtn.titleLabel.text =titleStr;
        [_getIdentityCodeBtn setTitle:titleStr forState:UIControlStateNormal];
    }
}

#pragma mark 完成动作
- (IBAction)finishAction
{
    [self.view endEditing:YES];
    if (_identityCodeField.text.length==0)
    {
        [self.view makeToast:@"请输入您收到的验证码"];
    }
    else if (_passField.text.length==0)
    {
        [self.view makeToast:@"请输入密码"];
    }
    else if (_passField.text.length<6)
    {
        [self.view makeToast:@"密码最少6位"];
    }
    else
    {
        [self updatePayPwdRequst];
    }
    
}

#pragma mark 设置支付密码
-(void)updatePayPwdRequst
{
    if (_isSet)
    {
        [self.view makeProgress:@"重置中..."];
    }
    else
    {
        [self.view makeProgress:@"提交中..."];
    }
    [YMWebServiceClient updatePayPwdWithParams:@{@"captcha":_identityCodeField.text,@"payPassword":[_passField.text changeToStringToMd5String]} Success:^(YMNomalResponse *response) {
        [self.view hiddenProgress];
        if(response.code==ERROR_OK){
            YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
            loginInfo.ispwd = 1;
            [ProjectUtil saveLoginInfo:loginInfo];
            [self.navigationController popViewControllerAnimated:YES];
            if (_isSet)
            {
                [self.view.window makeToast:@"重重支付密码成功"];
            }
            else
            {
                [self.view.window makeToast:@"设置支付密码成功"];
            }
        }else{
            [self handleErrorWithErrorResponse:response];

        }
    }];
    
}


#pragma mark uitableviewdalegete，datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
