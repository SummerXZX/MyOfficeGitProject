//
//  PostJobViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/26.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "PostJobViewController.h"
#import "JobBaseInfoViewController.h"
#import "JobRequireViewController.h"
#import "CityDataBaseManager.h"

@interface PostJobViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    BOOL _isUpdate;
}
@property (weak, nonatomic) IBOutlet UITextField *jobNameField;
@property (weak, nonatomic) IBOutlet UILabel *decribePlaceLabel;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UILabel *baseInfoDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *workRequireDetailLabel;


@end

@implementation PostJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}

-(void)layoutSubViews
{
    //添加回收键盘View
    [self addReCycleKeyBoardView];
    
    if (_jobInfoDic)
    {
        _isUpdate = YES;
        _baseInfoDetailLabel.text = @"已完成";
        _workRequireDetailLabel.text = @"已完成";
        _jobNameField.text = _jobInfoDic[@"name"];
        _describeTextView.text = _jobInfoDic[@"workContent"];
        _decribePlaceLabel.hidden = YES;
        
    }
    else
    {
        _jobInfoDic = [NSMutableDictionary dictionary];
        _isUpdate = NO;
    }
}

#pragma mark 确认发布动作
- (IBAction)postAction:(id)sender
{
    
    if (_jobNameField.text.length==0)
    {
        [self.view makeToast:@"请填写职位名称"];
    }
    else if (!_jobInfoDic[@"baseInfo"])
    {
        [self.view makeToast:@"请填写职位的基本信息"];
    }
    else if (!_jobInfoDic[@"requireInfo"])
    {
        [self.view makeToast:@"请填写工作要求"];
    }
    else if (_workRequireDetailLabel.text.length==0)
    {
        [self.view makeToast:@"请填写工作描述"];
    }
    else
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:_jobInfoDic[@"baseInfo"]];
        [params addEntriesFromDictionary:_jobInfoDic[@"requireInfo"]];
        [params setObject:_jobNameField.text forKey:@"name"];
        [params setObject:_describeTextView.text forKey:@"workContent"];
        [params setObject:[NSString stringWithFormat:@"%@%@%@",[CityDataBaseManager getCityNameWithType:CityTypeCity CityId:[_jobInfoDic[@"baseInfo"][@"cityId"]intValue]],[CityDataBaseManager getCityNameWithType:CityTypeCounty CityId:[_jobInfoDic[@"baseInfo"][@"areaId"]intValue]],_jobInfoDic[@"baseInfo"][@"street"]] forKey:@"address"];
        if (_isUpdate)
        {
            [params setObject:_jobInfoDic[@"id"] forKey:@"id"];
            [self.view makeProgress:@"更新中..."];
            [YMWebServiceClient updateJobWithParams:params Success:^(YMNomalResponse *response) {
                [self.view hiddenProgress];
                if(response.code==ERROR_OK){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:JumpJobListNotification object:nil];
                    [self.view.window makeToast:@"更新成功"];
                }else{
                    [self handleErrorWithErrorResponse:response];
                }
            }];
        }
        else
        {
            [self.view makeProgress:@"发布中..."];
            [YMWebServiceClient postJobWithParams:params Success:^(YMNomalResponse *response) {
                [self.view hiddenProgress];
                if(response.code==ERROR_OK){
                    self.tabBarController.selectedIndex = 1;
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:JumpJobListNotification object:nil];
                    [self.view.window makeToast:@"发布成功"];
                }else{
                    [self handleErrorWithErrorResponse:response];
                }
            }];
        }
        
    }
}



#pragma mark 添加回收键盘View
-(void)addReCycleKeyBoardView
{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    [doneButton setTitleTextAttributes:@{NSForegroundColorAttributeName:DefaultGrayTextColor} forState:UIControlStateNormal];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [_describeTextView setInputAccessoryView:topView];
}

-(void)dismissKeyBoard
{
    [_describeTextView resignFirstResponder];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text stringByAppendingString:string].length>12)
    {
        [textField resignFirstResponder];
        [self.view makeToast:@"请输入12字以内的职位名称"];
        return NO;
    }
    return YES;
}

#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length!=0)
    {
        _decribePlaceLabel.hidden = YES;
    }
    else
    {
        _decribePlaceLabel.hidden = NO;
    }
}


#pragma mark tableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        return 2;
    }
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            JobBaseInfoViewController *jobBaseInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JobBaseInfoVC"];
            jobBaseInfoVC.baseInfoDic = _jobInfoDic[@"baseInfo"];
            jobBaseInfoVC.title = @"基本信息";
            [jobBaseInfoVC handleBaseInfo:^(NSMutableDictionary *baseInfo) {
                [_jobInfoDic setObject:baseInfo forKey:@"baseInfo"];
                _baseInfoDetailLabel.text = @"已完成";
            }];
            [self.navigationController pushViewController:jobBaseInfoVC animated:YES];
            
        }
        else if (indexPath.row==1)
        {
            JobRequireViewController *jobRequireVC =[self.storyboard instantiateViewControllerWithIdentifier:@"JobRequireVC"];
            jobRequireVC.jobRequireDic = _jobInfoDic[@"requireInfo"];
            jobRequireVC.title = @"工作要求";
            [jobRequireVC handleRequireInfo:^(NSMutableDictionary *jobRequireInfo) {
                [_jobInfoDic setObject:jobRequireInfo forKey:@"requireInfo"];
                _workRequireDetailLabel.text = @"已完成";
            }];
            [self.navigationController pushViewController:jobRequireVC animated:YES];
            
        }
            
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
