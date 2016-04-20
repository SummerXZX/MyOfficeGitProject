//
//  RegisterTableViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "RegisterTableViewController.h"
#import "ModelWebViewController.h"
#import "HomeViewController.h"

@interface RegisterTableViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *identityCodeField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UIButton *agreeRuleBtn;
@property (weak, nonatomic) IBOutlet UIButton *getIdentityCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textfieldDidChanged)
     name:UITextFieldTextDidChangeNotification
     object:nil];
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark 监听TextField变化
- (void)textfieldDidChanged
{
    if (_phoneField.text.length==11&&_passField.text.length>=6&&_passField.text.length<=20&&_identityCodeField.text.length==6&&_agreeRuleBtn.selected==YES) {
        _registerBtn.backgroundColor = DefaultOrangeColor;
        _registerBtn.userInteractionEnabled = YES;
    }
    else {
        _registerBtn.backgroundColor = DefaultUnTouchButtonColor;
        _registerBtn.userInteractionEnabled = NO;
    }
}

#pragma mark 获取验证码动作
- (IBAction)getIdentityCodeAction
{
    [self.view endEditing:YES];
    if (_phoneField.text.length==0)
    {
        [self.view showFailHintWith:@"请输入手机号"];
    }
    else if (_phoneField.text.length!=11)
    {
        [self.view showFailHintWith:@"请输入正确的手机号"];
    }
    else
    {
        [self.view showProgressHintWith:@"发送中"];
        [YMWebClient getRegistCaptchaWithParams:@{@"phone":_phoneField.text,@"type":@1} Success:^(YMNomalResponse *response) {
            [self.view dismissProgress];
            if(response.code==ERROR_OK){
                [self.view showSuccessHintWith:@"验证码已发送，请注意查收"];
                _getIdentityCodeBtn.userInteractionEnabled = NO;
                NSString *timerStr = [NSString stringWithFormat:@"%ds",SendIdentityCodeTime];
                _getIdentityCodeBtn.titleLabel.text = timerStr;
                [_getIdentityCodeBtn setTitle:timerStr forState:UIControlStateNormal];
                [_getIdentityCodeBtn setTitleColor:DefaultGrayTextColor forState:UIControlStateNormal];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendIdentityCodeTimerAction:) userInfo:nil repeats:YES];
            }else{
                [self handleErrorWithErrorResponse:response ShowHint:YES];
            }
        }];
    }
}

#pragma mark 发送验证码计时器方法
-(void)sendIdentityCodeTimerAction:(NSTimer *)timer
{
    NSInteger timeCount = [_getIdentityCodeBtn.titleLabel.text intValue];
    NSString *titleStr = @"";
    if (timeCount<=1)
    {
        titleStr = @"获取验证码";
        _getIdentityCodeBtn.titleLabel.text =titleStr;
        [_getIdentityCodeBtn setTitle:titleStr forState:UIControlStateNormal];
        [_getIdentityCodeBtn setTitleColor:DefaultOrangeColor forState:UIControlStateNormal];
        _getIdentityCodeBtn.userInteractionEnabled = YES;
        [timer invalidate];
        timer = nil;
    }
    else
    {
        titleStr = [NSString stringWithFormat:@"%lds",(long)timeCount-1];
        _getIdentityCodeBtn.titleLabel.text =titleStr;
        [_getIdentityCodeBtn setTitle:titleStr forState:UIControlStateNormal];
    }
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

#pragma mark 同意用户协议
- (IBAction)agreeUserRule:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self textfieldDidChanged];
}

#pragma mark 跳转商家协议
- (IBAction)ruleDetailAction
{
    ModelWebViewController *webVC = [[ModelWebViewController alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/protocol/corp_protocol.html",REQUEST_SERVER_URL]]];
    webVC.title = @"一米商家协议";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark 注册动作
- (IBAction)registerAction
{
    [self.view endEditing:YES];
    [self.view showProgressHintWith:@"注册中"];
    [YMWebClient registWithParams:@{@"phone":_phoneField.text,@"loginPassword":[_passField.text changeToStringToMd5String],@"captcha":_identityCodeField.text} Success:^(YMNomalResponse *response) {
        [self.view dismissProgress];
        if(response.code==ERROR_OK){
            
            [ProjectUtil saveLoginPhone:_phoneField.text];
            //自动登录
            [self.view showProgressHintWith:@"自动登录中"];
            [YMWebClient loginWithParams:@{@"loginName":_phoneField.text,@"loginPassword":[_passField.text changeToStringToMd5String]} Success:^(YMLoginResponse *response) {
                [self.view dismissProgress];
                
                if (response.code == ERROR_OK) {
                    //储存用户信息
                    [ProjectUtil saveLoginInfo:response.data];
                    UIViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CorpInfoViewController"];
                    nextVC.title = @"完善商家信息";
                    self.view.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:nextVC];
                }
                else {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"自动登录失败，请手动去登录吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }];

           
        }else{
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
    }];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_phoneField) {
        [_identityCodeField becomeFirstResponder];
    }
    else if (textField==_identityCodeField) {
        [_passField becomeFirstResponder];
    }
    else if (textField==_passField) {
        if (_registerBtn.userInteractionEnabled) {
            [self registerAction];
        }
    }

    return YES;
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==alertView.cancelButtonIndex)
    {
        [ProjectUtil saveLoginPhone:_phoneField.text];
        [self.navigationController popViewControllerAnimated:YES];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
