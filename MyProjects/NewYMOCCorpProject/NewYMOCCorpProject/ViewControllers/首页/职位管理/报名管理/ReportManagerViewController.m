//
//  ReportManagerViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "ReportManagerViewController.h"
#import <UIImageView+WebCache.h>
#import "EmptyViewFactory.h"
#import <MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "LocalDicDataBaseManager.h"
#import "ReportListCell.h"
#import "ReportListPayCellHeaderView.h"
#import "ReportBottomSelectedView.h"

#import "StaffDetailViewController.h"
#import "EvaluateViewController.h"
#import "PayViewController.h"
#import "MyTableViewHeaderView.h"
#import "ReportManagerHeaderView.h"
#import <MJExtension.h>
#import "HasEvaluateViewController.h"


typedef enum : NSUInteger {
    ReportManagerTypeAll=100,///<全部
    ReportManagerTypeWaitSign,///<待签约
    ReportManagerTypeWaitPay,///<待支付
    ReportManagerTypeWaitEvaluate,///<待评价
} ReportManagerType;


static NSInteger BottomSelectedViewTag = 1111;

@interface ReportManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray* _dataArr; //数据数组
    NSInteger _currentPage; //当前数据页码
    NSInteger _totalCount; //数据总数
    ReportManagerType _reportType;///<当前选中的报名状态
    NSMutableArray *_selectedArr;///<批量处理选中数组
}

@property (strong, nonatomic) UIView* lineView; //按钮底部线
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ReportManagerViewController

#pragma mark lineView
-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 123, SCREEN_WIDTH/4.0, 2)];
        _lineView.backgroundColor = RGBCOLOR(255, 103, 0);
    }
    return _lineView;
}


#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeNomal];
        _tableView.top = 0;
        _tableView.height = SCREEN_HEIGHT-64.0;
        _tableView.delegate =self;
        _tableView.dataSource = self;
       
        ReportManagerHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"ReportManagerHeaderView" owner:nil options:nil]lastObject];
        headerView.width = _tableView.width;
        [headerView addSubview:self.lineView];
        
        [headerView.jobTypeImageView sd_setImageWithURL:[NSURL URLWithString:[ProjectUtil getWholeImageUrlWithResponseUrl:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobTypeLogo VersionId:_jobInfo.jobtypeId]]]];
        
        NSArray *dataArr = @[@{@"image":@"zwgl_rs",@"title":[NSString stringWithFormat:@" %ld人报名  ",(long)_jobInfo.regiNum]},
                             @{@"image":@"zwgl_sj",@"title":[NSString stringWithFormat:@" %@ ",[ProjectUtil changeToDateWithSp:_jobInfo.creatTime Format:@"MM-dd"]]},
                             ];
        headerView.jobNameLabel.text = _jobInfo.name;
        headerView.jobInfoLabel.attributedText = [self getDetailAttStrWithItemArr:dataArr];
        
        NSMutableAttributedString *payAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%g",_jobInfo.pay] attributes:@{NSFontAttributeName:FONT(18),NSForegroundColorAttributeName:DefaultOrangeColor}];
        [payAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:_jobInfo.payUnit] attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
        headerView.salaryLabel.attributedText = payAttStr;
        [headerView.allBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.waitSignBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.waitPayBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.waitEvaluateBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        _tableView.tableHeaderView = headerView;
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    
    
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.tableView];
    _reportType = ReportManagerTypeAll;
    [self topBtnAction:[self.tableView.tableHeaderView viewWithTag:_reportType]];
    
    //获取报名列表
    _currentPage = 1;
    [self getReportListWithIsUpdate:NO];
}

#pragma mark 获取详细信息富文本字符串
-(NSAttributedString *)getDetailAttStrWithItemArr:(NSArray *)itemArr{
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
    for (NSDictionary *dataDic in itemArr) {
        NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:dataDic[@"image"]];
        attach.bounds = CGRectMake(0, -2, 12, 12);
        [attStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:dataDic[@"title"] attributes:@{NSFontAttributeName:FONT(13),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
    }
    return [[NSAttributedString alloc]initWithAttributedString:attStr];
}

#pragma mark 顶部按钮动作
- (void)topBtnAction:(UIButton *)sender {
    if (sender.tag!=_reportType) {
        //移除底部选择view
        [self removeBottomSelectedView];
        //获取上一个选中的按钮，将其设置为为选中的状态
        UIButton *lastSelectedBtn = (UIButton *)[self.view viewWithTag:_reportType];
        lastSelectedBtn.selected = NO;
        //改变当前选中按钮的状态,并给_selectedBtnTag赋值
        sender.selected = !sender.selected;
        _reportType = sender.tag;
        
        ReportManagerViewController*__weak weakVC = self;
        [UIView animateWithDuration:0.2
                         animations:^{
                             weakVC.lineView.left = sender.left;
                         }];
        _dataArr = [NSMutableArray array];
        _selectedArr = [NSMutableArray array];
        [self.tableView reloadData];
        
        _currentPage = 1;
        //获取报名列表
        [self getReportListWithIsUpdate:NO];
    }
    
}

#pragma mark 获取报名列表
-(void)getReportListWithIsUpdate:(BOOL)isUpdate {
    if (_dataArr.count==0) {
        [self.view showProgressHintWith:@"加载中"];
    }
    [YMWebClient getReportListWithParams:@{@"jobId":@(_jobInfo.id),@"type":@(_reportType-99),@"pageSize":@(DATASIZE),@"pageNum":@(_currentPage)} Success:^(YMReportListResponse *response) {
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
                   
                    ReportManagerViewController *__weak weakVC = self;
                    [EmptyViewFactory errorNetwork:self.tableView Offset:125/2.0 btnBlock:^{
                        ReportManagerViewController *__block blockVC = weakVC;
                        blockVC -> _currentPage = 1;
                        [blockVC getReportListWithIsUpdate:NO];
                    }];
                }
               
            }
            else {
                
                if (isUpdate) {
                    NSInteger count = 0;
                    for (YMReportInfo *info in response.data.list) {
                        [_dataArr replaceObjectAtIndex:(_currentPage-1)*DATASIZE+count withObject:info];
                        count++;
                    }
                }
                else {
                    _totalCount = response.data.count;
                    [self dealWithBackList:response.data.list];
                }
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
            NSString *text;
            if (_reportType==ReportManagerTypeAll) {
                text = @"没有人报名该职位哦";
            }
            else if (_reportType==ReportManagerTypeWaitSign) {
                text = @"没有待签约的报名";
            }
            else if (_reportType==ReportManagerTypeWaitPay) {
                text = @"没有待支付的报名";
            }
            else if (_reportType==ReportManagerTypeWaitEvaluate) {
                text = @"没有待评价的报名";
            }
            [EmptyViewFactory errorNoData:self.tableView Offset:125.0/2.0 WithImageName:@"zwgl_wxx" Title:text];

        }
        else {
            self.tableView.mj_footer = nil;
        }
    }
    else {
         NSInteger itemCount = (_currentPage-1)*DATASIZE+list.count;
        if (_currentPage == 1) {
            
            [self.tableView.mj_footer resetNoMoreData];
            if (_reportType==ReportManagerTypeWaitPay) {
                _dataArr = [NSMutableArray array];
                [self dealWithPayListArr:list];
            }
            else {
                _dataArr = [NSMutableArray arrayWithArray:list];
            }
            
            //添加下拉刷新
            ReportManagerViewController*__weak weakVC = self;
            if (!self.tableView.mj_header) {
                
                MyRefreshHeader* header = [MyRefreshHeader headerWithRefreshingBlock:^{
                    ReportManagerViewController *blockVC = weakVC;
                    blockVC->_currentPage = 1;
                    [blockVC getReportListWithIsUpdate:NO];
                }];
                self.tableView.mj_header = header;
            }
           
            //添加上拉加载
            if (_totalCount >= itemCount) {
                if (!self.tableView.mj_footer) {
                    self.tableView.mj_insetB = 0.0;
                    
                    MyRefreshFooter* footer = [MyRefreshFooter footerWithRefreshingBlock:^{
                        ReportManagerViewController *blockVC = weakVC;
                        blockVC->_currentPage++;
                        [blockVC getReportListWithIsUpdate:NO];
                    }];
                    footer.noMoreDataStr = @"已没有更多报名信息";
                    self.tableView.mj_footer = footer;
                }
                if (_totalCount == itemCount) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else {
            if (_reportType==ReportManagerTypeWaitPay) {
                [self dealWithPayListArr:list];
            }
            else {
                 [_dataArr addObjectsFromArray:list];
            }
            if (_totalCount <= itemCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }
    
}

-(void)dealWithPayListArr:(NSArray *)listArr {
    
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
     NSInteger lastCount = _dataArr.count-1;
    
    for (YMReportInfo *info in listArr) {
        
        YMPayListItemInfo *itemInfo;
        if (lastCount==-1) {
            itemInfo = [[YMPayListItemInfo alloc]init];
            itemInfo.date = info.date;
            itemInfo.list = @[];
            itemInfo.list = [itemInfo.list arrayByAddingObject:info];
            [_dataArr addObject:itemInfo];
            lastCount++;
        }
        else {
            itemInfo = _dataArr[lastCount];
            NSDate *itemDate = [ProjectUtil getDateWithTimeSp:itemInfo.date];
            NSDateComponents *itemDateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:itemDate];
            
            NSDate *infoDate = [ProjectUtil getDateWithTimeSp:info.date];
             NSDateComponents *infoDateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:infoDate];
            if ([infoDateComponents isEqual:itemDateComponents]) {
                itemInfo.list = [itemInfo.list arrayByAddingObject:info];
                [_dataArr replaceObjectAtIndex:lastCount withObject:itemInfo];
            }
            else {
                itemInfo = [[YMPayListItemInfo alloc]init];
                itemInfo.date = info.date;
                itemInfo.list = @[];
                itemInfo.list = [itemInfo.list arrayByAddingObject:info];
                [_dataArr addObject:itemInfo];
                lastCount++;
            }
        }
    }
    
    
}




#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_reportType==ReportManagerTypeWaitPay) {
        return _dataArr.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_reportType==ReportManagerTypeWaitPay) {
        YMPayListItemInfo *itemInfo = _dataArr[section];
        return itemInfo.list.count;
    }
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_reportType==ReportManagerTypeWaitPay) {
        return 30.0;
    }
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_reportType==ReportManagerTypeWaitPay&&section!=_dataArr.count) {
        return 10.0;
    }
    return 0.0;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifier = @"headerView";
    ReportListPayCellHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[ReportListPayCellHeaderView alloc]initWithReuseIdentifier:identifier];
        [headerView.selectButton addTarget:self action:@selector(sectionSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    headerView.selectButton.tag = section;
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    YMPayListItemInfo *itemInfo = _dataArr[section];
    headerView.timeLabel.text = [ProjectUtil changeToChineseDateStrWithSp:itemInfo.date];
    if (itemInfo.selectedCount==itemInfo.list.count) {
        headerView.selectButton.selected = YES;
    }
    else {
        headerView.selectButton.selected = NO;
    }
    
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YMReportInfo *info = [self getReportInfoWithIndexPath:indexPath];
    ReportListCellType cellType = [self getCellTypeWithStatus:info.status];
    ReportListCell *cell = [tableView dequeueReusableCellWithIdentifier:[ReportListCell getReuserIdentifierWithType:cellType]];
    if (cell==nil) {
        cell = [[ReportListCell alloc]initWithType:cellType];
    
        if (cell.hireBtn) {
            [cell.hireBtn addTarget:self action:@selector(hireBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (cell.refuseBtn) {
            [cell.refuseBtn addTarget:self action:@selector(refuseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (cell.payBtn) {
            [cell.payBtn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (cell.unWorkBtn) {
            [cell.unWorkBtn addTarget:self action:@selector(evaluateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (cell.cashPayBtn) {
            [cell.cashPayBtn addTarget:self action:@selector(cashPayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (cell.evaluateBtn) {
            [cell.evaluateBtn addTarget:self action:@selector(evaluateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (cell.selectedBtn) {
            [cell.selectedBtn addTarget:self action:@selector(selectedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (cell.phoneBtn) {
            [cell.phoneBtn addTarget:self action:@selector(callStuPhone:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (cell.checkBtn) {
            [cell.checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (cell.checkEvaluateBtn) {
            [cell.checkEvaluateBtn addTarget:self action:@selector(checkEvaluateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (cell.payCountField) {
             cell.payCountField.delegate = self;
        }
        
        cell.sexImageView.userInteractionEnabled = YES;
        [cell.sexImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpStaffDetail:)]];
       
    }
    if (info.sex==1) {
        cell.sexImageView.backgroundColor = SEX_MAN_COLOR;
        cell.sexImageView.image = [UIImage imageNamed:@"zwgl_nan"];
    }
    else if (info.sex==2) {
        cell.sexImageView.backgroundColor = SEX_WOMEN_COLOR;
        cell.sexImageView.image = [UIImage imageNamed:@"zwgl_nv"];
    }
    
    NSMutableAttributedString *infoAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@    ",info.stuName] attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:[UIColor blackColor]}];
   
    if (cellType!=ReportListCellTypeWaitPay&&cellType!=ReportListCellTypeWaitPayEdit) {
        NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:@"zwgl_p"];
        attach.bounds = CGRectMake(0, -1, 15, 15);
        [infoAttStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        [infoAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%@",(long)info.praise,@"%"] attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
    }
   
    cell.infoLabel.attributedText = infoAttStr;
    if (cell.statusLabel) {
        cell.statusLabel.text = [LocalDicDataBaseManager getNameWithType:LocalDicTypeJobStatus VersionId:info.status];
    }
    if (cell.phoneBtn) {
        [cell.phoneBtn setTitle:info.stuPhone forState:UIControlStateNormal];
    }
    if (cell.checkBtn) {
        NSMutableAttributedString *checkAttStr = [[NSMutableAttributedString alloc]initWithString:[ProjectUtil getSignTypeStringWithSignType:info.signType] attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:DefaultGrayTextColor}];
        if (info.signType==2) {
            NSTextAttachment *attach = [[NSTextAttachment alloc]init];
            attach.image = [UIImage imageNamed:@"zwgl_qd"];
            NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attach];
            [checkAttStr appendAttributedString:attStr];
        }
        [cell.checkBtn setAttributedTitle:checkAttStr forState:UIControlStateNormal];
    }
    if (cell.payCountField) {
        if (info.pay==0.0) {
            cell.payCountField.text = @"";
        }
        else {
            cell.payCountField.text = [NSString stringWithFormat:@"%g",info.pay];
        }
    }
    cell.contentView.tag = indexPath.section;
    cell.selectedBtn.superview.tag = indexPath.section;
    cell.phoneBtn.tag = indexPath.row;
    cell.sexImageView.tag = indexPath.row;
    cell.hireBtn.tag = indexPath.row;
    cell.refuseBtn.tag = indexPath.row;
    cell.payBtn.tag = indexPath.row;
    cell.cashPayBtn.tag = indexPath.row;
    cell.unWorkBtn.tag = indexPath.row;
    cell.evaluateBtn.tag = indexPath.row;
    cell.checkEvaluateBtn.tag = indexPath.row;
    cell.selectedBtn.tag = indexPath.row;
    cell.checkBtn.tag = indexPath.row;
    cell.payCountField.tag = indexPath.row;
    
    if ([_selectedArr containsObject:info]) {
        cell.selectedBtn.selected = YES;
    }
    else {
        cell.selectedBtn.selected = NO;
    }
    return cell;
}

#pragma mark 获取数据
-(YMReportInfo *)getReportInfoWithIndexPath:(NSIndexPath *)indexPath {
    YMReportInfo *info;
    if (_reportType!=ReportManagerTypeWaitPay) {
        info = _dataArr[indexPath.row];
    }
    else{
        YMPayListItemInfo *itemInfo = _dataArr[indexPath.section];
        info = itemInfo.list[indexPath.row];
    }
    return info;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_reportType==ReportManagerTypeWaitSign|_reportType==ReportManagerTypeWaitPay) {
        YMReportInfo *info = [self getReportInfoWithIndexPath:indexPath];
        ReportListCell *cell = (ReportListCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self dealMultiChooseWithSelectedBtn:cell.selectedBtn Info:info];
    }
}

#pragma mark section头选中按钮操作
-(void)sectionSelectButtonAction:(UIButton *)sender {
    ReportBottomSelectedView *selectedView = (ReportBottomSelectedView *)[self.view viewWithTag:BottomSelectedViewTag];
    YMPayListItemInfo *itemInfo = _dataArr[sender.tag];
    sender.selected = !sender.selected;
    if (sender.selected) {
        itemInfo.selectedCount = itemInfo.list.count;
        for (YMReportInfo *info in itemInfo.list) {
            if (![_selectedArr containsObject:info]) {
                [_selectedArr addObject:info];
            }
        }
        if (_selectedArr.count!=_dataArr.count) {
            selectedView.selectedAllBtn.selected = NO;
        }
        else {
            selectedView.selectedAllBtn.selected = YES;
        }
    }
    else {
        itemInfo.selectedCount = 0;
        for (YMReportInfo *info in itemInfo.list) {
            if ([_selectedArr containsObject:info]) {
                [_selectedArr removeObject:info];
            }
        }
        selectedView.selectedAllBtn.selected = NO;
    }
    [self showBottomView];
}

#pragma mark 选中按钮动作
-(void)selectedBtnAction:(UIButton *)sender {
    YMReportInfo *info = [self getReportInfoWithIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:sender.superview.tag]];
    [self dealMultiChooseWithSelectedBtn:sender Info:info];
}

#pragma mark 处理批量多选动作
-(void)dealMultiChooseWithSelectedBtn:(UIButton *)selectedBtn Info:(YMReportInfo *)info {
    selectedBtn.selected = !selectedBtn.selected;
    if (selectedBtn.selected) {
        [_selectedArr addObject:info];
        if (_reportType==ReportManagerTypeWaitPay) {
            YMPayListItemInfo *itemInfo = _dataArr[selectedBtn.superview.tag];
            itemInfo.selectedCount +=1;
        }
    }
    else {
        [_selectedArr removeObject:info];
        if (_reportType==ReportManagerTypeWaitPay) {
            YMPayListItemInfo *itemInfo = _dataArr[selectedBtn.superview.tag];
            itemInfo.selectedCount -=1;
        }
    }
    [self showBottomView];
}

#pragma mark 显示底部view
-(void)showBottomView {
    ReportBottomSelectedView *selectedView = (ReportBottomSelectedView *)[self.view viewWithTag:BottomSelectedViewTag];
    
    if (_selectedArr.count!=0) {
        if (!selectedView) {
            selectedView = [[ReportBottomSelectedView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64.0, SCREEN_WIDTH, 49.0)];
            [selectedView.selectedAllBtn addTarget:self action:@selector(selectedAllBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [selectedView.doBtn addTarget:self action:@selector(bottomDoBtnAction) forControlEvents:UIControlEventTouchUpInside];
            selectedView.tag = BottomSelectedViewTag;
            [self.view addSubview:selectedView];
            
            [UIView animateWithDuration:0.3 animations:^{
                selectedView.top = SCREEN_HEIGHT-64.0-49.0;
                self.tableView.height = SCREEN_HEIGHT-64.0-49.0;
            }];
        }
        if (_reportType==ReportManagerTypeWaitSign) {
            [selectedView.doBtn setTitle:[NSString stringWithFormat:@"录用（%ld人）",(long)_selectedArr.count] forState:UIControlStateNormal];
        }
        else if (_reportType==ReportManagerTypeWaitPay) {
            double totalPay = 0.0;
            for (YMReportInfo *info in _selectedArr) {
                totalPay += info.pay;
            }
            [selectedView.doBtn setTitle:[NSString stringWithFormat:@"支付（%g元）",totalPay] forState:UIControlStateNormal];
        }
        if (_selectedArr.count!=_totalCount) {
            selectedView.selectedAllBtn.selected = NO;
        }
        else {
            selectedView.selectedAllBtn.selected = YES;
        }
        if (_reportType==ReportManagerTypeWaitPay) {
            [self.tableView reloadData];
        }
    }
    else {
        [self removeBottomSelectedView];
        [self.tableView reloadData];
    }

}

#pragma mark 全选按钮动作
-(void)selectedAllBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (_reportType==ReportManagerTypeWaitPay) {
            [_selectedArr removeAllObjects];
            for (YMPayListItemInfo *itemInfo in _dataArr) {
                for (YMReportInfo *info in itemInfo.list) {
                    [_selectedArr  addObject:info];
                }
                itemInfo.selectedCount = itemInfo.list.count;
            }
        }
        else {
            _selectedArr = [NSMutableArray arrayWithArray:_dataArr];
        }
        
    }
    else {
        if (_reportType==ReportManagerTypeWaitPay) {
            for (YMPayListItemInfo *itemInfo in _dataArr) {
                itemInfo.selectedCount = 0;
            }
        }
        _selectedArr = [NSMutableArray array];

    }
    [self showBottomView];
    [self.tableView reloadData];
}


#pragma mark 底部操作按钮动作
-(void)bottomDoBtnAction {
    NSString *idsStr = @"";
    for (YMReportInfo *info in _selectedArr) {
        idsStr = [idsStr stringByAppendingFormat:@"%ld,",(long)info.id];
    }
    if (_reportType==ReportManagerTypeWaitSign) {
        [self hireWithParams:@{@"ids":[idsStr substringToIndex:idsStr.length-1],@"jobId":@(_jobInfo.id)}];
    }
    else {
        [self payPublickAction];
    }
    
}

#pragma mark 移除底部选中View
-(void)removeBottomSelectedView {
    ReportBottomSelectedView *selectedView = (ReportBottomSelectedView *)[self.view viewWithTag:BottomSelectedViewTag];
    if (selectedView) {
        [UIView animateWithDuration:0.3 animations:^{
            selectedView.top = SCREEN_HEIGHT-64.0;
            self.tableView.height = SCREEN_HEIGHT-64.0;
        } completion:^(BOOL finished) {
            [selectedView removeFromSuperview];
        }];
    }
    
}

#pragma mark 获取Cell的类别
-(ReportListCellType)getCellTypeWithStatus:(NSInteger)status {
    switch (_reportType) {
        case ReportManagerTypeAll:
            switch (status) {
                case 0:
                    return ReportListCellTypeWaitSign;
                    break;
                case 4:
                    return ReportListCellTypeWaitPay;
                    break;
                case 9:
                    return ReportListCellTypeWaitEvaluate;
                    break;
                case 11:
                    return ReportListCellTypeCheckEvaluate;
                    break;
                case 10:
                    return ReportListCellTypeWaitEvaluate;
                    break;
                case 12:
                    return ReportListCellTypeCheckEvaluate;
                    break;
 
                default:
                    return ReportListCellTypeNomal;
                    break;
            }
            break;
            
            case ReportManagerTypeWaitSign:
            return ReportListCellTypeWaitSignEdit;
            break;
            
            case ReportManagerTypeWaitPay:
            return ReportListCellTypeWaitPayEdit;
            break;
            
            case ReportManagerTypeWaitEvaluate:
            return ReportListCellTypeWaitEvaluate;
            break;
        default:
            break;
    }
}

#pragma mark 拨打电话
-(void)callStuPhone:(UIButton *)sender {
    [self callWithPhoneNum:[sender titleForState:UIControlStateNormal]];
}

#pragma mark 员工详情
-(void)jumpStaffDetail:(UITapGestureRecognizer *)tap {
    YMReportInfo *info = [self getReportInfoWithIndexPath:[NSIndexPath indexPathForRow:tap.view.tag inSection:tap.view.superview.tag]];
    StaffDetailViewController *nextVC = [[StaffDetailViewController alloc]init];
    nextVC.title = @"员工详情";
    nextVC.reportInfo = info;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark 录用
-(void)hireBtnAction:(UIButton *)sender {
    YMReportInfo *info = _dataArr[sender.tag];
    [self hireWithParams:@{@"ids":@(info.id),@"jobId":@(_jobInfo.id)}];
}

#pragma mark 录用公共方法
-(void)hireWithParams:(NSDictionary *)params {
    [self.view showProgressHintWith:@"录用中"];
    [YMWebClient hireWithParams:params Success:^(YMNomalResponse *response) {
        [self.view dismissProgress];
        if (response.code==ERROR_OK) {
            [self.view showSuccessHintWith:@"录用成功"];
            [self removeBottomSelectedView];
            [self topBtnAction:[self.view viewWithTag:ReportManagerTypeWaitPay]];
        }
        else {
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
    }];
}

#pragma mark 支付公共方法
-(void)payPublickAction {
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
    [YMWebClient payWithParams:@{@"payData":paramsArr.mj_JSONString,@"payType":@(1)} Success:^(YMNomalResponse *response) {
        [self.view dismissProgress];
        if (response.code==ERROR_OK) {
            [self.view.window showSuccessHintWith:@"支付成功"];
            _currentPage = 1;
            [self removeBottomSelectedView];
            [self getReportListWithIsUpdate:NO];
        }
        else {
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
    }];
}

#pragma mark 拒绝
-(void)refuseBtnAction:(UIButton *)sender {
    YMReportInfo *info = _dataArr[sender.tag];
    [self.view showProgressHintWith:@"拒绝中"];
    [YMWebClient refuseWithParams:@{@"id":@(info.id)} Success:^(YMNomalResponse *response) {
        [self.view dismissProgress];
        if (response.code==ERROR_OK) {
            [self.view showSuccessHintWith:@"拒绝成功"];
            if (_reportType!=ReportManagerTypeAll) {
                [self topBtnAction:[self.view viewWithTag:ReportManagerTypeAll]];
            }
            else {
                _currentPage = 1;
                [self getReportListWithIsUpdate:NO];
            }
        }
        else {
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
    }];
}

#pragma mark 支付
-(void)payBtnAction:(UIButton *)sender {
    YMReportInfo *info = _dataArr[sender.tag];
    PayViewController *nextVC = [[PayViewController alloc]init];
    nextVC.title = @"支付工资";
    nextVC.jobId = _jobInfo.id;
    nextVC.reportInfo = info;
    nextVC.payType = 1;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark 现金支付
-(void)cashPayBtnAction:(UIButton *)sender {
    YMReportInfo *info = _dataArr[sender.tag];
    PayViewController *nextVC = [[PayViewController alloc]init];
    nextVC.title = @"支付工资";
    nextVC.jobId = _jobInfo.id;
    nextVC.reportInfo = info;
    nextVC.payType = 0;
    [self.navigationController pushViewController:nextVC animated:YES];
}



#pragma mark 标记未上岗
-(void)unWorkBtnAction:(UIButton *)sender {
    YMReportInfo *info = [self getReportInfoWithIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:sender.superview.tag]];
    [self.view showProgressHintWith:@"标记中"];
    [YMWebClient unWorkWithParams:@{@"id":@(info.id)} Success:^(YMNomalResponse *response) {
        [self.view dismissProgress];
        if (response.code==ERROR_OK) {
            [self.view showSuccessHintWith:@"标记未上岗成功"];
            if (_reportType!=ReportManagerTypeAll) {
                [self topBtnAction:[self.view viewWithTag:ReportManagerTypeAll]];
            }
        }
        else {
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
    }];
}

#pragma mark 评价
-(void)evaluateBtnAction:(UIButton *)sender {
    YMReportInfo *info = [self getReportInfoWithIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:sender.superview.tag]];
    EvaluateViewController *nextVC = [[EvaluateViewController alloc]init];
    nextVC.title = @"工作评价";
    nextVC.reportInfo = info;
    nextVC.jobId = _jobInfo.id;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark 查看评价
-(void)checkEvaluateBtnAction:(UIButton *)sender {
    YMReportInfo *info = [self getReportInfoWithIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:sender.superview.tag]];
    HasEvaluateViewController *nextVC = [[HasEvaluateViewController alloc]init];
    nextVC.title = @"工作评价";
    nextVC.stuId = info.stuId;
    nextVC.regiId = info.regiId;
    nextVC.regiId = info.id;
    nextVC.jobId = _jobInfo.id;
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

#pragma mark  查看签到地址
-(void)checkBtnAction:(UIButton *)sender{
    YMReportInfo *info = [self getReportInfoWithIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:sender.superview.tag]];
    if (info.signAddress.length!=0) {
        [ProjectUtil showAlert:@"已签到" message:info.signAddress];
    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *totalStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (![totalStr isType:SpecialStringTypePayCount]&&totalStr.length!=0) {
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    YMReportInfo *info = [self getReportInfoWithIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:textField.superview.tag]];
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



-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
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
