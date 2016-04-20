//
//  JobViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "JobListViewController.h"
#import "JobCell.h"
#import "UIView+Hint.h"
#import "MJRefresh.h"
#import "LocalDicDataBaseManager.h"
#import "JobDetailViewController.h"
#import "CorpInfoTableViewViewController.h"
#import "PostJobViewController.h"

@interface JobListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currentPage;
    NSMutableArray *_dataArr;
    int _totalCount;
    BOOL _isNotFirst;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *topSegment;

@end

@implementation JobListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
    
    UITabBarItem *barItem = self.tabBarController.tabBar.items[1];
    barItem.selectedImage = [[UIImage imageNamed:@"tabbar_zhiwei_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_topSegment setTitleTextAttributes:@{NSFontAttributeName:Default_Font_15} forState:UIControlStateNormal];
}

-(void)layoutSubViews
{
    self.tableView.frame = CGRectMake(0, _topSegment.height+11, SCREEN_WIDTH, SCREEN_HEIGHT-64.0-_topSegment.height-11-49.0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //请求数据
    [self topSegmentAction:_topSegment];
    _isNotFirst = YES;
    //更新数据通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNotificationAction) name:JumpJobListNotification object:nil];
    
    //发布职位按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"home_fb"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(postJobAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:JumpJobListNotification object:nil];
}

#pragma mark 跳转发布职位
-(void)postJobAction
{
    if ([ProjectUtil isCompleteCorpInfo])
    {
        [self jumpToPostJob];
    }
    else
    {
        [YMWebServiceClient getIsCompleteCorpInfoSuccess:^(YMCompleteCorpInfoResponse *response) {
            if(response.code==ERROR_OK){
                if (response.data.isPublish==0)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您还未完善商家信息还不能发布职位" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去完善", nil];
                    [alertView show];
                }
                else if (response.data.isPublish==1)
                {
                    YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
                    loginInfo.isPublish = 1;
                    [ProjectUtil saveLoginInfo:loginInfo];
                    [self jumpToPostJob];
                }
            }else{
                [self handleErrorWithErrorResponse:response];
            }
        }];
    }

}
#pragma mark 更新数据通知方法
-(void)updateNotificationAction
{
    if (_isNotFirst)
    {
        [self requestJobListWithJobType:_topSegment.selectedSegmentIndex];
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        CorpInfoTableViewViewController *corpInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CorpInfoVC"];
        corpInfoVC.corpInfoDic = [NSMutableDictionary dictionary];
        [self.navigationController pushViewController:corpInfoVC animated:YES];
    }
}

#pragma mark 跳转到发布职位VC
-(void)jumpToPostJob
{
    PostJobViewController *postJobVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostJobVC"];
    postJobVC.title = @"发布职位";
    [self.navigationController pushViewController:postJobVC animated:YES];
}

- (IBAction)topSegmentAction:(UISegmentedControl *)sender
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    _currentPage = 1;
    _dataArr = [NSMutableArray array];

    [self.tableView reloadData];
    [self requestJobListWithJobType:sender.selectedSegmentIndex];
}


#pragma mark 请求职位列表
-(void)requestJobListWithJobType:(NSInteger)jobType
{
    if (_dataArr.count==0)
    {
        [self.tableView showLoadingImageWithStatus:LoadingStatusOnLoading];
    }
    [YMWebServiceClient getJobListWithParams:@{@"pageNum":[NSNumber numberWithInteger:_currentPage],@"pageSize":[NSNumber numberWithInteger:DATASIZE],@"type":[NSNumber numberWithInteger:jobType]} Success:^(YMJobListResponse *response) {
        [self.tableView hiddenLoadingView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(response.code==ERROR_OK){
            _totalCount = response.data.count;
            [self dealWithBackList:response.data.list];
            [self.tableView reloadData];
        }else{
            self.tableView.mj_header=nil;
            self.tableView.mj_footer=nil;
            _dataArr = [NSMutableArray array];
            [self.tableView reloadData];
            [self handleErrorWithErrorResponse:response];
            __block JobListViewController *jobVC = self;
            [self.tableView handleReload:^{
                jobVC->_currentPage=1;
                [jobVC requestJobListWithJobType:_topSegment.selectedSegmentIndex];
            }];
        }
    }];
}

#pragma mark 处理返回列表数据
- (void)dealWithBackList:(NSArray*)list
{
    if (list.count==0)
    {
        _dataArr = [NSMutableArray array];
        if (_currentPage==1)
        {
            [self.tableView showLoadingImageWithStatus:LoadingStatusNoData];
            if (_topSegment.selectedSegmentIndex==0)
            {
                self.tableView.loadingLabel.text = @"您还没有发布过职位";
            }
            else if (_topSegment.selectedSegmentIndex==1)
            {
                self.tableView.loadingLabel.text = @"您还没有待审核的职位";
            }
            else if (_topSegment.selectedSegmentIndex==2)
            {
                self.tableView.loadingLabel.text = @"您还没有已审核的职位";
            }
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
            __block JobListViewController *jobVC = self;
            if (!self.tableView.mj_header)
            {
                MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    jobVC->_currentPage = 1;
                    [jobVC requestJobListWithJobType:_topSegment.selectedSegmentIndex];
                }];
                header.lastUpdatedTimeLabel.hidden = YES;
                self.tableView.mj_header =  header;
            }
            //添加下拉刷新
            if (_totalCount>_dataArr.count)
            {
                if (self.tableView.mj_footer==nil) {
                    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        jobVC->_currentPage+=1;
                        [jobVC requestJobListWithJobType:_topSegment.selectedSegmentIndex];
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
   static NSString *identifier = @"JobCell";
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
    [salaryAttStr addAttribute:NSForegroundColorAttributeName value:DefaultOrangeTextColor range:NSMakeRange(5, salaryCountStr.length)];
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
