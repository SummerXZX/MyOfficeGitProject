//
//  WithdrawRecordViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/15.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "WithdrawRecordViewController.h"
#import "UIView+Hint.h"
#import "MJRefresh.h"
#import "RecordCell.h"

@interface WithdrawRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currentPage;
    NSMutableArray *_dataArr;
    int _totalCount;
}


@end

@implementation WithdrawRecordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    self.tableView.height = SCREEN_HEIGHT-64.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //请求充值记录
    _currentPage = 1;
    [self requestWithdrawRecordList];
}

#pragma mark 请求提现记录
-(void)requestWithdrawRecordList
{
    if (_dataArr.count==0)
    {
        [self.tableView showLoadingImageWithStatus:LoadingStatusOnLoading];
    }
    [YMWebServiceClient getWithdrawRecordParams:@{@"pageNum":[NSNumber numberWithInteger:_currentPage],@"pageSize":[NSNumber numberWithInteger:DATASIZE]} Success:^(YMWithdrawResponse *response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(response.code==ERROR_OK){
        [self.tableView hiddenLoadingView];
            _totalCount=response.data.count;
            [self dealWithBackList:response.data.list];
           
            [self.tableView reloadData];
        }else{
            self.tableView.mj_header=nil;
            self.tableView.mj_footer=nil;
            _dataArr = [NSMutableArray array];
            [self handleErrorWithErrorResponse:response];
            __block WithdrawRecordViewController *withdrawRecordVC = self;
            [self.tableView handleReload:^{
                withdrawRecordVC->_currentPage=1;
                [withdrawRecordVC requestWithdrawRecordList];
            }];

        }
    }];
}

#pragma mark 处理返回列表数据
- (void)dealWithBackList:(NSArray*)list{
    if (list.count==0)
    {
        _dataArr = [NSMutableArray array];
        if (_currentPage==1)
        {
            [self.tableView showLoadingImageWithStatus:LoadingStatusNoData];
            self.tableView.loadingLabel.text = @"您还有提现过哦";
        }
        else
        {
            self.tableView.mj_footer=nil;
        }
    }
    else
    {
        
        if (_currentPage==1)
        {
            _dataArr = [NSMutableArray arrayWithArray:list];
            //添加上拉刷新
             WithdrawRecordViewController *__weak weakVC = self;
            if (!self.tableView.mj_header)
            {
                MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    WithdrawRecordViewController *blockVC = weakVC;
                    blockVC->_currentPage = 1;
                    [blockVC requestWithdrawRecordList];
                }];
                header.lastUpdatedTimeLabel.hidden = YES;
                self.tableView.mj_header =  header;
            }
            //添加下拉刷新
            if (_totalCount>_dataArr.count)
            {
                if (!self.tableView.mj_footer) {
                    self.tableView.mj_insetB = 0.0;
                    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        WithdrawRecordViewController *blockVC = weakVC;
                        blockVC->_currentPage+=1;
                        [blockVC requestWithdrawRecordList];
                    }];
                    self.tableView.mj_footer = footer;
                }
                
            }
            else
            {
                self.tableView.mj_footer=nil;
            }
        }
        else
        {
            [_dataArr addObjectsFromArray:list];
            if (_totalCount<=_dataArr.count)
            {
                self.tableView.mj_footer = nil;
            }
        }
    }
}
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMWithdrawSummary *info = _dataArr[indexPath.section];
        static NSString *identifier = @"RecordCell";
        RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RecordCell" owner:nil options:nil]lastObject];
        }
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@元",info.amount];
        cell.timeLabel.text = [ProjectUtil changeStandardDateStrWithSp:info.creatTime];
        cell.statusLabel.text = [ProjectUtil getWithdrawStatusStrWithStatus:info.status];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

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
