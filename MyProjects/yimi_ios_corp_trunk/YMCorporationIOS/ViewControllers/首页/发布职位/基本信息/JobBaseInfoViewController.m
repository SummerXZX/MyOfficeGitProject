//
//  JobBaseInfoViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/26.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "JobBaseInfoViewController.h"
#import "MyPickView.h"
#import "LocalDicDataBaseManager.h"
#import "CityDataBaseManager.h"

@interface JobBaseInfoViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    JobBaseInfoBlock _baseInfoBlock;
}
@property (weak, nonatomic) IBOutlet UIButton *jobTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *validStartDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *validEndDateBtn;

@property (weak, nonatomic) IBOutlet UIButton *jobDateBtn;
@property (weak, nonatomic) IBOutlet UITextField *salaryCountField;
@property (weak, nonatomic) IBOutlet UIButton *salaryUnitBtn;
@property (weak, nonatomic) IBOutlet UIButton *settleTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *recuitCountField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *contactField;
@property (weak, nonatomic) IBOutlet UIButton *addressAreaBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressPlaceLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressDetailTextView;

@end

@implementation JobBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view.window hiddenProgress];
}

-(void)layoutSubViews
{
    [self addReCycleKeyBoardView];
    
    if (!_baseInfoDic)
    {
        _baseInfoDic = [NSMutableDictionary dictionary];
        [_baseInfoDic setObject:[NSNumber numberWithInt:1] forKey:@"payUnit"];
    }
    else
    {
        [_jobTypeBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobType VersionId:[_baseInfoDic[@"jobtypeId"] intValue]] forState:UIControlStateNormal];
        [_jobTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        NSString *validStartStr =  [ProjectUtil changeToDefaultDateStrWithSp:[_baseInfoDic[@"startTime"]integerValue]];
        [_validStartDateBtn setTitle:validStartStr forState:UIControlStateNormal];
        [_validStartDateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        NSString *validEndStr =  [ProjectUtil changeToDefaultDateStrWithSp:[_baseInfoDic[@"endTime"]integerValue]];
        [_validEndDateBtn setTitle:validEndStr forState:UIControlStateNormal];
        [_validEndDateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];;
        
        [_jobDateBtn setTitle:[MyPickView getTimeInfoStrWithTimeStr:_baseInfoDic[@"jobTime"]] forState:UIControlStateNormal];
        [_jobDateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _salaryCountField.text = [NSString stringWithFormat:@"%@",_baseInfoDic[@"pay"]];
        
        
        [_settleTypeBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobSettleType VersionId:[_baseInfoDic[@"jobsettletypeId"] intValue]] forState:UIControlStateNormal];
        [_settleTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        [_salaryUnitBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:[_baseInfoDic[@"payUnit"] intValue]] forState:UIControlStateNormal];

        _recuitCountField.text = [NSString stringWithFormat:@"%@",_baseInfoDic[@"count"]];
        _phoneField.text = _baseInfoDic[@"tel"];
        
        _contactField.text = _baseInfoDic[@"contact"];
  

        NSString *cityStr = [NSString stringWithFormat:@"%@%@",[CityDataBaseManager getCityNameWithType:CityTypeCity CityId:[_baseInfoDic[@"cityId"]intValue]],[CityDataBaseManager getCityNameWithType:CityTypeCounty CityId:[_baseInfoDic[@"areaId"]intValue]]];
            [_addressAreaBtn setTitle:cityStr forState:UIControlStateNormal];
            [_addressAreaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addressDetailTextView.text = _baseInfoDic[@"street"];
        _addressPlaceLabel.hidden = YES;
    }
}

-(void)handleBaseInfo:(JobBaseInfoBlock)baseInfoBlock
{
    _baseInfoBlock = baseInfoBlock;
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
    [_addressDetailTextView setInputAccessoryView:topView];
    [_salaryCountField setInputAccessoryView:topView];
    [_recuitCountField setInputAccessoryView:topView];
    [_phoneField setInputAccessoryView:topView];
    
}

-(void)dismissKeyBoard
{
    [self.view endEditing:YES];
}


#pragma mark 选择职位类型
- (IBAction)chooseJobTypeAction
{
    [self.view endEditing:YES];
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择职位类型" Items:@[[LocalDicDataBaseManager getJobType]]];
    
    if (_baseInfoDic[@"jobtypeId"])
    {
        [pickView.pickView selectRow:[_baseInfoDic[@"jobtypeId"]integerValue]-1 inComponent:0 animated:YES];
    }
    
    [pickView handleConfirm:^(NSArray *selectedArr) {
        
        [_baseInfoDic setObject:selectedArr[0] forKey:@"jobtypeId"];
        [_jobTypeBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobType VersionId:[_baseInfoDic[@"jobtypeId"] intValue]] forState:UIControlStateNormal];
        [_jobTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
    [pickView show];
}

#pragma mark 选择有效起始日期
- (IBAction)chooseValidStartDateAction
{
    [self.view endEditing:YES];
    MyPickView *pickView = [[MyPickView alloc]initDatePickerWithTitle:@"请选择有效起始日期"];
    
    if (_baseInfoDic[@"startTime"])
    {
        NSDate *validStartDate = [ProjectUtil getDateWithTimeSp:[_baseInfoDic[@"startTime"]integerValue]];
        pickView.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
        [pickView.datePicker setDate:validStartDate animated:YES];
    }
    if (_baseInfoDic[@"endTime"])
    {
       NSDate *validEndDate = [ProjectUtil getDateWithTimeSp:[_baseInfoDic[@"endTime"]integerValue]];
        NSDate *validStartDate = [NSDate dateWithTimeInterval:-30*24*3600 sinceDate:validEndDate];
        pickView.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
        pickView.datePicker.maximumDate = validStartDate;
    }
    [pickView handleDateConfirm:^(NSDate *date) {
        NSInteger sp = [[ProjectUtil getTimeSpWithDate:date]integerValue];
        NSString *timeStr = [ProjectUtil changeToDefaultDateStrWithSp:sp];
        [_validStartDateBtn setTitle:timeStr forState:UIControlStateNormal];
        [_validStartDateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_baseInfoDic setObject:[NSNumber numberWithInteger:sp] forKey:@"startTime"];
    }];
    [pickView show];
}

#pragma mark 选择有效结束日期
- (IBAction)chooseValidEndDateAction
{
    [self.view endEditing:YES];
    MyPickView *pickView = [[MyPickView alloc]initDatePickerWithTitle:@"请选择有效结束日期"];
    if (_baseInfoDic[@"endTime"])
    {
        NSDate *validEndDate = [ProjectUtil getDateWithTimeSp:[_baseInfoDic[@"endTime"]integerValue]];
        [pickView.datePicker setDate:validEndDate animated:YES];
    }
    else if (_baseInfoDic[@"startTime"])
    {
        NSDate *validStartDate = [ProjectUtil getDateWithTimeSp:[_baseInfoDic[@"startTime"]integerValue]+24*3600];
        [pickView.datePicker setDate:validStartDate animated:YES];
    }
    else {
        pickView.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:24*3600];
    }

    if (_baseInfoDic[@"startTime"])
    {
        NSDate *validStartDate = [ProjectUtil getDateWithTimeSp:[_baseInfoDic[@"startTime"]integerValue]+24*3600];
        NSDate *validEndDate = [NSDate dateWithTimeInterval:30*24*3600 sinceDate:validStartDate];
        pickView.datePicker.minimumDate = validStartDate;
        pickView.datePicker.maximumDate = validEndDate;
    }
    
    [pickView handleDateConfirm:^(NSDate *date) {
        NSInteger sp = [[ProjectUtil getTimeSpWithDate:date]integerValue];
        NSString *timeStr = [ProjectUtil changeToDefaultDateStrWithSp:sp];
        [_validEndDateBtn setTitle:timeStr forState:UIControlStateNormal];
        [_validEndDateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_baseInfoDic setObject:[NSNumber numberWithInteger:sp] forKey:@"endTime"];
    }];
    [pickView show];
}

#pragma mark 选择兼职时间
- (IBAction)chooseJobTimeAction
{
    [self.view endEditing:YES];
    MyPickView *pickView = [[MyPickView alloc]initWorkTimePickerWithTitle:@"请选择兼职时间"];
    if (_baseInfoDic[@"jobTime"])
    {
        [pickView workTimeSeletedTimeStr:_baseInfoDic[@"jobTime"]];
    }
    [pickView handleWorkTimeConfirm:^(NSString *timeStr)
    {
        [_baseInfoDic setObject:timeStr forKey:@"jobTime"];
        [_jobDateBtn setTitle:[MyPickView getTimeInfoStrWithTimeStr:_baseInfoDic[@"jobTime"]] forState:UIControlStateNormal];
        [_jobDateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }];
    [pickView show];
}

#pragma mark 选择薪资单位
- (IBAction)chooseSalaryUnitAction
{
  [self.view endEditing:YES];
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择薪资单位" Items:@[[LocalDicDataBaseManager getJobPayUnit]]];
    if (_baseInfoDic[@"payUnit"])
    {
        [pickView.pickView selectRow:[_baseInfoDic[@"payUnit"]integerValue]-1 inComponent:0 animated:YES];
    }
    [pickView handleConfirm:^(NSArray *selectedArr) {
        [_baseInfoDic setObject:selectedArr[0] forKey:@"payUnit"];
        [_salaryUnitBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:[_baseInfoDic[@"payUnit"] intValue]] forState:UIControlStateNormal];
        [_salaryUnitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
    [pickView show];
}

#pragma mark 选择结算方式
- (IBAction)chooseSettleTypeAction
{
    [self.view endEditing:YES];
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择结算方式" Items:@[[LocalDicDataBaseManager getJobSettleType]]];
    if (_baseInfoDic[@"jobsettletypeId"])
    {
         [pickView.pickView selectRow:[_baseInfoDic[@"jobsettletypeId"]integerValue]-1 inComponent:0 animated:YES];
    }
    [pickView handleConfirm:^(NSArray *selectedArr) {
        [_baseInfoDic setObject:selectedArr[0] forKey:@"jobsettletypeId"];
        [_settleTypeBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobSettleType VersionId:[_baseInfoDic[@"jobsettletypeId"] intValue]] forState:UIControlStateNormal];
        [_settleTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }];
    [pickView show];
}

#pragma mark 选择地址区域
- (IBAction)chooseAddressAreaAction
{
    [self.view endEditing:YES];
    
    [self.view.window makeProgress:@"获取中..."];
    [YMWebServiceClient getCityListSuccess:^(YMNomalResponse *response) {
        [self.view.window hiddenProgress];
        if(response.code==ERROR_OK){
            NSArray *cityArr = response.data[@"citys"];;
            NSArray *countyArr;
            if (_baseInfoDic[@"cityId"])
            {
                countyArr = [CityDataBaseManager getCountyWithParentId:[_baseInfoDic[@"cityId"] intValue]];
            }
            else
            {
                countyArr = [CityDataBaseManager getCountyWithParentId:[cityArr[0][@"id"]intValue]];
            }
            MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择地址区域" Items:@[cityArr,countyArr]];
             pickView.isAreaPicker = YES;
            if (_baseInfoDic[@"cityId"])
            {
                NSInteger cityIndex = [self getCityArrIndexWithCityId:[_baseInfoDic[@"cityId"] integerValue] CityArr:cityArr];
                [pickView.pickView selectRow:cityIndex inComponent:0 animated:YES];
                NSInteger countyIndex = [self getCityArrIndexWithCityId:[_baseInfoDic[@"areaId"] integerValue] CityArr:countyArr];
                [pickView.pickView selectRow:countyIndex inComponent:1 animated:YES];
            }
         
            [pickView handleConfirm:^(NSArray *selectedArr)
            {
                [_baseInfoDic setObject:selectedArr[0] forKey:@"cityId"];
                [_baseInfoDic setObject:selectedArr[1] forKey:@"areaId"];
                NSString *cityStr = [NSString stringWithFormat:@"%@%@",[CityDataBaseManager getCityNameWithType:CityTypeCity CityId:[_baseInfoDic[@"cityId"]intValue]],[CityDataBaseManager getCityNameWithType:CityTypeCounty CityId:[_baseInfoDic[@"areaId"]intValue]]];
                [_addressAreaBtn setTitle:cityStr forState:UIControlStateNormal];
                [_addressAreaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }];
            [pickView show];
        }else{
            [self handleErrorWithErrorResponse:response];

        }
    }];
}

#pragma mark 获取CityId在数组的索引
-(NSInteger)getCityArrIndexWithCityId:(NSInteger)cityId CityArr:(NSArray *)cityArr;
{
    NSInteger objIndex = 0;
    for (NSDictionary *cityDic in cityArr)
    {
        if ([cityDic[@"id"]integerValue]==cityId)
        {
            return objIndex;
        }
        objIndex++;
    }
    return 0;
}

#pragma mark 确认按钮动作
- (IBAction)confirmBtnAction
{
    [self.view endEditing:YES];
    if (!_baseInfoDic[@"jobtypeId"])
    {
        [self.view.window makeToast:@"请选择职位类型"];
    }
    else if (!_baseInfoDic[@"startTime"])
    {
        [self.view.window makeToast:@"选择有效起始时间"];
    }
    else if (!_baseInfoDic[@"endTime"])
    {
        [self.view.window makeToast:@"选择有效结束时间"];
    }
    else if (!_baseInfoDic[@"jobTime"])
    {
        [self.view.window makeToast:@"请选择兼职时间"];
    }
    else if (_salaryCountField.text.length==0)
    {
        [self.view.window makeToast:@"请输入工资金额"];
    }
    else if (!_baseInfoDic[@"jobsettletypeId"])
    {
        [self.view.window makeToast:@"请选择结算方式"];
    }
    else if (_recuitCountField.text.length==0)
    {
        [self.view.window makeToast:@"请填写招聘人数"];
    }
    else if (_phoneField.text.length==0)
    {
        [self.view.window makeToast:@"请填写联系电话"];
    }
    else if (_contactField.text.length==0)
    {
        [self.view.window makeToast:@"请填写联系人"];
    }
    else if (!_baseInfoDic[@"cityId"])
    {
        [self.view.window makeToast:@"请选择地址区域"];
    }
    else if (_addressDetailTextView.text.length==0)
    {
        [self.view.window makeToast:@"请填写详细地址"];
    }
    else
    {
        [_baseInfoDic setObject:[NSNumber numberWithInt:[_salaryCountField.text intValue]]  forKey:@"pay"];
        [_baseInfoDic setObject:[NSNumber numberWithInt:[_recuitCountField.text intValue]] forKey:@"count"];
        [_baseInfoDic setObject:_phoneField.text forKey:@"tel"];
        [_baseInfoDic setObject:_contactField.text forKey:@"contact"];
        [_baseInfoDic setObject:_addressDetailTextView.text forKey:@"street"];
        if (_baseInfoBlock)
        {
            _baseInfoBlock(_baseInfoDic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text stringByAppendingString:string].length>20&&textField==_contactField)
    {
        [textField resignFirstResponder];
        [self.view.window makeToast:@"请输入20字以内的联系人"];
        return NO;
    }
    return YES;
}

#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length!=0)
    {
        _addressPlaceLabel.hidden = YES;
        
    }
    else
    {
        _addressPlaceLabel.hidden = NO;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text stringByAppendingString:text].length>200&&textView==_addressDetailTextView)
    {
        [textView resignFirstResponder];
        [self.view.window makeToast:@"请输入200字以内的地址详情"];
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
   return 10;
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
