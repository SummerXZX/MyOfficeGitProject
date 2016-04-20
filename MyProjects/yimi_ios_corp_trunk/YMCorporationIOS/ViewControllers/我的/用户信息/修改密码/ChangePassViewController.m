//
//  ChangePassViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/3.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ChangePassViewController.h"

@interface ChangePassViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassField;

@property (weak, nonatomic) IBOutlet UITextField *passField;

@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    
}

- (IBAction)showPass:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        if (sender.tag==1)
        {
            _oldPassField.secureTextEntry = NO;
        }
        else if (sender.tag==2)
        {
            _passField.secureTextEntry = NO;
        }
    }
    else
    {
        if (sender.tag==1)
        {
            _oldPassField.secureTextEntry = YES;
        }
        else if (sender.tag==2)
        {
            _passField.secureTextEntry = YES;
        }
    }
}

#pragma mark 完成动作
- (IBAction)finishAction
{
    [self.view endEditing:YES];
    if (_oldPassField.text.length==0)
    {
        [self.view makeToast:@"请输入旧密码"];
    }
    else if (_oldPassField.text.length<6)
    {
        [self.view makeToast:@"密码最少6位"];
    }
    else if (_passField.text.length==0)
    {
        [self.view makeToast:@"请输入新密码"];
    }
    else if (_passField.text.length<6)
    {
        [self.view makeToast:@"密码最少6位"];
    }
    else
    {
        [self requestChangePass];
    }
}

#pragma mark requestChangePass
-(void)requestChangePass
{
    [self.view makeProgress:@"修改中..."];
    [YMWebServiceClient changePassWithParams:@{@"oldLoginPassword":[_oldPassField.text changeToStringToMd5String],@"newLoginPassword":[_passField.text changeToStringToMd5String]} Success:^(YMNomalResponse *response) {
        [self.view hiddenProgress];

        if(response.code==ERROR_OK){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改密码成功，赶快重新登陆吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            [self handleErrorWithErrorResponse:response];
        }
    }];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==alertView.cancelButtonIndex)
    {
        //清空用户信息并重新登录
        [ProjectUtil deleteLoginInfo];
        
            self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaVC"];

    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_oldPassField)
    {
        [_passField becomeFirstResponder];
    }
    else if (textField==_passField)
    {
        [self finishAction];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *totalStr = [textField.text stringByAppendingString:string];
    if (textField==_passField && totalStr.length>20)
    {
        [self.view makeToast:@"密码最多20位"];
        return NO;
    }
    return YES;
}

#pragma mark tableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
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
