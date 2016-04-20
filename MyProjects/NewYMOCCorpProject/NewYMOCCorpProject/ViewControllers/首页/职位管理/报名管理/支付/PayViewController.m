//
//  PayViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PayViewController.h"
#import "PayViewCell.h"
#import "MyTableViewHeaderView.h"
#import "ReportStuInfoCell.h"
#import "ReportBottomSelectedView.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "EmptyViewFactory.h"
#import "ReportManagerViewController.h"
#import "PaySuccessViewController.h"

static NSInteger BottomSelectedViewTag = 1111;


@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSInteger _currentPage; //当前数据页码
    NSInteger _totalCount; //数据总数
    NSMutableArray* _dataArr; //数据数组
    NSMutableArray *_selectedArr;///<批量处理选中数组
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation PayViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    [self.view addSubview:self.tableView];
    _currentPage = 1;
    _selectedArr = [NSMutableArray array];
    [self getPayList];
}

#pragma mark 获取支付列表
-(void)getPayList {
    if (_dataArr.count==0) {
        [self.view showProgressHintWith:@"加载中"];
    }
    [YMWebClient getReportListWithParams:@{@"type":@"3",@"jobId":@(_jobId),@"regiId":@(_reportInfo.id),@"pageSize":@(DATASIZE),@"pageNum":@(_currentPage)} Success:^(YMReportListResponse *response) {
        [self.view dismissProgress];
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (response.data.list == nil) {
            [self.tableView.mj_footer resetNoMoreData];
            if (self.tableView.mj_header) {
                self.tableView.mj_header = nil;
            }
            if (self.tableView.mj_footer) {
                self.tableView.mj_footer = nil;
            }
             _dataArr = nil;
            if (response.code==ERROR_UNAUTHORIZED|response.code==ERROR_EXPIRED_TOKEN|response.code==ERROR_INVALID_TOKEN) {
                [self handleErrorWithErrorResponse:response ShowHint:NO];
            }
            else {
                
                PayViewController *__weak weakVC = self;
                [EmptyViewFactory errorNetwork:self.tableView btnBlock:^{
                    PayViewController *__block blockVC = weakVC;
                    blockVC -> _currentPage = 1;
                    [weakVC getPayList];
                }];
            }
           
            
        }
        else {
            _totalCount = response.data.count;
            [self dealWithBackList:response.data.list];
        }
        [self.tableView reloadData];

    }];
}


#pragma mark 处理返回列表数据
- (void)dealWithBackList:(NSArray*)list
{
    if (list.count == 0) {
        if (_currentPage == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            _dataArr = [NSMutableArray array];
        }
        else {
            self.tableView.mj_footer = nil;
        }
    }
    else {
        if (_currentPage == 1) {
            
            [self.tableView.mj_footer resetNoMoreData];
            
            _dataArr = [NSMutableArray arrayWithArray:list];
            
            //添加下拉刷新
            PayViewController*__weak weakVC = self;
            if (!self.tableView.mj_header) {
                
                MyRefreshHeader* header = [MyRefreshHeader headerWithRefreshingBlock:^{
                    PayViewController *blockVC = weakVC;
                    blockVC->_currentPage = 1;
                    [blockVC getPayList];
                }];
                self.tableView.mj_header = header;
            }
            //添加上拉加载
            if (_totalCount >= _dataArr.count) {
                if (!self.tableView.mj_footer) {
                    self.tableView.mj_insetB = 0.0;
                    
                    MyRefreshFooter* footer = [MyRefreshFooter footerWithRefreshingBlock:^{
                        PayViewController *blockVC = weakVC;
                        blockVC->_currentPage++;
                        [blockVC getPayList];
                    }];
                    footer.noMoreDataStr = @"已没有更多支付数据";
                    self.tableView.mj_footer = footer;
                }
                if (_totalCount == _dataArr.count) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else {
            [_dataArr addObjectsFromArray:list];
            if (_totalCount <= _dataArr.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_dataArr.count==0) {
        return 0;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else {
        return _dataArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 70.0;
    }
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 10.0;
    }
    return 0.0;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0.0;
    }
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifier = @"headerView";
    MyTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[MyTableViewHeaderView alloc]initAddLineViewWithReuseIdentifier:identifier];
    }
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    headerView.titleLabel.text = @"工作日期";
    return headerView;
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
    else {
        static NSString *identifier = @"PayViewCell";
        PayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PayViewCell" owner:nil options:nil]lastObject];
            [cell.selectedBtn addTarget:self action:@selector(selectedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.payCountField.delegate = self;
        }
        YMReportInfo *info = _dataArr[indexPath.row];
        cell.infoLabel.text = [ProjectUtil changeToChineseDateStrWithSp:info.date];
        NSMutableAttributedString *checkAttStr = [[NSMutableAttributedString alloc]initWithString:[ProjectUtil getSignTypeStringWithSignType:info.signType] attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:DefaultGrayTextColor}];
        if (info.signType==2) {
            NSTextAttachment *attach = [[NSTextAttachment alloc]init];
            attach.image = [UIImage imageNamed:@"zwgl_qd"];
            NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attach];
            [checkAttStr appendAttributedString:attStr];
        }
        cell.checkBtn.tag = indexPath.row;
        [cell.checkBtn setAttributedTitle:checkAttStr forState:UIControlStateNormal];
        if (info.pay==0.0) {
            cell.payCountField.text = @"";
        }
        else {
            cell.payCountField.text = [NSString stringWithFormat:@"%g",info.pay];
        }
        cell.payCountField.tag = indexPath.row;
        cell.selectedBtn.tag = indexPath.row;
        if ([_selectedArr containsObject:info]) {
            cell.selectedBtn.selected = YES;
        }
        else {
            cell.selectedBtn.selected = NO;
        }

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        PayViewCell *cell = (PayViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self dealMultiChooseWithSelectedBtn:cell.selectedBtn Info:_dataArr[indexPath.row]];
    }
}

#pragma mark 查看签到按钮动作
-(void)checkBtnAction:(UIButton *)sender {
    YMReportInfo *info = _dataArr[sender.tag];
    if (info.signAddress.length!=0) {
        [ProjectUtil showAlert:@"签到地址" message:info.signAddress];
    }
}

#pragma mark 选中按钮动作
-(void)selectedBtnAction:(UIButton *)sender {
    YMReportInfo *info = _dataArr[sender.tag];
    [self dealMultiChooseWithSelectedBtn:sender Info:info];
}

#pragma mark 处理批量多选动作
-(void)dealMultiChooseWithSelectedBtn:(UIButton *)selectedBtn Info:(YMReportInfo *)info {
    selectedBtn.selected = !selectedBtn.selected;
    if (selectedBtn.selected) {
        [_selectedArr addObject:info];
    }
    else {
        [_selectedArr removeObject:info];
    }
    ReportBottomSelectedView *selectedView = (ReportBottomSelectedView *)[self.view viewWithTag:BottomSelectedViewTag];
     if (_selectedArr.count!=0) {
         if (!selectedView) {
             selectedView = [[ReportBottomSelectedView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64.0, SCREEN_WIDTH, 49.0)];
             [selectedView.selectedAllBtn addTarget:self action:@selector(selectedAllBtnAction:) forControlEvents:UIControlEventTouchUpInside];
             [selectedView.doBtn addTarget:self action:@selector(bottomDoBtnAction) forControlEvents:UIControlEventTouchUpInside];
             selectedView.tag = BottomSelectedViewTag;
             [self.view addSubview:selectedView];
             self.tableView.height = SCREEN_HEIGHT-64.0-49.0;
             [UIView animateWithDuration:0.3 animations:^{
                 selectedView.top = SCREEN_HEIGHT-64.0-49.0;
             }];
         }
         
         double totalPay = 0.0;
         for (YMReportInfo *info in _selectedArr) {
             totalPay += info.pay;
         }
         [selectedView.doBtn setTitle:[NSString stringWithFormat:@"支付（%g元）",totalPay] forState:UIControlStateNormal];
         if (_selectedArr.count!=_dataArr.count) {
             selectedView.selectedAllBtn.selected = NO;
         }
         else {
             selectedView.selectedAllBtn.selected = YES;
         }
     }
     else {
         [self removeBottomSelectedView];
     }
}

#pragma mark 全选按钮动作
-(void)selectedAllBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _selectedArr = [NSMutableArray arrayWithArray:_dataArr];
    }
    else {
        _selectedArr = [NSMutableArray array];
        [self removeBottomSelectedView];
    }
    [self.tableView reloadData];
}

#pragma mark 底部操作按钮动作
-(void)bottomDoBtnAction {
    double totalPay = 0.0;
    NSMutableArray *paramsArr = [NSMutableArray array];
    for (YMReportInfo *info in _selectedArr) {
        if (info.pay<=0.0) {
            [self.view showFailHintWith:@"请输入支付金额"];
            return;
        }
        totalPay += info.pay;
        [paramsArr addObject:@{@"id":@(info.id),@"pay":@(info.pay),@"regiId":@(info.regiId),@"serialNum":info.serialNum,@"stuId":@(info.stuId),@"stuPhone":info.stuPhone,@"date":@(info.date)}];
    }
        [self.view showProgressHintWith:@"支付中"];
        [YMWebClient payWithParams:@{@"payData":paramsArr.mj_JSONString,@"payType":@(_payType)} Success:^(YMNomalResponse *response) {
            [self.view dismissProgress];
            if (response.code==ERROR_OK) {
                [self.view.window showSuccessHintWith:@"支付成功"];
                NSArray *vcsArr = self.navigationController.viewControllers;
                ReportManagerViewController *jobVC = vcsArr[vcsArr.count-2];
                [jobVC getReportListWithIsUpdate:YES];
                [self.navigationController popViewControllerAnimated:NO];
                PaySuccessViewController *nextVC = [[PaySuccessViewController alloc] init];
                nextVC.title = @"支付成功";
                nextVC.totalMoney = totalPay;
                nextVC.totalPerson = _selectedArr.count;
                [jobVC.navigationController pushViewController:nextVC animated:YES];
            }
            else {
                [self handleErrorWithErrorResponse:response ShowHint:YES];
            }
        }];
    
}




#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *totalStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (totalStr.length!=0&&(![totalStr isType:SpecialStringTypePayCount])) {
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    YMReportInfo *info = _dataArr[textField.tag];
    info.pay = [textField.text doubleValue];
    if (info.pay!=0.0) {
        textField.text = [NSString stringWithFormat:@"%g",info.pay];
    }
    if ([_selectedArr containsObject:info]) {
        double totalPay = 0.0;
        for (YMReportInfo *info in _selectedArr) {
            totalPay += info.pay;
        }
        ReportBottomSelectedView *selectedView = (ReportBottomSelectedView *)[self.view viewWithTag:BottomSelectedViewTag];
        [selectedView.doBtn setTitle:[NSString stringWithFormat:@"支付（%g元）",totalPay] forState:UIControlStateNormal];
    }
    return YES;
}

#pragma mark 移除底部选中View
-(void)removeBottomSelectedView {
    ReportBottomSelectedView *selectedView = (ReportBottomSelectedView *)[self.view viewWithTag:BottomSelectedViewTag];
    [UIView animateWithDuration:0.3 animations:^{
        selectedView.top = SCREEN_HEIGHT-64.0;
    } completion:^(BOOL finished) {
        self.tableView.height = SCREEN_HEIGHT-64.0;
        [selectedView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
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
