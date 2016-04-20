//
//  FillWorkTimeViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/8.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "FillWorkTimeViewController.h"
#import "FillWorkTimeCell.h"
#import "MyPickView.h"

@interface FillWorkTimeViewController ()<UITextFieldDelegate>
{
    NSMutableArray *_seletedArr;
}

@property (nonatomic,strong) NSArray *workTimeUnitArr;

@end

@implementation FillWorkTimeViewController

#pragma mark workTimeUnitArr
-(NSArray *)workTimeUnitArr
{
    if (!_workTimeUnitArr)
    {
        _workTimeUnitArr = @[@{@"name":@"小时",@"id":[NSNumber numberWithInt:1]},@{@"name":@"天",@"id":[NSNumber numberWithInt:2]},@{@"name":@"月",@"id":[NSNumber numberWithInt:3]}];
    }
    return _workTimeUnitArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    _seletedArr = [NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithDictionary:@{@"workTimesUnit":[NSNumber numberWithInt:1]}]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [self getTableViewFootView];
}

-(UIView *)getTableViewFootView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 40);
    confirmBtn.backgroundColor = RGBCOLOR(250, 142, 36);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"邀约" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 2.0;
    [confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmBtn];
    return view;
}

#pragma mark 确认按钮动作
-(void)confirmBtnAction
{
    [self.view endEditing:YES];
    BOOL isCompleted = YES;
    int count = 0;
    for (NSMutableDictionary *dic in _seletedArr)
    {
        if (dic.count<2)
        {
            isCompleted = NO;
            break;
        }
        else
        {
            FillWorkTimeCell *cell = (FillWorkTimeCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]];
            if (cell.workTimeField.text.length==0)
            {
                isCompleted = NO;
                break;
            }
            else
            {
                [dic setObject:cell.workTimeField.text forKey:@"workTimes"];
            }
        }
        count++;
    }
    if (!isCompleted)
    {
        [self.view makeToast:@"信息填写不完整，请核对"];
    }
    else
    {
        
        
       NSData *data = [NSJSONSerialization dataWithJSONObject:_seletedArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramsStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [self.view makeProgress:@"邀约中..."];
        [YMWebServiceClient inviteStuWithParams:@{@"objlist":paramsStr,@"regiId":[NSNumber numberWithInt:_invitedId]} Success:^(YMNomalResponse *response) {
            [self.view hiddenProgress];
            if(response.code==ERROR_OK){
                self.tabBarController.selectedIndex = 2;
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:JumpOrderListNotification object:[NSNumber numberWithInt:0]];
                [self.view.window makeToast:@"邀约成功"];
            }else{
                [self handleErrorWithErrorResponse:response];

            }
        }];
    }
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _seletedArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FillWorkTimeCell";
    FillWorkTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FillWorkTimeCell" owner:nil options:nil]lastObject];
    }
    cell.addCellBtn.tag = indexPath.row;
    cell.chooseWorkTimeBtn.tag = indexPath.row;
    cell.workTimeField.tag = indexPath.row;
    cell.chooseWorkTimeUnitBtn.tag = indexPath.row;
    cell.workTimeField.delegate = self;
    NSMutableDictionary *dic = _seletedArr[indexPath.row];
    if (dic[@"workStartTime"])
    {
        NSString *timeStr = [[ProjectUtil changeStandardDateStrWithSp:[dic[@"workStartTime"]integerValue]] substringToIndex:16];
        [cell.chooseWorkTimeBtn setTitle:timeStr forState:UIControlStateNormal];
    }
    else
    {
        [cell.chooseWorkTimeBtn setTitle:@"请选择工作时间" forState:UIControlStateNormal];

    }
    if (dic[@"workTimesUnit"])
    {
        [cell.chooseWorkTimeBtn setTitle:[ProjectUtil getWorkTimeUnitStrWithUnitId:[dic[@"workTimesUnit"]intValue]] forState:UIControlStateNormal];
    }
    cell.workTimeField.text = dic[@"workTimes"];
    
    [cell.addCellBtn addTarget:self action:@selector(addCellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.chooseWorkTimeBtn addTarget:self action:@selector(chooseWorkTimeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.chooseWorkTimeUnitBtn addTarget:self action:@selector(chooseWorkTimeUnitAction:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row==_seletedArr.count-1)
    {
        [cell.addCellBtn setTitleColor:RGBCOLOR(218, 87, 73) forState:UIControlStateNormal];
        cell.addCellBtn.titleLabel.text = @"添加";
        [cell.addCellBtn setTitle:@"添加" forState:UIControlStateNormal];
    }
    else
    {
        [cell.addCellBtn setTitleColor:DefaultGrayTextColor forState:UIControlStateNormal];
        cell.addCellBtn.titleLabel.text = @"删除";
        [cell.addCellBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    return cell;
}

#pragma mark 增加cell
-(void)addCellBtnAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"添加"])
    {
        [_seletedArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"workTimesUnit":[NSNumber numberWithInt:1]}]];
        [sender setTitle:@"删除" forState:UIControlStateNormal];
        [sender setTitleColor:DefaultGrayTextColor forState:UIControlStateNormal];
    }
    else if ([sender.titleLabel.text isEqualToString:@"删除"])
    {
        [_seletedArr removeObjectAtIndex:sender.tag];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark chooseWorkTimeBtnAction
-(void)chooseWorkTimeBtnAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    MyPickView *pickView = [[MyPickView alloc]initDatePickerWithTitle:@"选择工作时间"];
    pickView.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
     NSMutableDictionary *selectedDic = _seletedArr[sender.tag];
    if (selectedDic[@"workStartTime"])
    {
        pickView.datePicker.date = [ProjectUtil getDateWithTimeSp:[selectedDic[@"workStartTime"]intValue]];
        
    }
    
    [pickView handleDateConfirm:^(NSDate *date) {
        NSString *timeStr = [[ProjectUtil changeStandardDateStrWithSp:[[ProjectUtil getTimeSpWithDate:date]integerValue]] substringToIndex:16];
        sender.titleLabel.text = timeStr;
        [sender setTitle:timeStr forState:UIControlStateNormal];
       
        [selectedDic setObject:[NSNumber numberWithInt:(int)[[ProjectUtil getTimeSpWithDate:date]integerValue]] forKey:@"workStartTime"];
    }];
    [pickView show];
}

#pragma mark 选择时间单位按钮方法
-(void)chooseWorkTimeUnitAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择时间单位" Items:@[self.workTimeUnitArr]];
    NSMutableDictionary *selectedDic = _seletedArr[sender.tag];
    if (selectedDic[@"workTimesUnit"])
    {
        [pickView.pickView selectRow:[selectedDic[@"workTimesUnit"]integerValue]-1 inComponent:0 animated:YES];
    }
    
    [pickView handleConfirm:^(NSArray *selectedArr) {
        
        [selectedDic setObject:selectedArr[0] forKey:@"workTimesUnit"];
        [sender setTitle:[ProjectUtil getWorkTimeUnitStrWithUnitId:[selectedDic[@"workTimesUnit"]intValue]] forState:UIControlStateNormal];
    }];
    [pickView show];
    
}

#pragma mark textfieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
 
    NSMutableDictionary *dic = _seletedArr[textField.tag];
    [dic setObject:textField.text forKey:@"workTimes"];

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
