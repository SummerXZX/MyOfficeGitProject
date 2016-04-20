//
//  LoginViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/21.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *accountField;

@property (weak, nonatomic) IBOutlet UITextField *passField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self setViewBasicProperty];

    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textfieldDidChanged)
     name:UITextFieldTextDidChangeNotification
     object:nil];

}

#pragma mark 监听TextField变化
- (void)textfieldDidChanged
{
    if (_passField.text.length>=6&&_passField.text.length<=20&& _accountField.text.length!=0) {
        _loginBtn.backgroundColor = DefaultOrangeColor;
        _loginBtn.userInteractionEnabled = YES;
    }
    else {
        _loginBtn.backgroundColor = DefaultUnTouchButtonColor;
        _loginBtn.userInteractionEnabled = NO;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _accountField.text = [ProjectUtil getLoginPhone];
}



-(void)dealloc
{
    [ProjectUtil showLog:NSStringFromClass([self class])];

    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UITextFieldTextDidChangeNotification
     object:nil];
    
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

#pragma mark 登录按钮动作
- (IBAction)loginAction
{
    [self.view endEditing:YES];
    
    [self.view showProgressHintWith:@"登录中"];
    [YMWebClient loginWithParams:@{@"loginName":_accountField.text,@"loginPassword":[_passField.text changeToStringToMd5String]} Success:^(YMLoginResponse *response) {
        [self.view dismissProgress];
        if (response.code == ERROR_OK) {
            //储存用户信息
            [ProjectUtil saveLoginInfo:response.data];
            [ProjectUtil saveLoginPhone:_accountField.text];
            
            if (response.data.isPublish==0) {
                UIViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CorpInfoViewController"];
                nextVC.title = @"完善商家信息";
                self.view.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:nextVC];
            }
            else {
                //跳转首页
                HomeViewController *homeVC = [[HomeViewController alloc]init];
                self.view.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homeVC];
            }
        }
        else {
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
    }];
    
    
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField==_accountField) {
        [_passField becomeFirstResponder];
    }
    else {
        if (_loginBtn.userInteractionEnabled) {
            //登录
            [self loginAction];
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
