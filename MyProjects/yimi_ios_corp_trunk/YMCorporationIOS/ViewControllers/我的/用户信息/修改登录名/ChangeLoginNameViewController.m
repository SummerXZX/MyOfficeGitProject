//
//  ChangeLoginNameViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/9.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ChangeLoginNameViewController.h"

@interface ChangeLoginNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginNameField;

@end

@implementation ChangeLoginNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    YMCorpSummary *corpInfo = [ProjectUtil getCorpInfo];
    _loginNameField.text = corpInfo.loginName;
}

#pragma mark 完成按钮动作
- (IBAction)finishBtnAction
{
    [self.view endEditing:YES];
    if (_loginNameField.text.length==0) {
        [self.view makeToast:@"请输入登录名"];
    }
    else if (_loginNameField.text.length<5)
    {
        [self.view makeToast:@"请输入6-20字登录名"];
    }
    else
    {
        
        [self.view makeProgress:@"修改中..."];
    
        [YMWebServiceClient updateCorpLoginNameWithParams:@{@"loginName":_loginNameField.text} Success:^(YMNomalResponse *response) {
            [self.view hiddenProgress];
            if(response.code==ERROR_OK){
                //储存用户信息
                
                YMCorpSummary *corpInfo = [ProjectUtil getCorpInfo];
                corpInfo.loginName = _loginNameField.text;
                [ProjectUtil saveLoginCorpInfo:corpInfo];
                [self.navigationController popViewControllerAnimated:YES];
                                [self.view.window makeToast:@"修改成功"];
            }else{
                [self handleErrorWithErrorResponse:response];

            }
        }];
    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self finishBtnAction];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text stringByAppendingString:string].length>20)
    {
        [self.view makeToast:@"请输入6-20字登录名"];
        return NO;
    }
    return YES;
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
