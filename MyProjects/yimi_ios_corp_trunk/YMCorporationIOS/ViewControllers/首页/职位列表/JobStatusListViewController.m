//
//  OnRecruitViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/3.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "JobStatusListViewController.h"
#import "JobCell.h"
#import "UIView+Hint.h"
#import "MJRefresh.h"
#import "LocalDicDataBaseManager.h"
#import "JobDetailViewController.h"

@interface JobStatusListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currentPage;
    NSMutableArray *_dataArr;
    int _totalCount;
}

@end

@implementation JobStatusListViewController



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
    //请求数据
    _currentPage = 1;
    _dataArr = [NSMutableArray array];
    [self requestJobList];
}
#pragma mark 请求职位列表
-(void)requestJobList
{
    if (_dataArr.count==0)
    {
        [self.tableView showLoadingImageWithStatus:LoadingStatusOnLoading];
    }
    [YMWebServiceClient getJobListWithParams:@{@"pageNum":[NSNumber numberWithInteger:_currentPage],@"pageSize":[NSNumber numberWithInteger:DATASIZE],@"type":[NSNumber numberWithInteger:_jobStatus]} Success:^(YMJobListResponse *response) {
        [self.tableView hiddenLoadingView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(response.code==ERROR_OK){
            _totalCount = response.data.count;
            [self dealWithBackList:response.data.list];
            [self.tableView reloadData];
        }else{
            self.tableView.mj_header = nil;
            self.tableView.mj_footer = nil;
            _dataArr = [NSMutableArray array];
            [self.tableView reloadData];
            [self handleErrorWithErrorResponse:response];
            __block JobStatusListViewController *onRecruitVC = self;
            [self.tableView handleReload:^{
                onRecruitVC->_currentPage=1;
                [onRecruitVC requestJobList];
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
            self.tableView.loadingLabel.text = @"您还没有在招职位";
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
             JobStatusListViewController *__weak weakVC = self;
            if (!self.tableView.mj_header)
            {
                MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    JobStatusListViewController *blockVC = weakVC;
                    blockVC->_currentPage = 1;
                    [blockVC requestJobList];
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
                        JobStatusListViewController *blockVC = weakVC;
                        blockVC->_currentPage+=1;
                        [blockVC requestJobList];
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
    return 155.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"JobCell";
    JobCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JobCell" owner:nil options:nil]lastObject];
    }
    YMJobSummary *jobInfo = _dataArr[indexPath.section];
    cell.jobNameLabel.text = jobInfo.name;
    cell.statusLabel.text = [ProjectUtil getJobStatusStrWithIsCheck:jobInfo.isCheck];
    if (jobInfo.isCheck==1)
    {
        cell.statusLabel.textColor = DefaultOrangeTextColor;
    }
    else if (jobInfo.isCheck==2)
    {
        cell.statusLabel.textColor = DefaultGreenTextColor;
    }
    else if (jobInfo.isCheck==3)
    {
        cell.statusLabel.textColor = DefaultRedTextColor;
    }
    else
    {
        cell.statusLabel.textColor = DefaultGrayTextColor;
    }

    NSString *salaryCountStr = [NSString stringWithFormat:@"%d",jobInfo.pay];
    NSString *salaryStr = [NSString stringWithFormat:@"工资待遇：%@%@",salaryCountStr,[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:jobInfo.payUnit]];
    NSMutableAttributedString *salaryAttStr = [[NSMutableAttributedString alloc] initWithString:salaryStr attributes:@{NSFontAttributeName:Default_Font_13,NSForegroundColorAttributeName:DefaultGrayTextColor}];
    [salaryAttStr addAttribute:NSForegroundColorAttributeName value:NavigationBarColor range:NSMakeRange(5, salaryCountStr.length)];
    cell.salaryLabel.attributedText = salaryAttStr;
    cell.recuitCountLabel.text = [NSString stringWithFormat:@"招聘人数：%d人",jobInfo.count];
    cell.validDateLabel.text = [NSString stringWithFormat:@"有效日期：%@ 至 %@",[ProjectUtil changeToDefaultDateStrWithSp:jobInfo.startTime],[ProjectUtil changeToDefaultDateStrWithSp:jobInfo.endTime]];
    cell.creatTimeLabel.text = [NSString stringWithFormat:@"发布时间：%@",[ProjectUtil changeStandardDateStrWithSp:jobInfo.creatTime]];
    cell.addressLabel.text = [NSString stringWithFormat:@"工作地址：%@",jobInfo.address];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YMJobSummary *jobInfo = _dataArr[indexPath.section];
    JobDetailViewController *jobDetailVC = [[JobDetailViewController alloc]init];
    jobDetailVC.title = @"职位详情";
    jobDetailVC.hidesBottomBarWhenPushed = YES;
    jobDetailVC.jobId = jobInfo.id;
    [self.navigationController pushViewController:jobDetailVC animated:YES];
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
