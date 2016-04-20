//
//  CorpInfoViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/7.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "CorpInfoViewController.h"
#import "LocalDicDataBaseManager.h"
#import "CityDataBaseManager.h"
#import <IQTextView.h>
#import "DicTypeSelectedView.h"
#import "ChooseCityViewController.h"
#import <MJExtension.h>
#import "HomeViewController.h"

@interface CorpInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    YMCorpInfo *_corpInfo;
}

@property (weak, nonatomic) IBOutlet UITextField *corpNameField;//商家名称
@property (weak, nonatomic) IBOutlet UIButton *corpPropertyBtn;//商家属性
@property (weak, nonatomic) IBOutlet UIButton *corpIndustryBtn;//商家行业
@property (weak, nonatomic) IBOutlet UIButton *corpSizeBtn;//商家规模
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;//城市
@property (weak, nonatomic) IBOutlet UITextField *contactField;//联系人
@property (weak, nonatomic) IBOutlet UITextField *phoneField;//联系电话
@property (weak, nonatomic) IBOutlet IQTextView *addressTextView;//地址textView
@property (weak, nonatomic) IBOutlet IQTextView *corpIntroTextView;//公司简介


@end

@implementation CorpInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];

}


-(void)layoutSubViews {
    if ([self.title hasPrefix:@"完善"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜你注册成功，请花一分钟时间完善一下基本信息，就可以发布职位啦！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }
    //请求商家信息
    [self getCorpInfo];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0,60, 30.0);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = FONT(15);
    [saveBtn setTitleColor:DefaultOrangeColor forState:UIControlStateNormal];
    saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    
    //获取选择的城市
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSelectedCity:) name:GetSelectedCityNotification object:nil];
}

#pragma mark 请求商家信息
-(void)getCorpInfo {
     [self.view showProgressHintWith:@"加载中"];
    CorpInfoViewController *__weak weakVC = self;
    [YMWebClient getCorpInfoSuccess:^(YMCorpInfoResponse *response) {
        [self.view dismissProgress];
        _corpInfo = response.data;
        //设置默认值
        if (_corpInfo.propertyId==0) {
            _corpInfo.propertyId=2;
        }
        if (_corpInfo.ctypeId==0) {
            _corpInfo.ctypeId=1;
        }
        if (_corpInfo.sizeId==0) {
            _corpInfo.sizeId=2;
        }
        if (_corpInfo.tel.length==0) {
            _corpInfo.tel = [ProjectUtil getLoginPhone];
        }
        if (_corpInfo.areaId==0&&_corpInfo.cityId!=0) {
            NSDictionary *dic = [[CityDataBaseManager getCountyWithParentId:_corpInfo.cityId] firstObject];
            _corpInfo.areaId = [dic[@"id"] integerValue];
        }
        
        [weakVC updateCorpInfo];
    }];
    
}

#pragma mark 更新商家信息
-(void)updateCorpInfo {
    //将信息赋值给对应的控件
    _corpNameField.text = _corpInfo.name;
    [self setChooseBtnTitleWithBtn:_corpPropertyBtn Title:[LocalDicDataBaseManager getNameWithType:LocalDicTypeCorpProperty VersionId:_corpInfo.propertyId]];
    [self setChooseBtnTitleWithBtn:_corpIndustryBtn Title:[LocalDicDataBaseManager getNameWithType:LocalDicTypeCorpIndustry VersionId:_corpInfo.industryId]];
    [self setChooseBtnTitleWithBtn:_corpSizeBtn Title:[LocalDicDataBaseManager getNameWithType:LocalDicTypeCorpSize VersionId:_corpInfo.sizeId]];
    _contactField.text = _corpInfo.contact;
    _phoneField.text = _corpInfo.tel;
    if (_corpInfo.cityId!=0) {
         [self setChooseBtnTitleWithBtn:_cityBtn Title:[NSString stringWithFormat:@"%@ %@",[CityDataBaseManager getCityNameWithType:CityTypeCity CityId:_corpInfo.cityId],[CityDataBaseManager getCityNameWithType:CityTypeCounty CityId:_corpInfo.areaId]]];
    }
    _addressTextView.text = _corpInfo.address;
    _corpIntroTextView.text = _corpInfo.intro;
    [self.tableView reloadData];
 }


#pragma mark 获取选择的城市
-(void)getSelectedCity:(NSNotification *)noti {
   
    NSDictionary *dic = noti.object;
    _corpInfo.cityId = [dic[@"cityId"] integerValue];
    _corpInfo.areaId = [dic[@"areaId"] integerValue];
  [self setChooseBtnTitleWithBtn:_cityBtn Title:[NSString stringWithFormat:@"%@ %@",[CityDataBaseManager getCityNameWithType:CityTypeCity CityId:_corpInfo.cityId],[CityDataBaseManager getCityNameWithType:CityTypeCounty CityId:_corpInfo.areaId]]];
}

#pragma mark 设置选择按钮标题
-(void)setChooseBtnTitleWithBtn:(UIButton *)chooseBtn Title:(NSString *)title {
    if (title.length!=0) {
        [chooseBtn setTitle:title forState:UIControlStateNormal];
        [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

#pragma mark 保存动作
-(void)saveBtnAction {
    [self.view endEditing:YES];
    if (_corpNameField.text.length==0) {
        [self.view showFailHintWith:@"填写商家名称"];
    }
    else if (_corpNameField.text.length>20) {
        [self.view showFailHintWith:@"填写20字以内的商家名称"];
    }
    else if (_corpInfo.industryId==0) {
        [self.view showFailHintWith:@"请选择所属行业"];
    }
    else if (_contactField.text.length==0) {
        [self.view showFailHintWith:@"填写联系人"];
    }
    else if (_contactField.text.length>20) {
        [self.view showFailHintWith:@"填写20字以内的联系人"];
    }
    else if (_phoneField.text.length==0) {
        [self.view showFailHintWith:@"填写联系电话"];
    }
    else if (_corpInfo.cityId==0) {
        [self.view showFailHintWith:@"请选择所在市区"];
    }
    else if (_addressTextView.text.length==0) {
        [self.view showFailHintWith:@"填写详细地址"];
    }
    else if (_addressTextView.text.length>100) {
        [self.view showFailHintWith:@"填写100字以内的详细地址"];
    }
    else if (_corpIntroTextView.text.length==0) {
        [self.view showFailHintWith:@"填写公司简介"];
    }
    else if (_corpIntroTextView.text.length>200) {
        [self.view showFailHintWith:@"填写200字以内的公司简介"];
    }
    else {
        _corpInfo.name = _corpNameField.text;
        _corpInfo.contact = _contactField.text;
        _corpInfo.tel = _phoneField.text;
        _corpInfo.address = _addressTextView.text;
        _corpInfo.intro = _corpIntroTextView.text;

        NSDictionary *params = [_corpInfo mj_keyValues];
        [self.view showProgressHintWith:@"保存中"];
        [YMWebClient updateCorpInfoWithParams:params Success:^(YMNomalResponse *response) {
            [self.view dismissProgress];
            //改变用户是否完善信息字段
            
            if (response.code==ERROR_OK) {
                YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
                loginInfo.name = _corpNameField.text;
                if ([self.title hasPrefix:@"完善"]) {
                    
                    loginInfo.isPublish = 1;
                    [ProjectUtil saveLoginInfo:loginInfo];

                    //跳转首页
                    HomeViewController *homeVC = [[HomeViewController alloc]init];
                    self.view.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homeVC];
                }
                else {
                    [ProjectUtil saveLoginInfo:loginInfo];
                    [self.view.window showSuccessHintWith:@"保存商家信息成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }

            }
            else {
                [self handleErrorWithErrorResponse:response ShowHint:YES];
            }
            
        }];
    }
    
}

#pragma mark 选择按钮动作
- (IBAction)chooseBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.tag!=106) {
        DicTypeSelectedView *typeView = [[DicTypeSelectedView alloc]init];

        switch (sender.tag) {
            case 101:
            {
                typeView.itemArr = [LocalDicDataBaseManager getCorpProperty];
                typeView.selectedDicId = _corpInfo.propertyId;
                [typeView getSelectedResult:^(NSDictionary *selectedDic) {
                    _corpInfo.propertyId = [selectedDic[@"id"] integerValue];
                    [self setChooseBtnTitleWithBtn:sender Title:selectedDic[@"name"]];
                }];
            }
                break;
            case 102:
            {
                typeView.itemArr = [LocalDicDataBaseManager getCorpIndustry];
                typeView.selectedDicId = _corpInfo.industryId;
                [typeView getSelectedResult:^(NSDictionary *selectedDic) {
                    _corpInfo.industryId = [selectedDic[@"id"] integerValue];
                    [self setChooseBtnTitleWithBtn:sender Title:selectedDic[@"name"]];
                }];
            }
                break;
            case 103:
            {
                typeView.itemArr = [LocalDicDataBaseManager getCorpSize];
                typeView.selectedDicId = _corpInfo.sizeId;
                [typeView getSelectedResult:^(NSDictionary *selectedDic) {
                    _corpInfo.sizeId = [selectedDic[@"id"] integerValue];
                    [self setChooseBtnTitleWithBtn:sender Title:selectedDic[@"name"]];
                }];
            }
                break;

                
            default:
                break;
        }
        [typeView show];
        
    }
    else {
        ChooseCityViewController *nextVC = [[ChooseCityViewController alloc]init];
        nextVC.title = @"选择市区";
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    
}

-(void)dealloc {
    
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section==3&&indexPath.row==1)|(indexPath.section==4)) {
        if (indexPath.section==3) {
            if (_corpInfo) {
                return _addressTextView.contentSize.height+10.0;
            }
            return 44.0;
           
        }
        else if (indexPath.section==4) {
            if (_corpInfo) {
               
                return _corpIntroTextView.contentSize.height+10.0;
                
            }
            return 44.0;
        }
    }
    return 44.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}


#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger totalStrLength = [textField.text stringByReplacingCharactersInRange:range withString:string].length;
    if (textField==_phoneField&&totalStrLength>15) {
        return NO;
    }
    return YES;
}



#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textView.tag inSection:textView.superview.tag]];
    cell.height = textView.contentSize.height+10.0;
    if (cell.contentView.tag==3) {
        UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
        nextCell.top = cell.bottom + 10.0;
        self.tableView.contentSize = CGSizeMake(SCREEN_WIDTH, nextCell.bottom);
    }
    else {
        self.tableView.contentSize = CGSizeMake(SCREEN_WIDTH, cell.bottom);
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:textView.tag inSection:textView.superview.tag]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:4]] withRowAnimation:UITableViewRowAnimationNone];

}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [_corpNameField becomeFirstResponder];
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
