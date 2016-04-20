//
//  SignCountListViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/15.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "SignCountListViewController.h"
#import "ReportStudentInfoCell.h"
#import "ContentCell.h"
#import "UIView+Hint.h"
#import "MJRefresh.h"
#import "LocalDicDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import "StudentResumeViewController.h"
#import "ReportDetailViewController.h"

@interface SignCountListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currentPage;
    NSMutableArray *_dataArr;
    int _totalCount;
}


@end

@implementation SignCountListViewController

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
    //添加更新数据通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateDataNotiAction) name:JumpReportListNotification object:nil];
    _currentPage = 1;
    [self requestSignList];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:JumpReportListNotification object:nil];
}

#pragma mark 请求签约列表数据
-(void)requestSignList
{
    if (_dataArr.count==0)
    {
        [self.tableView showLoadingImageWithStatus:LoadingStatusOnLoading];
    }
    
    [YMWebServiceClient getJobRegiListWithParams:@{@"jobId":[NSNumber numberWithInt:_jobId],@"type":[NSNumber numberWithInt:2],@"pageNum":[NSNumber numberWithInteger:_currentPage],@"pageSize":[NSNumber numberWithInteger:DATASIZE]} Success:^(YMJobRegiResponse *response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(response.code==ERROR_OK){
            _totalCount=response.data.count;
            [self.tableView hiddenLoadingView];
            [self dealWithBackList:response.data.list];
            [self.tableView reloadData];
        }else{
            self.tableView.mj_header=nil;
            self.tableView.mj_footer=nil;
            _dataArr = [NSMutableArray array];
            [self.tableView reloadData];
            [self handleErrorWithErrorResponse:response];
            __block SignCountListViewController *signCountVC = self;
            [self.tableView handleReload:^{
                signCountVC->_currentPage=1;
                [signCountVC requestSignList];
                
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
            self.tableView.loadingLabel.text = @"该职位还没有已签约的人";
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
            __block SignCountListViewController *signCountVC = self;
            if (!self.tableView.mj_header)
            {
                MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    signCountVC->_currentPage = 1;
                    [signCountVC requestSignList];
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
                        signCountVC->_currentPage+=1;
                        [signCountVC requestSignList];
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
#pragma mark 通知更新数据方法
-(void)updateDataNotiAction
{
    _currentPage = 1;
    [self requestSignList];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YMJobRegiSummary *info = _dataArr[section];
    if (info.jobRegiOrderList.count!=0)
    {
        return 3;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMJobRegiSummary *info = _dataArr[indexPath.section];
    if (indexPath.row==1)
    {
        return 100.0;
    }
    else if (indexPath.row==2)
    {
        return [ContentCell getCellHeightIsHasTitile:YES ContentRows:info.jobRegiOrderList.count];
    }
    return 50.0;
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
    YMJobRegiSummary *info = _dataArr[indexPath.section];
    if (indexPath.row==0)
    {
        static NSString *identifier = @"ReportStudentInfoCell";
        ReportStudentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ReportStudentInfoCell" owner:nil options:nil]lastObject];
        }
        
        [cell.stuAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,info.stuPhotoScale]] placeholderImage:[UIImage imageNamed:@"stu_avatar"]];
        if (info.sex==1)
        {
            cell.stuSexImageView.image = [UIImage imageNamed:@"sex_man"];
        }
        else if (info.sex==2)
        {
            cell.stuSexImageView.image = [UIImage imageNamed:@"sex_woman"];
        }
        cell.stuNameLabel.text = [NSString stringWithFormat:@"%@",info.stuName];
        cell.stuPhoneLabel.text = info.stuPhone;
        cell.callBtn.tag = indexPath.section;
        [cell.callBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.statusLabel.text = [LocalDicDataBaseManager getNameWithType:LocalDicTypeJobStatus VersionId:info.status];
        if (info.status==0|info.status==3)
        {
            cell.statusLabel.textColor = DefaultOrangeTextColor;
        }
        else if (info.status==4)
        {
            cell.statusLabel.textColor = DefaultGreenTextColor;
        }
        else
        {
            cell.statusLabel.textColor = DefaultRedTextColor;
        }

        
        return cell;
    }
    else if (indexPath.row==1)
    {
        NSString *salaryCountStr = [NSString stringWithFormat:@"%d元",info.pay];
        NSString *salaryStr = [NSString stringWithFormat:@"工资待遇：%@%@",salaryCountStr,[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:info.payUnit]];
        NSMutableAttributedString *salaryAttStr = [[NSMutableAttributedString alloc] initWithString:salaryStr attributes:@{NSFontAttributeName:Default_Font_13,NSForegroundColorAttributeName:DefaultGrayTextColor}];
        [salaryAttStr addAttribute:NSForegroundColorAttributeName value:NavigationBarColor range:NSMakeRange(5, salaryCountStr.length)];
        static NSString *identifier = @"JobInfoCell";
        ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[ContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.contentArr = @[salaryAttStr,[NSString stringWithFormat:@"报名时间：%@",[ProjectUtil changeStandardDateStrWithSp:info.regiTime]],[NSString stringWithFormat:@"确认时间：%@",[ProjectUtil changeStandardDateStrWithSp:info.creatTime]]];        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *identifier = @"JobInfoCell";
        ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (YMJobRegiOrderSummary *orderInfo in info.jobRegiOrderList)
        {
            [tempArr addObject:[NSString stringWithFormat:@"%@/%g%@/%@",[[ProjectUtil changeStandardDateStrWithSp:orderInfo.workStartTime]substringToIndex:16],orderInfo.workTimes,[ProjectUtil getWorkTimeUnitStrWithUnitId:orderInfo.workTimesUnit],[ProjectUtil getOrderStatusStrWithStatus:orderInfo.status]]];
        }
        
        if (cell==nil)
        {
            cell = [[ContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.title = @"上岗订单";
        cell.contentArr = [NSArray arrayWithArray:tempArr];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YMJobRegiSummary *info = _dataArr[indexPath.section];
    
    if (indexPath.row==0)
    {
        StudentResumeViewController *stuResumeVC = [[StudentResumeViewController alloc]init];
        stuResumeVC.title = @"学生简历";
        stuResumeVC.stuId = info.stuId;
        [self.navigationController pushViewController:stuResumeVC animated:YES];
    }
    else if (indexPath.row==2)
    {
        ReportDetailViewController *reportDetailVC = [[ReportDetailViewController alloc]init];
        reportDetailVC.title = info.jobName;
        reportDetailVC.info = info;
        [self.navigationController pushViewController:reportDetailVC animated:YES];
    }
}


#pragma mark 拨打电话按钮
-(void)callBtnAction:(UIButton *)sender
{
    YMWaitInviteSummary *info = _dataArr[sender.tag];
    [self callWithPhoneNum:info.stuPhone];
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
