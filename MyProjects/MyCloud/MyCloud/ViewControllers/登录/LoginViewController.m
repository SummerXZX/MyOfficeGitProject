//
//  LoginViewController.m
//  MyCloud
//
//  Created by test on 15/7/26.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "LoginViewController.h"
#import <APService.h>
#import "UserInfo.h"
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
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    //获取是否记住密码
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _isRemeberPass = [userDefault boolForKey:@"rememberPass"];
    _phoneField.text = [userDefault objectForKey:@"login_phone"];
    if (_isRemeberPass)
    {
        _passField.text = [userDefault objectForKey:@"login_pass"];
        _remeberPassBtn.selected = YES;
    }
}

#pragma mark 登录动作
- (IBAction)loginAction
{
    [self.view endEditing:YES];
    if (_phoneField.text.length==0)
    {
        [self.view makeToast:@"手机号不能为空！"];
    }
    else if (_passField.text.length==0)
    {
        [self.view makeToast:@"密码不能为空！"];
    }
    else if (_phoneField.text.length!=11)
    {
        [self.view makeToast:@"请输入正确的手机号！"];
    }
    else
    {
        WebClient *webClient = [WebClient shareClient];
        [self.view makeProgress:@"登录中..."];
        [ProjectUtil showLog:@"token:%@",[APService registrationID]];
        [webClient loginWithParameters:@{@"Mobile":_phoneField.text,@"UserPass":_passField.text,@"PlatForm":@"1",@"Token":[APService registrationID]} Success:^(id data) {
            [self.view hiddenProgress];
            if ([data[@"code"]intValue]==0)
            {
                
                
                //储存登录信息
                UserInfo *loginInfo = [[UserInfo alloc]initWithDic:[data[@"result"] firstObject]];
                 NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                UserInfo *storedInfo = [ProjectUtil getCustomObjFromUserDefaultsWithKey:@"login"];
                if ([storedInfo.uid intValue]!=[loginInfo.uid intValue])
                {
                    [userDefault removeObjectForKey:@"announceStatus"];
                    [CallRecordDBManager deleteAllCallRecord];
                }
                [ProjectUtil storeCustomObj:loginInfo ToUserDefaultsWithKey:@"login"];
                [userDefault setObject:_phoneField.text forKey:@"login_phone"];
                [userDefault setObject:_passField.text forKey:@"login_pass"];
                [userDefault synchronize];
                //跳转到首页
                self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNaVC"];
            }
            else
            {
                [self.view makeToast:data[@"message"]];
            }
        } Fail:^(NSError *error) {
            [self.view hiddenProgress];
            [self.view makeToast:HintWithNetError];
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
