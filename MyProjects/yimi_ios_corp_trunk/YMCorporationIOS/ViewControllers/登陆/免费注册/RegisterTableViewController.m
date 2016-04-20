//
//  RegisterTableViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "RegisterTableViewController.h"
#import "ModelWebViewController.h"

@interface RegisterTableViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *identityCodeField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UIButton *agreeRuleBtn;
@property (weak, nonatomic) IBOutlet UIButton *getIdentityCodeBtn;
@end

@implementation RegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark 获取验证码动作
- (IBAction)getIdentityCodeAction
{
    [self.view endEditing:YES];
    if (_phoneField.text.length==0)
    {
        [self.view makeToast:@"请输入手机号"];
    }
    else if (_phoneField.text.length!=11)
    {
        [self.view makeToast:@"请输入正确的手机号"];
    }
    else
    {
        [self.view makeProgress:@"发送中..."];
        [YMWebServiceClient getRegistCaptchaWithParams:@{@"phone":_phoneField.text} Success:^(YMNomalResponse *response) {
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
    if (_phoneField.text.length==0)
    {
        [self.view makeToast:@"请输入手机号"];
    }
    else if(_phoneField.text.length!=11)
    {
        [self.view makeToast:@"请输入正确的手机号"];
    }
    else if (_identityCodeField.text.length==0)
    {
        [self.view makeToast:@"请输入您收到的验证码"];
    }
    else if (_passField.text.length==0)
    {
        [self.view makeToast:@"请输入密码"];
    }
    else if (_phoneField.text.length<6)
    {
        [self.view makeToast:@"密码最少6位"];
    }
    else if (!_agreeRuleBtn.selected)
    {
        [self.view makeToast:@"请同意《一米商家协议》"];
    }
    else
    {
        [self.view endEditing:YES];
        [self registerRequest];
    }
}

#pragma mark 请求通知接口
-(void)registerRequest
{
    [self.view makeProgress:@"注册中..."];
    [YMWebServiceClient registWithParams:@{@"phone":_phoneField.text,@"loginPassword":[_passField.text changeToStringToMd5String],@"captcha":_identityCodeField.text} Success:^(YMNomalResponse *response) {
        [self.view hiddenProgress];
        if(response.code==ERROR_OK){
            [ProjectUtil saveLoginPhone:_phoneField.text];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功，赶紧去登录吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            [self handleErrorWithErrorResponse:response];
        }
    }];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_passField)
    {
        [self registerAction];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *totalStr = [textField.text stringByAppendingString:string];
    if (textField == _phoneField &&totalStr.length>11)
    {
        return NO;
    }
    else if (textField==_passField && totalStr.length>20)
    {
        [self.view makeToast:@"密码最多20位"];
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==alertView.cancelButtonIndex)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:JumpLoginNotification object:_phoneField.text];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
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
