//
//  ChangePassViewController.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/16.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "ChangePassViewController.h"

@interface ChangePassViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *oldPassField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UITextField *rePassField;
@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    if (_oldPassField.text.length>=PASSMINLENGTH&&_oldPassField.text.length<=PASSMAXLENGTH&&_passField.text.length>=PASSMINLENGTH&&_passField.text.length<=PASSMAXLENGTH&&_rePassField.text.length>=PASSMINLENGTH&&_rePassField.text.length<=PASSMAXLENGTH&&[_rePassField.text isEqualToString:_passField.text]) {
        _saveBtn.backgroundColor = NavigationBarColor;
        _saveBtn.userInteractionEnabled = YES;
    }
    else {
        _saveBtn.backgroundColor = DefaultUnTouchButtonColor;
        _saveBtn.userInteractionEnabled = NO;
    }
    
}




#pragma mark 保存动作
- (IBAction)saveAction {
    [self.view endEditing:YES];
    [self.view makeProgress:@"保存中..."];
    WebLoginData *loginData = [ProjectUtil getLoginData];
    [WebServiceClient changeLoginPassWithParams:@{@"uid":loginData.userId,@"oldPwd":_oldPassField.text,@"newPwd":_passField.text} success:^(WebNomalResponse *response) {
        [self.view hiddenProgress];
        //清空用户信息
        [ProjectUtil removeLoginData];
        self.view.window.rootViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [[UIApplication sharedApplication].keyWindow makeToast:@"修改成功，赶快登陆吧！"];
        
    } Fail:^(NSError *error) {
        [self.view hiddenProgress];
        [self.view makeToast:error.domain];
    }];
}


#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==_oldPassField) {
        [_passField becomeFirstResponder];
    }
    else if (textField==_passField) {
        [_rePassField becomeFirstResponder];
    }
    else if (textField==_rePassField) {
        if (_saveBtn.userInteractionEnabled) {
            [self saveAction];
        }
    }
    [textField resignFirstResponder];
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.contentView.backgroundColor = DefaultBackGroundColor;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
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
