//
//  PostJobViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/14.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostJobViewController.h"
#import "CorpChooseCell.h"
#import "CorpTextViewInputCell.h"
#import "CorpTextFieldInputCell.h"
#import "PostJobWorkDateCell.h"
#import "PostJobWorkTimeCell.h"
#import "PostJobWorkAddressCell.h"
#import "ChooseCityViewController.h"
#import "LocalDicDataBaseManager.h"
#import "CityDataBaseManager.h"
#import "DicTypeSelectedView.h"
#import "PostOtherRequireViewController.h"
#import "PostSuccessCertiViewController.h"
#import "PostSuccessUnCertiViewController.h"
#import <MJExtension.h>
#import "JobsManagerViewController.h"
#import "JobHistoryView.h"
#import "EmptyViewFactory.h"
#import "HomeViewController.h"

@interface PostJobViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,assign) BOOL isUnLimitTime;///<是否不限工作时间

@property (nonatomic,assign) PostJobStatus postJobStatus;///<当前职位状态

@property (nonatomic,strong)  YMJobInfo *jobInfo;///<当前职位信息

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,weak) UITextField *jobNameField;///<职位名称

@property (nonatomic,weak) UITextField *payField;///<薪资

@property (nonatomic,weak) UITextField *contactField;///<联系人

@property (nonatomic,weak) UITextField *telField;///<联系方式

@property (nonatomic,weak) UITextField *addressField;///<详细地址

@property (nonatomic,weak) UITextView *workContentTextView;///<工作内容


@end

@implementation PostJobViewController

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeNomal];
        _tableView.height = SCREEN_HEIGHT-64.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    
    
     [self.view addSubview:self.tableView];
    
    if (_jobId==0) {
        _jobInfo = [[YMJobInfo alloc]init];
        _jobInfo.payUnit = 1;
        
        YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
        _jobInfo.contact = loginInfo.contact;
        _jobInfo.tel = loginInfo.phone;
        _jobInfo.cityId = loginInfo.cityId;
        _jobInfo.areaId = loginInfo.areaId;
        _postJobStatus = PostJobStatusPost;
        //历史职位入口
        [self addHistoryJob];
        //提交
        [self addPost];
    }
    else {
        //请求职位详情
        [self getJobDetail];
    }
    
    //获取选择的城市
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSelectedCity:) name:GetSelectedCityNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark 文本输入框变化通知方法
-(void)textFieldDidChange:(NSNotification *)noti {
    UITextField *textField = noti.object;
    if (textField==_jobNameField) {
        _jobInfo.name = textField.text;
    }
    else if (textField.superview.tag==0&&textField.tag==2) {
        _jobInfo.defaultCount = [textField.text integerValue];
        _jobInfo.count =0;
        for (YMJobDateInfo *info in _jobInfo.jobDates) {
            info.total = [textField.text integerValue];
            _jobInfo.count += info.total;
        }
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (textField==_payField) {
        _jobInfo.pay = [textField.text doubleValue];
    }
    else if (textField==_telField) {
        _jobInfo.tel = textField.text;
    }
    else if (textField==_contactField) {
        _jobInfo.contact = _contactField.text;
    }
    else if (textField==_addressField) {
        _jobInfo.street = _addressField.text;
    }
    
}

#pragma mark 增加历史职位
-(void)addHistoryJob {
    UIButton *historyJobBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyJobBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.0);
    historyJobBtn.backgroundColor = HEXCOLOR(0x30d1fe);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@" "];
    NSTextAttachment *attach = [[NSTextAttachment alloc]init];
    attach.image = [UIImage imageNamed:@"fbzw_ls"];
    attach.bounds = CGRectMake(0, -4, 19, 19);
    [attStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 选择历史职位（选择后所有信息均为历史信息）" attributes:@{NSFontAttributeName:BOLDFONT(13),NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    [historyJobBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    [historyJobBtn addTarget:self action:@selector(historyJobBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = historyJobBtn;
}

#pragma mark 增加提交按钮
-(void)addPost {
    //增加提交按钮
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame = CGRectMake(0, 0,60, 30.0);
    [postBtn setTitle:@"提交" forState:UIControlStateNormal];
    postBtn.titleLabel.font = FONT(15);
    [postBtn setTitleColor:DefaultOrangeColor forState:UIControlStateNormal];
    postBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [postBtn addTarget:self action:@selector(postBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postBtn];

}
#pragma mark 请求职位详情
-(void)getJobDetail {
    [self.view showProgressHintWith:@"加载中"];
    [YMWebClient getJobDetailInfoWithParams:@{@"id":@(_jobId)} Success:^(YMJobDetailResponse *response) {
        [self.view dismissProgress];
        if (response.data) {
            _jobInfo = response.data;
            if (_jobInfo.areaId==0) {
                _jobInfo.street = @"就近安排";
            }
            if (_jobInfo.workTime.length==0) {
                _isUnLimitTime = YES;
            }
            if (_jobInfo.isCheck==1|_jobInfo.isCheck==3) {
                _postJobStatus = PostJobStatusEdit;
               
                //提交
                [self addPost];
                //过滤过期日期
                [self filterLastDate];

            }
            else {
                _postJobStatus = PostJobStatusDetail;
            }
            
            
        }
        else {
            _postJobStatus = PostJobStatusDetail;
            _jobInfo = nil;
            PostJobViewController *__weak weakVC = self;
            [EmptyViewFactory errorNetwork:self.tableView btnBlock:^{
                [weakVC getJobDetail];
            }];
        }
        [self.tableView reloadData];
        
    }];
}

#pragma mark 获取历史职位详情
-(void)getHistoryJobDetail {
    [self.view showProgressHintWith:@"加载中"];
    [YMWebClient getJobDetailInfoWithParams:@{@"id":@(_jobId)} Success:^(YMJobDetailResponse *response) {
        [self.view dismissProgress];
        if (response.data) {
            _jobInfo = response.data;
            if (_jobInfo.areaId==0) {
                _jobInfo.street = @"就近安排";
            }
            if (_jobInfo.workTime.length==0) {
                _isUnLimitTime = YES;
            }
             _jobInfo.jobDates = @[];
            _jobInfo.count = 0;
            
            [_tableView reloadData];
        }
        else {
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
    }];


}

#pragma mark 过滤过期日期
-(void)filterLastDate {

    
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_jobInfo.jobDates];
    
    for (YMJobDateInfo *info in _jobInfo.jobDates) {
        NSDate *date = [ProjectUtil getDateWithTimeSp:info.workDate];
        NSCalendar *calender = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
        dateComponents.hour=0;
        dateComponents.minute=0;
        dateComponents.second=0;
        NSComparisonResult result = [date compare:[calender dateFromComponents:dateComponents]];
        if (result==NSOrderedAscending) {
            [tempArr removeObject:info];
        }
        else {
            _jobInfo.jobDates = [NSArray arrayWithArray:tempArr];
            return;
        }
    }
   
    
}



#pragma mark 获取选择的城市
-(void)getSelectedCity:(NSNotification *)noti {
    
    NSDictionary *dic = noti.object;
    _jobInfo.cityId = [dic[@"cityId"] integerValue];
    _jobInfo.areaId = [dic[@"areaId"] integerValue];
    if (_jobInfo.areaId==0) {
        _jobInfo.street = @"就近安排";
    }
    else {
        _jobInfo.street = @"";
    }
    [self.tableView reloadData];
}
#pragma mark 发布职位
-(void)postBtnAction {
   [self.view endEditing:YES];
    if (_jobInfo.name.length==0) {
        [self.view showFailHintWith:@"填写职位名称"];
    }
    else if (_jobInfo.name.length>12) {
        [self.view showFailHintWith:@"填写12字以内的职位名称"];
    }
    else if (_jobInfo.jobtypeId==0) {
        [self.view showFailHintWith:@"选择职位类型"];
    }
    else if (_jobInfo.jobDates.count==0) {
        [self.view showFailHintWith:@"选择工作日期"];
    }
    else if (_jobInfo.workTime.length==0&&_isUnLimitTime==NO) {
        [self.view showFailHintWith:@"选择工作时间"];
    }
    else if (_jobInfo.count==0) {
        [self.view showFailHintWith:@"填写招聘人数"];
    }
    else if (_jobInfo.pay<=0.0) {
        [self.view showFailHintWith:@"填写薪资待遇"];
    }
    else if (_jobInfo.jobsettletypeId==0) {
        [self.view showFailHintWith:@"选择结算方式"];
    }
    else if (_jobInfo.tel.length==0) {
        [self.view showFailHintWith:@"填写联系方式"];
    }
    else if (_jobInfo.contact.length==0) {
        [self.view showFailHintWith:@"填写联系人"];
    }
    else if (_jobInfo.contact.length>20) {
        [self.view showFailHintWith:@"填写12字以内的联系人"];
    }
    else if (_jobInfo.cityId==0) {
        [self.view showFailHintWith:@"选择市区"];
    }
    else if (_jobInfo.street.length==0) {
        [self.view showFailHintWith:@"填写详细地址"];
    }
    else if (_jobInfo.street.length>100) {
        [self.view showFailHintWith:@"填写100字以内的详细地址"];
    }
    else if (_jobInfo.workContent.length==0) {
        [self.view showFailHintWith:@"填写工作内容"];
    }
    else if (_jobInfo.workContent.length>200) {
        [self.view showFailHintWith:@"填写200字以内的工作内容"];
    }
    else {
        [self.view showProgressHintWith:@"提交中"];
        if (_jobInfo.areaId==0) {
            _jobInfo.street = @"";
        }
        _jobInfo.address = [NSString stringWithFormat:@"%@%@%@",[CityDataBaseManager getCityNameWithType:CityTypeCity CityId:_jobInfo.cityId],[CityDataBaseManager getCityNameWithType:CityTypeCounty CityId:_jobInfo.areaId],_jobInfo.street];
        
        if (_postJobStatus==PostJobStatusPost) {
            [YMWebClient postJobWithParams:@{@"data":_jobInfo.mj_JSONString} Success:^(YMNomalResponse *response) {
                [self.view dismissProgress];
                if (response.code==ERROR_OK) {
                    
                    NSArray *vcsArr = self.navigationController.viewControllers;
                    HomeViewController *homeVC = vcsArr[vcsArr.count-2];
                    
                    [self.navigationController popViewControllerAnimated:NO];

                    YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
                    if (loginInfo.checkStatus!=2&&loginInfo.checkStatus!=4) {
                        PostSuccessUnCertiViewController *nextVC = [[PostSuccessUnCertiViewController alloc]init];
                        nextVC.title = @"发布成功";
                        [homeVC.navigationController pushViewController:nextVC animated:YES];
                        
                    }
                    else {
                        PostSuccessCertiViewController *nextVC = [[PostSuccessCertiViewController alloc]init];
                        nextVC.title = @"发布成功";
                        [homeVC.navigationController pushViewController:nextVC animated:YES];
                    }
                }
                else {
                    if (_jobInfo.areaId==0) {
                        _jobInfo.street = @"就近安排";
                    }
                    [self handleErrorWithErrorResponse:response ShowHint:YES];
                }
            }];
        }
        else if (_postJobStatus==PostJobStatusEdit) {
            [YMWebClient updateJobWithParams:@{@"data":_jobInfo.mj_JSONString} Success:^(YMNomalResponse *response) {
                 [self.view dismissProgress];
                if (response.code==ERROR_OK) {
                    [self.view.window showSuccessHintWith:@"修改职位信息成功"];
                    NSArray *vcsArr = self.navigationController.viewControllers;
                    JobsManagerViewController *jobVC = vcsArr[vcsArr.count-2];
                    [jobVC getJobListWithIsUpdate:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    if (_jobInfo.areaId==0) {
                        _jobInfo.street = @"就近安排";
                    }
                    [self handleErrorWithErrorResponse:response ShowHint:YES];
                }
            }];
        }
        
        
    }
}

#pragma mark 选择历史职位
-(void)historyJobBtnAction {
    [self.view showProgressHintWith:@"加载中"];
    [YMWebClient getHistoryJobSuccess:^(YMHistoryJobResponse *response) {
        [self.view dismissProgress];
        NSInteger count = response.data.count;
        if (count!=0) {
            JobHistoryView *historyView = [[JobHistoryView alloc]init];
            historyView.itemArr = response.data;
            PostJobViewController *__weak weakVC = self;
            [historyView chooseJob:^(NSInteger jobId) {
                weakVC.jobId = jobId;
                [weakVC getHistoryJobDetail];
            }];
            [historyView show];
        }
        else {
            if (response.code==ERROR_OK) {
                response.codeInfo = @"您还没有发布过职位";
            }
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_jobInfo) {
      return 5;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_postJobStatus==PostJobStatusDetail&&section==0) {
        return 2;
    }
    else if (_postJobStatus==PostJobStatusDetail&&section==1&&_jobInfo.jobDates.count==0) {
        return 0;
    }
    else if (section==0|section==3) {
        
        return 3;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            return [PostJobWorkDateCell getCellHeightWithDataCount:_jobInfo.jobDates.count PostJobStatus:_postJobStatus];
        }
        else if (indexPath.row==1) {
            if (_jobInfo.workTime.length!=0) {
                return [PostJobWorkTimeCell getCellHeightWithDataCount:[_jobInfo.workTime componentsSeparatedByString:@"|"].count PostJobStatus:_postJobStatus];
            }
            return [PostJobWorkTimeCell getCellHeightWithDataCount:0 PostJobStatus:_postJobStatus];
        }
    }
    
    else if (indexPath.section==3&&indexPath.row==2) {
        return 88.0;
    }
    else if (indexPath.section==4&&indexPath.row==1) {
        if (_jobInfo.workContent.length!=0) {
            CGFloat addHeight = [_jobInfo.workContent getSizeWithFont:FONT(14) Width:SCREEN_WIDTH-95.0].height;
            return addHeight+27.0;
        }
        return 44.0;
    }
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0.0;
    }
    else if (_postJobStatus==PostJobStatusDetail&&section==1&&_jobInfo.jobDates.count==0) {
        return 0.0;
    }
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section==0&&indexPath.row==1)|(indexPath.section==2&&indexPath.row==1)|(indexPath.section==4&&indexPath.row==0)) {
        
        static NSString *identifier = @"CorpChooseCell";
        CorpChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CorpChooseCell" owner:nil options:nil]lastObject];
            [cell.chooseBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.contentView.tag = indexPath.section;
        cell.chooseBtn.tag = indexPath.row;
        if (indexPath.section==0) {
            cell.titleLabel.text = @"职位类型";
            if (_jobInfo.jobtypeId==0) {
                [cell.chooseBtn setTitle:@"选择职位类型" forState:UIControlStateNormal];
                [cell.chooseBtn setTitleColor:DefaultPlaceholderColor forState:UIControlStateNormal];
            }
            else {
                [self changeChooseTitleWithButton:cell.chooseBtn Title:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobType VersionId:_jobInfo.jobtypeId]];
            }
           
        }
        else if (indexPath.section==2) {
            cell.titleLabel.text = @"结算方式";
            if (_jobInfo.jobsettletypeId==0) {
                 [cell.chooseBtn setTitle:@"选择结算方式" forState:UIControlStateNormal];
                 [cell.chooseBtn setTitleColor:DefaultPlaceholderColor forState:UIControlStateNormal];
            }
            else {
                
                [self changeChooseTitleWithButton:cell.chooseBtn Title:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobSettleType VersionId:_jobInfo.jobsettletypeId]];
            }
        }
        else if (indexPath.section==4) {
            cell.titleLabel.text = @"其它要求";
            [self changeChooseTitleWithButton:cell.chooseBtn Title:[self getConditionStr]];
        }
        return cell;
    }
    else if (indexPath.section==1&&indexPath.row==0) {
            static NSString *identifier = @"PostJobWorkDateCell";
            PostJobWorkDateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell==nil) {
                cell = [[PostJobWorkDateCell alloc]initWithJobStatus:_postJobStatus reuseIdentifier:identifier];
                PostJobViewController *__weak weakVC = self;
                PostJobWorkDateCell *__weak weakCell = cell;
                [cell postJobWorkDateChanged:^{
                    weakVC.jobInfo.jobDates = [NSArray arrayWithArray:weakCell.jobDates];
                    weakVC.jobInfo.count = weakCell.total;
                    [weakVC.tableView reloadData];
                }];
            }
            cell.total = _jobInfo.count;
            cell.defaultCount = _jobInfo.defaultCount;
            cell.jobDates = [NSMutableArray arrayWithArray:_jobInfo.jobDates];
        return cell;
    }
    else if (indexPath.section==1&&indexPath.row==1) {
        static NSString *identifier = @"PostJobWorkTimeCell";
        PostJobWorkTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[PostJobWorkTimeCell alloc]initWithJobStatus:_postJobStatus reuseIdentifier:identifier];
            PostJobViewController *__weak weakVC = self;
            PostJobWorkTimeCell *__weak weakCell = cell;
            [cell postWorkTimeChanged:^{
                weakVC.jobInfo.workTime = [weakCell.workTimes componentsJoinedByString:@"|"];
                weakVC.isUnLimitTime = weakCell.unLimitBtn.selected;
                [weakVC.tableView reloadData];
            }];
        }
        if (_jobInfo.workTime.length==0) {
            if (_postJobStatus!=PostJobStatusPost) {
                cell.unLimitBtn.selected = _isUnLimitTime;
            }
            cell.workTimes = [NSMutableArray array];
        }
        else {
            cell.workTimes = [NSMutableArray arrayWithArray:[_jobInfo.workTime componentsSeparatedByString:@"|"]];
        }
        return cell;
    }
    else if (indexPath.section==3&&indexPath.row==2) {
        static NSString *identifier = @"PostJobWorkAddressCell";
        PostJobWorkAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PostJobWorkAddressCell" owner:nil options:nil]lastObject];
            if (_postJobStatus!=PostJobStatusDetail) {
                 [cell.chooseCityBtn addTarget:self action:@selector(chooseCityBtnAction) forControlEvents:UIControlEventTouchUpInside];
                 cell.addressField.delegate = self;
            }
            else {
                cell.addressField.enabled = NO;
            }
            
           
        }
        if (_jobInfo.cityId!=0) {
            [self changeChooseTitleWithButton:cell.chooseCityBtn Title:[NSString stringWithFormat:@"%@ %@",[CityDataBaseManager getCityNameWithType:CityTypeCity CityId:_jobInfo.cityId],[CityDataBaseManager getCityNameWithType:CityTypeCounty CityId:_jobInfo.areaId]]];
        }
        else {
            [cell.chooseCityBtn setTitle:@"选择市区" forState:UIControlStateNormal];
            [cell.chooseCityBtn setTitleColor:DefaultPlaceholderColor forState:UIControlStateNormal];
            
        }
        cell.contentView.tag = indexPath.section;
        cell.addressField.tag = indexPath.row;
        cell.addressField.text = _jobInfo.street;
        if (_jobInfo.areaId==0) {
            cell.addressField.enabled = NO;
        }
        else {
            cell.addressField.enabled = YES;
        }
        _addressField = cell.addressField;
        
        return cell;
    }
    else if (indexPath.section==4&&indexPath.row==1) {
        static NSString *identifier = @"CorpTextViewInputCell";
        CorpTextViewInputCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CorpTextViewInputCell" owner:nil options:nil]lastObject];
            if (_postJobStatus!=PostJobStatusDetail) {
                cell.inputTextView.delegate =self;
            }
            else {
                cell.inputTextView.editable = NO;
                cell.inputTextView.scrollEnabled = NO;
            }
        }
        cell.contentView.tag = indexPath.section;
        cell.inputTextView.tag = indexPath.row;
        cell.titleLabel.text = @"工作内容";
        cell.inputTextView.placeholder = @"填写工作详细内容（200字以内）";
        cell.inputTextView.text = _jobInfo.workContent;
        _workContentTextView = cell.inputTextView;
        
        return cell;
    }
    
    else {
        if (indexPath.section==0&&indexPath.row==2) {
            CorpTextFieldInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CorpTextFieldInputCellTypeUnitIdentifier];
            if (cell==nil) {
                cell = [[CorpTextFieldInputCell alloc]initWithType:CorpTextFieldInputCellTypeUnit];
                if (_postJobStatus!=PostJobStatusDetail) {
                    cell.inputTextField.delegate = self;
                    cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
                }
                else {
                    cell.inputTextField.enabled = NO;
    
                }
            }
            cell.contentView.tag = indexPath.section;
            cell.inputTextField.tag = indexPath.row;
            cell.titleLabel.text = @"招聘人数";
            cell.inputTextField.placeholder = @"填写招聘人数";
            cell.unitLabel.text = @"人/天";
            return cell;
        }
        else if (indexPath.section==2&&indexPath.row==0) {
            CorpTextFieldInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CorpTextFieldInputCellTypeChooseUnitIdentifier];
            if (cell==nil) {
                cell = [[CorpTextFieldInputCell alloc]initWithType:CorpTextFieldInputCellTypeChooseUnit];
                if (_postJobStatus!=PostJobStatusDetail) {
                    cell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
                    cell.inputTextField.delegate = self;
                    [cell.unitBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                else {
                    cell.inputTextField.enabled = NO;
                }
                
            }
            cell.contentView.tag = indexPath.section;
            cell.inputTextField.tag = indexPath.row;
            cell.contentView.tag = indexPath.section;
            cell.unitBtn.tag = indexPath.row;
            [self changeChooseTitleWithButton:cell.unitBtn Title:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:_jobInfo.payUnit]];
            cell.titleLabel.text = @"薪资待遇";
            cell.inputTextField.placeholder = @"填写薪资待遇";
            if (_jobInfo.pay>0) {
                cell.inputTextField.text = [NSString stringWithFormat:@"%g",_jobInfo.pay];
            }
            else {
                cell.inputTextField.text = @"";
            }
            _payField = cell.inputTextField;
            return cell;
        }
        else {
            CorpTextFieldInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CorpTextFieldInputCellTypeNomalIdentifier];
            if (cell==nil) {
                cell = [[CorpTextFieldInputCell alloc]initWithType:CorpTextFieldInputCellTypeNomal];
                if (_postJobStatus!=PostJobStatusDetail) {
                    cell.inputTextField.delegate = self;
                }
                else {
                    cell.inputTextField.enabled = NO;
                }
            }
            cell.contentView.tag = indexPath.section;
            cell.inputTextField.tag = indexPath.row;
            if (indexPath.section==0) {
                cell.titleLabel.text =@"职位名称";
                cell.inputTextField.text = _jobInfo.name;
                cell.inputTextField.placeholder = @"填写职位名称（12字以内）";
                cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
                _jobNameField = cell.inputTextField;
            }
            else if (indexPath.section==3) {
                if (indexPath.row==0) {
                    cell.titleLabel.text =@"联系方式";
                    cell.inputTextField.text = _jobInfo.tel;
                    cell.inputTextField.placeholder = @"填写联系方式";
                    cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
                    _telField = cell.inputTextField;
                }
                else if (indexPath.row==1) {
                    cell.titleLabel.text =@"联 系 人";
                    cell.inputTextField.text = _jobInfo.contact;
                    cell.inputTextField.placeholder = @"填写联系人";
                    cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
                    _contactField = cell.inputTextField;
                }
            }
            return cell;
        }
       
    }

    return [[UITableViewCell alloc]init];
}

#pragma mark 获取要求字符串 
-(NSString *)getConditionStr {
     NSString *str = @"";
    if (_jobInfo.minAge==0&&_jobInfo.maxAge==0&&_jobInfo.sex==0&&_jobInfo.grade==0&&_jobInfo.height==0) {
        return @"不限";
    }
    if (_jobInfo.minAge!=0|_jobInfo.maxAge!=0) {
         str = [str stringByAppendingFormat:@"年龄%ld-%ld/",(long)_jobInfo.minAge,(long)_jobInfo.maxAge];
    }
    
    
    if (_jobInfo.sex!=0) {
         str = [str stringByAppendingFormat:@"性别%@/",_jobInfo.sex==1?@"男":@"女"];
    }
    if (_jobInfo.grade!=0) {
        str = [str stringByAppendingFormat:@"学历%@/",[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobStudentGrade VersionId:_jobInfo.grade]];
    }
    if (_jobInfo.height!=0) {
         str = [str stringByAppendingFormat:@"身高%ldcm+/",(long)_jobInfo.height];
    }
    if (str.length!=0) {
        return [str substringToIndex:str.length-1];
    }
    return str;
}

#pragma mark 选择按钮动作
-(void)chooseBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    NSInteger section = sender.superview.tag;
    NSInteger row = sender.tag;
    if (_postJobStatus!=PostJobStatusDetail) {
        if (section==0&&row==1) {
            DicTypeSelectedView *selectedView = [[DicTypeSelectedView alloc]init];
            selectedView.itemArr = [LocalDicDataBaseManager getJobType];
            selectedView.selectedDicId = _jobInfo.jobtypeId;
            [selectedView getSelectedResult:^(NSDictionary *selectedDic) {
                _jobInfo.jobtypeId= [selectedDic[@"id"] integerValue];
                [self changeChooseTitleWithButton:sender Title:selectedDic[@"name"]];
            }];
            [selectedView show];
        }
        else if (section==2&&row==1) {
            DicTypeSelectedView *selectedView = [[DicTypeSelectedView alloc]init];
            selectedView.itemArr = [LocalDicDataBaseManager getJobSettleType];
            selectedView.selectedDicId = _jobInfo.jobsettletypeId;
            
            [selectedView getSelectedResult:^(NSDictionary *selectedDic) {
                _jobInfo.jobsettletypeId= [selectedDic[@"id"] integerValue];
                [self changeChooseTitleWithButton:sender Title:selectedDic[@"name"]];
            }];
            [selectedView show];
        }
        else if (section==2&&row==0) {
            DicTypeSelectedView *selectedView = [[DicTypeSelectedView alloc]init];
            selectedView.itemArr = [LocalDicDataBaseManager getJobPayUnit];
            selectedView.selectedDicId = _jobInfo.payUnit;
            [selectedView getSelectedResult:^(NSDictionary *selectedDic) {
                _jobInfo.payUnit= [selectedDic[@"id"] integerValue];
                [self changeChooseTitleWithButton:sender Title:selectedDic[@"name"]];
            }];
            [selectedView show];
        }
        else if (section==4&&row==0) {
            [self jumpToAgeChoose];
        }
    }
    else {
         if (section==4&&row==0) {
             [self jumpToAgeChoose];
         }
    }
    
}

#pragma mark 跳转年龄选择
-(void)jumpToAgeChoose {
    PostOtherRequireViewController *nextVC = [[PostOtherRequireViewController alloc]init];
    nextVC.jobStatus = _postJobStatus;
    nextVC.minAge = _jobInfo.minAge;
    nextVC.maxAge = _jobInfo.maxAge;
    nextVC.sex = _jobInfo.sex;
    nextVC.grade = _jobInfo.grade;
    nextVC.height = _jobInfo.height;
    
    PostJobViewController *__weak weakVC = self;
    PostOtherRequireViewController *__weak weakRequireVC = nextVC;
    
    [nextVC postOtherRequireSavaAction:^{
        PostJobViewController *__block blockVC = weakVC;
        blockVC->_jobInfo.minAge = weakRequireVC.minAge;
        blockVC->_jobInfo.maxAge = weakRequireVC.maxAge;
        blockVC->_jobInfo.sex = weakRequireVC.sex;
        blockVC->_jobInfo.grade = weakRequireVC.grade;
        blockVC->_jobInfo.height = weakRequireVC.height;
        [blockVC.tableView reloadData];
    }];
    nextVC.title = @"其它要求";
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark 改变选择按钮标题
-(void)changeChooseTitleWithButton:(UIButton *)button Title:(NSString *)title {
    if (title.length!=0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

#pragma mark 选择城市按钮动作 
-(void)chooseCityBtnAction {
    [self.view endEditing:YES];
    ChooseCityViewController *nextVC = [[ChooseCityViewController alloc]init];
    nextVC.title = @"选择市区";
    nextVC.isNearby = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
}


#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    
    NSString *fieldFinalText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
     NSInteger totalStrLength = fieldFinalText.length;
    if (textField.superview.tag==0&&textField.tag==2) {
        if (totalStrLength>4) {
            return NO;
        }
    }
    else if (textField==_payField&&fieldFinalText.length!=0) {
        if (![fieldFinalText isType:SpecialStringTypePayCount]) {
            return NO;
        }
    }
    else if (textField==_telField) {
        if (totalStrLength>11) {
            return NO;
        }
    }
    return YES;
}

#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    _jobInfo.workContent = textView.text;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textView.tag inSection:textView.superview.tag]];
    cell.height = textView.contentSize.height+10.0;
    self.tableView.contentSize = CGSizeMake(SCREEN_WIDTH, cell.bottom);
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self.tableView reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GetSelectedCityNotification object:nil];
    [ProjectUtil showLog:NSStringFromClass([self class])];
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
