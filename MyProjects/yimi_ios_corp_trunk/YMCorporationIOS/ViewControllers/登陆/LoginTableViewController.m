//
//  LoginTableViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "LoginTableViewController.h"


@interface LoginTableViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountField;

@property (weak, nonatomic) IBOutlet UITextField *passField;
@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册其他页面跳转的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpNotiAction:) name:JumpLoginNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    _accountField.text = [ProjectUtil getLoginPhone];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:JumpLoginNotification object:nil];
}

-(void)jumpNotiAction:(NSNotification *)noti
{
    _accountField.text = noti.object;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 是否显示密码

- (IBAction)isShowPassAction:(UIButton *)sender
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

#pragma mark 登陆按钮动作
- (IBAction)loginAction
{
    [self.view endEditing:YES];
    if (_accountField.text.length==0)
    {
        [self.view makeToast:@"请输入用户名或手机号"];
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
        [self loginRequest];
    }
    
}

#pragma mark 登陆请求
-(void)loginRequest
{
    [self.view makeProgress:@"登录中..."];
    [YMWebServiceClient loginWithParams:@{@"loginName":_accountField.text,@"loginPassword":[_passField.text changeToStringToMd5String]} Success:^(YMLoginResponse *response) {
        [self.view hiddenProgress];
        if (response.code == ERROR_OK) {
            //储存用户信息
            [ProjectUtil saveLoginInfo:response.data];
            [ProjectUtil saveLoginPhone:_accountField.text];
            //跳转首页
            UITableViewController *tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarVC"];
            self.view.window.rootViewController = tabBarVC;
        }
        else {
            [self handleErrorWithErrorResponse:response];
        }
    }];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_accountField)
    {
        [_passField becomeFirstResponder];
    }
    else if (textField==_passField)
    {
        [self loginAction];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *totalStr = [textField.text stringByAppendingString:string];
    if (totalStr.length>20)
    {
        [self.view makeToast:@"密码最多20位"];
        return NO;
    }
    else
    {
        return YES;
    }
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
