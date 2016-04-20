//
//  ChangePassViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/15.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "ChangePassViewController.h"

@interface ChangePassViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;


@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
   
}

-(void)layoutSubViews {
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
    if (_passField.text.length>=6&&_passField.text.length<=20&&_oldPassField.text.length>=6&&_oldPassField.text.length<=20) {
        _finishBtn.backgroundColor = DefaultOrangeColor;
        _finishBtn.userInteractionEnabled = YES;
    }
    else {
        _finishBtn.backgroundColor = DefaultUnTouchButtonColor;
        _finishBtn.userInteractionEnabled = NO;
    }
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
    [self.view showProgressHintWith:@"修改中"];
    [YMWebClient changePassWithParams:@{@"oldLoginPassword":[_oldPassField.text changeToStringToMd5String],@"newLoginPassword":[_passField.text changeToStringToMd5String]} Success:^(YMNomalResponse *response) {
        [self.view dismissProgress];
        
        if(response.code==ERROR_OK){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改密码成功，赶快重新登录吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
    }];

}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==alertView.cancelButtonIndex)
    {
        //清空用户信息并重新登录
        [ProjectUtil removeLoginInfo];
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
        if (_finishBtn.userInteractionEnabled) {
             [self finishAction];
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
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
