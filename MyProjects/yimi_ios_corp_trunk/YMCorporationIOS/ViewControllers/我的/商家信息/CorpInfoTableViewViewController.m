//
//  CorpInfoTableViewViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/29.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "CorpInfoTableViewViewController.h"
#import "MyPickView.h"
#import "LocalDicDataBaseManager.h"
#import "CityDataBaseManager.h"


@interface CorpInfoTableViewViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *corpNameField;
@property (weak, nonatomic) IBOutlet UIButton *corpPropertyBtn;
@property (weak, nonatomic) IBOutlet UIButton *corpSizeBtn;
@property (weak, nonatomic) IBOutlet UIButton *corpTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *corpProfessBtn;
@property (weak, nonatomic) IBOutlet UITextField *contactsField;
@property (weak, nonatomic) IBOutlet UITextField *contactTelField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *corpIntroPlaceLabel;
@property (weak, nonatomic) IBOutlet UITextView *corpIntroTextView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextView *corpNotiTextView;
@property (weak, nonatomic) IBOutlet UILabel *corpNotiPlaceLabel;

@end

@implementation CorpInfoTableViewViewController

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
    //添加回收键盘View
    [self addReCycleKeyBoardView];
    if (_corpInfoDic.count!=0)
    {
        _corpNameField.text = _corpInfoDic[@"name"];
        [_corpPropertyBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeCorpProperty VersionId:[_corpInfoDic[@"propertyId"]intValue]] forState:UIControlStateNormal];
        [_corpPropertyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_corpTypeBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeCorpType VersionId:[_corpInfoDic[@"ctypeId"]intValue]] forState:UIControlStateNormal];
        [_corpTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_corpProfessBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeCorpIndustry VersionId:[_corpInfoDic[@"industryId"]intValue]] forState:UIControlStateNormal];
        [_corpProfessBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_corpSizeBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeCorpSize VersionId:[_corpInfoDic[@"sizeId"]intValue]] forState:UIControlStateNormal];
        [_corpSizeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _contactsField.text = _corpInfoDic[@"contact"];
        _contactTelField.text = _corpInfoDic[@"tel"];
        _emailField.text = _corpInfoDic[@"email"];
        [_cityBtn setTitle:[CityDataBaseManager getCityNameWithType:CityTypeCity CityId:[_corpInfoDic[@"cityId"]intValue]] forState:UIControlStateNormal];
        [_cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addressField.text = _corpInfoDic[@"address"];
        _corpIntroTextView.text = _corpInfoDic[@"intro"];
        if (_corpIntroTextView.text.length!=0)
        {
            _corpIntroPlaceLabel.hidden = YES;
        }
        _corpNotiTextView.text = _corpInfoDic[@"notice"];
        if (_corpNotiTextView.text.length!=0)
        {
            _corpNotiPlaceLabel.hidden = YES;
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
    [_contactTelField setInputAccessoryView:topView];
    [_corpIntroTextView setInputAccessoryView:topView];
    [_corpNotiTextView setInputAccessoryView:topView];
}

-(void)dismissKeyBoard
{
    [self.view endEditing:YES];
}

#pragma mark 选择商家属性
- (IBAction)chooseCorpPropertyAction
{
    [self.view endEditing:YES];
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择商家属性" Items:@[[LocalDicDataBaseManager getCorpProperty]]];
    if (_corpInfoDic[@"propertyId"])
    {
        [pickView.pickView selectRow:[_corpInfoDic[@"propertyId"]integerValue]-1 inComponent:0 animated:YES];
    }
    [pickView handleConfirm:^(NSArray *selectedArr) {
        [_corpInfoDic setObject:selectedArr[0] forKey:@"propertyId"];
        [_corpPropertyBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeCorpProperty VersionId:[_corpInfoDic[@"propertyId"]intValue]] forState:UIControlStateNormal];
        [_corpPropertyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }];
    [pickView show];
}

#pragma mark 选择商家类型
- (IBAction)chooseCorpTypeAction
{
    [self.view endEditing:YES];
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择商家类型" Items:@[[LocalDicDataBaseManager getCorpType]]];
    if (_corpInfoDic[@"ctypeId"])
    {
        [pickView.pickView selectRow:[_corpInfoDic[@"ctypeId"]integerValue]-1 inComponent:0 animated:YES];
    }
    [pickView handleConfirm:^(NSArray *selectedArr) {
         [_corpInfoDic setObject:selectedArr[0] forKey:@"ctypeId"];
        [_corpTypeBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeCorpType VersionId:[_corpInfoDic[@"ctypeId"]intValue]] forState:UIControlStateNormal];
        [_corpTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
    }];
    [pickView show];
}

#pragma mark 选择所属行业
- (IBAction)chooseCorpProfessAction
{
    [self.view endEditing:YES];
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择所属行业" Items:@[[LocalDicDataBaseManager getCorpIndustry]]];
    if (_corpInfoDic[@"industryId"])
    {
        [pickView.pickView selectRow:[_corpInfoDic[@"industryId"]integerValue]-1 inComponent:0 animated:YES];
    }
    [pickView handleConfirm:^(NSArray *selectedArr) {
       [_corpInfoDic setObject:selectedArr[0] forKey:@"industryId"];
        [_corpProfessBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeCorpIndustry VersionId:[_corpInfoDic[@"industryId"]intValue]] forState:UIControlStateNormal];
        [_corpProfessBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }];
    [pickView show];
}

#pragma mark 选择商家规模
- (IBAction)chooseCorpSizeAction:(id)sender
{
    [self.view endEditing:YES];
    
    MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"请选择商家规模" Items:@[[LocalDicDataBaseManager getCorpSize]]];
    if (_corpInfoDic[@"sizeId"])
    {
        [pickView.pickView selectRow:[_corpInfoDic[@"sizeId"]integerValue]-1 inComponent:0 animated:YES];
    }
    [pickView handleConfirm:^(NSArray *selectedArr) {
        [_corpInfoDic setObject:selectedArr[0] forKey:@"sizeId"];
        [_corpSizeBtn setTitle:[LocalDicDataBaseManager getNameWithType:LocalDicTypeCorpSize VersionId:[_corpInfoDic[@"sizeId"]intValue]] forState:UIControlStateNormal];
        [_corpSizeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
    [pickView show];

}

#pragma mark 选择所在城市
- (IBAction)chooseCityAction:(id)sender
{
    [self.view endEditing:YES];
    [self.view.window makeProgress:@"获取中..."];
    [YMWebServiceClient getCityListSuccess:^(YMNomalResponse *response) {
        [self.view.window hiddenProgress];
        if(response.code==ERROR_OK){
            NSArray *cityArr = response.data[@"citys"];;
            MyPickView *pickView = [[MyPickView alloc]initWithTitle:@"选择所在城市" Items:@[cityArr]];
            if (_corpInfoDic[@"cityId"])
            {
               [pickView.pickView selectRow:[self getCityArrIndexWithCityId:[_corpInfoDic[@"cityId"]integerValue] CityArr:cityArr] inComponent:0 animated:YES];
            }
            [pickView handleConfirm:^(NSArray *selectedArr) {
                [_corpInfoDic setObject:selectedArr[0] forKey:@"cityId"];
                [_cityBtn setTitle:[CityDataBaseManager getCityNameWithType:CityTypeCity CityId:[_corpInfoDic[@"cityId"]intValue]] forState:UIControlStateNormal];
                [_cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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


#pragma mark 保存信息
- (IBAction)saveAction
{
    [self.view endEditing:YES];
    if (_corpNameField.text.length==0)
    {
        [self.view.window makeToast:@"请填写商家名称"];
    }
    else if (!_corpInfoDic[@"propertyId"])
    {
        [self.view.window makeToast:@"请选择商家属性"];
    }
    else if (!_corpInfoDic[@"ctypeId"])
    {
        [self.view.window makeToast:@"请选择商家类型"];
    }
    else if (!_corpInfoDic[@"industryId"])
    {
        [self.view.window makeToast:@"请选择所属行业"];
    }
    else if (!_corpInfoDic[@"sizeId"])
    {
        [self.view.window makeToast:@"请选择商家规模"];
    }
    else if (_contactsField.text.length==0)
    {
        [self.view.window makeToast:@"请填写联系人"];
    }
    else if (_contactTelField.text.length==0)
    {
        [self.view.window makeToast:@"请填写联系电话"];
    }
    else if (!_corpInfoDic[@"cityId"])
    {
        [self.view.window makeToast:@"请选择所在城市"];
    }
    else if (_addressField.text.length==0)
    {
        [self.view.window makeToast:@"请填写详细地址"];
    }
    else if (_corpIntroTextView.text.length==0)
    {
        [self.view.window makeToast:@"请填写公司简介"];
    }
    else
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:_corpInfoDic];
        [params setObject:_corpNameField.text forKey:@"name"];
        [params setObject:_contactsField.text forKey:@"contact"];
        [params setObject:_contactTelField.text forKey:@"tel"];
        [params setObject:_emailField.text forKey:@"email"];
        [params setObject:_addressField.text forKey:@"address"];
        [params setObject:_corpIntroTextView.text forKey:@"intro"];
        [params setObject:_corpNotiTextView.text forKey:@"notice"];
        [self.view.window makeProgress:@"保存中..."];
        [YMWebServiceClient updateCorpInfoWithParams:params Success:^(YMNomalResponse *response) {
            [self.view.window hiddenProgress];
            if(response.code==ERROR_OK){
                [self.navigationController popViewControllerAnimated:YES];
                [self.view.window makeToast:@"保存成功"];
            }else{
                [self handleErrorWithErrorResponse:response];
            }
        }];
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
    if ([textField.text stringByAppendingString:string].length>20&&textField==_contactsField)
    {
        [textField resignFirstResponder];
        [self.view.window makeToast:@"请输入20字以内的联系人"];
        return NO;
    }
    else if ([textField.text stringByAppendingString:string].length>32&&textField==_corpNameField) {
        [textField resignFirstResponder];
        [self.view.window makeToast:@"请输入32字以内的商家名称"];
        return NO;
    }
    return YES;
}

#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length!=0)
    {
        if (textView==_corpIntroTextView)
        {
            _corpIntroPlaceLabel.hidden = YES;
        }
        else if (textView==_corpNotiTextView)
        {
            _corpNotiPlaceLabel.hidden = YES;
        }
    }
    else
    {
        if (textView==_corpIntroTextView)
        {
            _corpIntroPlaceLabel.hidden = NO;
        }
        else if (textView==_corpNotiTextView)
        {
            _corpNotiTextView.hidden = NO;
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length==0) {
        return YES;
    }
    else {
        if ([textView.text stringByAppendingString:text].length>200&&textView==_corpIntroTextView)
        {
            [textView resignFirstResponder];
            [self.view.window makeToast:@"请输入200字以内的公司简介"];
            return NO;
        }
    }
    return YES;
}

#pragma mark tableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 5;
    }
    else if (section==1)
    {
        return 5;
    }
    return 1;
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
