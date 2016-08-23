//
//  LoginViewController.m
//  MyCloud
//
//  Created by test on 15/7/26.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "LoginViewController.h"
#import "JPUSHService.h"
#import "CallRecordDBManager.h"

#import "HomeViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    BOOL _isRemeberPass;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UIButton *remeberPassBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    //获取是否记住密码
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _isRemeberPass = [userDefault boolForKey:@"rememberPass"];
    LoginUserInfo *info = [ProjectUtil getLoginUserInfo];
    _phoneField.text = info.userPhone;
    if (_isRemeberPass)
    {
        _passField.text = info.originPassword;
        _remeberPassBtn.selected = YES;
    }
}

#pragma mark 登录动作
- (IBAction)loginAction
{
    [self.view endEditing:YES];
    if (_phoneField.text.length==0)
    {
        [self.view showToastWith:@"手机号不能为空！"];
    }
    else if (_passField.text.length==0)
    {
        [self.view showToastWith:@"密码不能为空！"];
    }
    else if (_phoneField.text.length!=11)
    {
        [self.view showToastWith:@"请输入正确的手机号！"];
    }
    else
    {
        [self.view showProgressHintWith:@"登录中..."];
        NSString *push = [JPUSHService registrationID];
        if (!push) {
            push = @"";
        }
        [ProjectUtil showLog:@"token:%@",[JPUSHService registrationID]];
        [WebClient loginWithParams:@{@"login":_phoneField.text,@"pwd":_passField.text,@"push":push} Success:^(WebLoginResponse *response) {
            [self.view dismissProgress];
            if (response.code==ResponseCodeSuceess) {
                //保存用户信息
                LoginUserInfo *userInfo = [ProjectUtil getLoginUserInfo];
                if (userInfo) {
                    if (![userInfo.userCode isEqualToString:response.data.userCode]) {
                        //删除上一个数据
                        [CallRecordDBManager deleteAllCallRecord];
                    }
                }
                response.data.originPassword = _passField.text;
                [ProjectUtil saveLoginUserInfoWith:response.data];
                //跳转到首页
                self.view.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
            }
            else {
                [self.view showToastWith:response.codeInfo];
            }
            
        }];
    }


}

#pragma mark 记住密码动作
- (IBAction)remeberPassAction:(UIButton *)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        [userDefault setBool:YES forKey:@"rememberPass"];
    }
    else
    {
        [userDefault setBool:NO forKey:@"rememberPass"];
    }
    [userDefault synchronize];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_passField)
    {
        [self loginAction];
    }
    return YES;
}

#pragma mark tableviewdelegate,datasource
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
