//
//  EvaluateViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "EvaluateViewController.h"
#import "ReportStuInfoCell.h"
#import "MyTableViewHeaderView.h"
#import "EvaluateTypeCell.h"
#import "EvaluateEditCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "EvaluateInputView.h"
#import <IQKeyboardManager.h>
#import <MJExtension.h>
#import "ReportManagerViewController.h"

@interface EvaluateViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITextFieldDelegate>
{
    YMMyEvaluateInfo *_myEvaluateInfo;
}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) EvaluateInputView *inputView;

@end

@implementation EvaluateViewController

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeNomal];
        _tableView.height = SCREEN_HEIGHT-64.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        
    }
    return _tableView;
}

#pragma mark inputView
-(EvaluateInputView *)inputView {
    if (!_inputView) {
        _inputView = [[EvaluateInputView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64.0, SCREEN_WIDTH, 49.0)];
        _inputView.addField.delegate = self;
        [_inputView.addBtn addTarget:self action:@selector(addEvaluateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    
    [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[EvaluateViewController class]];
    [[IQKeyboardManager sharedManager]disableToolbarInViewControllerClass:[EvaluateViewController class]];
    _myEvaluateInfo = [[YMMyEvaluateInfo alloc]init];
    _myEvaluateInfo.level = EvaluateTypeGood;
    _myEvaluateInfo.stuId = _reportInfo.stuId;
    _myEvaluateInfo.jobId = _jobId;
    _myEvaluateInfo.regiId = _reportInfo.id;
    [self.view addSubview:self.tableView];
    UIView *submitView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UIButton *subButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, submitView.width - 20, 40)];
    subButton.layer.masksToBounds = YES;//允许设置
    subButton.layer.cornerRadius = 5;//设置圆角
    subButton.backgroundColor = DefaultOrangeColor;//设置button的背景颜色
    [subButton setTitle:@"提 交" forState:UIControlStateNormal];//设置按钮的文字
    [subButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置按钮的文字颜色
    [subButton addTarget:self action:@selector(subButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [submitView addSubview:subButton];//将button加到view上
    self.tableView.tableFooterView = submitView;
    
    [self.view addSubview:self.inputView];
    //添加键盘出现监听
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    //获取商家评价
    [self getAllEvaluateList];
}

#pragma mark 键盘即将出现
-(void)keyboardWillShow:(NSNotification *)noti {
    CGRect endFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat topOffset = _tableView.contentSize.height+_inputView.height-endFrame.origin.y;
        self.view.top = 64.0-topOffset;
        _inputView.top = _tableView.contentSize.height-64.0;
    }];
}

#pragma mark 键盘即将消失
-(void)keyboardWillHide:(NSNotification *)noti {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.top = 64.0;
        _inputView.top = SCREEN_HEIGHT-64.0;
    }];
}

#pragma mark 添加评论内容
-(void)addEvaluateBtnAction {
    
    if (_inputView.addField.text.length==0) {
        [self.view.window showFailHintWith:@"评论内容不能为空"];
    }
    else if (_inputView.addField.text.length>10) {
        [self.view.window showFailHintWith:@"评论内容在10字以内"];
    }
    else {
        [self.view endEditing:YES];
        for (YMEvaluateInfo *info in _myEvaluateInfo.evaluateArr) {
            if ([info.describe isEqualToString:_inputView.addField.text]) {
                [self.view showFailHintWith:@"改评论已存在"];
                return;
            }
        }
        YMEvaluateInfo *info = [[YMEvaluateInfo alloc]init];
        info.isMyEvaluate = YES;
        info.describe = _inputView.addField.text;
        _myEvaluateInfo.evaluateArr = [_myEvaluateInfo.evaluateArr arrayByAddingObject:info];
        _myEvaluateInfo.myEvaluateCount += 1;
        [self.tableView reloadData];
    }
}

#pragma mark 获取商家评价
-(void)getAllEvaluateList {
    
    [YMWebClient getAllEvaluateListWithParams:@{@"stuId":@(_reportInfo.stuId)} Success:^(YMAllEvaluateListResponse *response) {
        if (response.data.count!=0) {
            _myEvaluateInfo.evaluateArr = response.data;
        }
        else {
            _myEvaluateInfo.evaluateArr = [NSArray array];
        }
        [self.tableView reloadData];
    }];
    
}

#pragma mark 提交动作
-(void)subButtonAction {
    NSString *evaDescribe = @"";
    for (YMEvaluateInfo *info in _myEvaluateInfo.evaluateArr) {
        if (info.isAdded|info.isMyEvaluate) {
            evaDescribe = [evaDescribe stringByAppendingFormat:@"%@,",info.describe];
        }
    }
    if (evaDescribe.length==0) {
        [self.view showFailHintWith:@"请输入评价内容"];
    }
    else {
        NSArray *evaluateArr = _myEvaluateInfo.evaluateArr;
        _myEvaluateInfo.evaluateArr = nil;
        _myEvaluateInfo.describe = [evaDescribe substringToIndex:evaDescribe.length-1];
        [self.view showProgressHintWith:@"评价中"];
        [YMWebClient evaluateWithParams:@{@"data":_myEvaluateInfo.mj_JSONString} Success:^(YMNomalResponse *response) {
            [self.view dismissProgress];
            if (response.code==ERROR_OK) {
                [self.view.window showSuccessHintWith:@"评价成功"];
                NSArray *vcsArr = self.navigationController.viewControllers;
                ReportManagerViewController *jobVC = vcsArr[vcsArr.count-2];
                [jobVC getReportListWithIsUpdate:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                _myEvaluateInfo.evaluateArr = evaluateArr;
                [self handleErrorWithErrorResponse:response ShowHint:YES];
            }
        }];
    }
}

#pragma mark 获取显示标题
-(NSString *)getTitleWithSection:(NSInteger)section {
    switch (section) {
        case 1:
            return @"您的评价非常重要，有助于你再次招聘时聘到合意的人员";
            break;
        case 2:
            return @"其他商家认为他";
        default:
            return @"";
            break;
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 70.0;
    }
    else if (indexPath.section==1) {
        return 50.0;
    }
    else if (indexPath.section==2) {
        return [EvaluateEditCell getCellHeightWithMyEvaluateInfo:_myEvaluateInfo];
    }
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==1) {
        return 65.0;
    }
    else if (section==2) {
        return 35.0;
    }
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifier = @"headerView";
    MyTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[MyTableViewHeaderView alloc]initAddLineViewWithReuseIdentifier:identifier];
        headerView.titleLabel.numberOfLines = 0;
    }
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    headerView.titleLabel.text = [self getTitleWithSection:section];
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==2) {
        return 0.0;
    }
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        static NSString *identifier = @"ReportStuInfoCell";
        ReportStuInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ReportStuInfoCell" owner:nil options:nil]lastObject];
        }
        if (_reportInfo.sex==1) {
            cell.sexImageView.backgroundColor = SEX_MAN_COLOR;
            cell.sexImageView.image = [UIImage imageNamed:@"zwgl_nan"];
        }
        else if (_reportInfo.sex==2) {
            cell.sexImageView.backgroundColor = SEX_WOMEN_COLOR;
            cell.sexImageView.image = [UIImage imageNamed:@"zwgl_nv"];
        }
        NSMutableAttributedString *infoAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@    ",_reportInfo.stuName] attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:[UIColor blackColor]}];
        NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:@"zwgl_p"];
        attach.bounds = CGRectMake(0, -1, 15, 15);
        [infoAttStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        [infoAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%@",(long)_reportInfo.praise,@"%"] attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
        cell.infoLabel.attributedText = infoAttStr;
        [cell.phoneBtn setTitle:_reportInfo.stuPhone forState:UIControlStateNormal];
        return cell;
    }
    else if (indexPath.section==1) {
        static NSString *identifier = @"EvaluateTypeCell";
        EvaluateTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EvaluateTypeCell" owner:nil options:nil]lastObject];
            [cell.goodEvaluateBtn addTarget:self action:@selector(changeEvaluateTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.middleEvaluateBtn addTarget:self action:@selector(changeEvaluateTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.badEvaluateBtn addTarget:self action:@selector(changeEvaluateTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.evaluateType = _myEvaluateInfo.level;
        return cell;
    }
    else {
        static NSString *identifier= @"EvaluateEditCell";
        EvaluateEditCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EvaluateEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            EvaluateViewController *__weak weakVC = self;
            [cell evaluateEditCellAddEvaluate:^{
                weakVC.inputView.addField.text = @"";
                [weakVC.inputView.addField becomeFirstResponder];
            }];
        }
        cell.evaluateInfo = _myEvaluateInfo;
        return cell;
    }
}

#pragma mark 切换评论类型
-(void)changeEvaluateTypeBtnAction:(UIButton *)sender {
    if (sender.tag!=_myEvaluateInfo.level) {
        UIButton *lastBtn = (UIButton *)[sender.superview viewWithTag:_myEvaluateInfo.level];
        if (lastBtn) {
            lastBtn.selected = NO;
        }
        sender.selected = YES;
        _myEvaluateInfo.level = sender.tag;
    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self addEvaluateBtnAction];
    
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [ProjectUtil showLog:NSStringFromClass([self class])];
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
