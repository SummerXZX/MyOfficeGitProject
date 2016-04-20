//
//  LoginViewController.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/12.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameField;///<用户名输入框

@property (weak, nonatomic) IBOutlet UITextField *passField;///<密码输入框
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;///<登陆按钮

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userNameField.text = [ProjectUtil getLoginName];
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImageView.image = [UIImage imageNamed:@"login_bg.jpg"];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    //创建tableview的HeaderView
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-190-160)];
    imageView.image = [UIImage imageNamed:@"login_toptext"];
    imageView.contentMode = UIViewContentModeCenter;
    self.tableView.tableHeaderView = imageView;

    //监听文本变化
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textfieldDidChanged)
     name:UITextFieldTextDidChangeNotification
     object:nil];

}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark 监听TextField变化
- (void)textfieldDidChanged
{
    if (_userNameField.text.length > 0 && _passField.text.length >= PASSMINLENGTH && _passField.text.length <= PASSMAXLENGTH) {
        _loginBtn.backgroundColor = NavigationBarColor;
        _loginBtn.userInteractionEnabled = YES;
    }
    else {
        _loginBtn.backgroundColor = DefaultUnTouchButtonColor;
        _loginBtn.userInteractionEnabled = NO;
    }
}

#pragma mark 跳转首页
- (IBAction)loginAction {
    [self.view endEditing:YES];
    [self.view makeProgress:@"登陆中..."];
    
    [WebServiceClient loginWithParams:@{@"name":_userNameField.text,@"pwd":_passField.text} success:^(WebLoginResponse *response) {
        [self.view hiddenProgress];
        //保存登陆数据
        [ProjectUtil saveLoginData:response.data];
        //跳转首页
        self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
        
    } Fail:^(NSError *error) {
        [self.view hiddenProgress];
        [self.view makeToast:error.domain];
    }];
}


#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==_userNameField) {
        [_passField becomeFirstResponder];
    }
    else if (textField==_passField) {
        if (_loginBtn.userInteractionEnabled) {
            [self loginAction];
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
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
