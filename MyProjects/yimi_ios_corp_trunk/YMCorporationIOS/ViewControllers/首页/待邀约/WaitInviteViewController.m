//
//  WaitInviteViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/3.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "WaitInviteViewController.h"
#import "UIView+Hint.h"
#import "MJRefresh.h"
#import "LocalDicDataBaseManager.h"
#import "StuInfoCell.h"
#import "WaitInviteInfoCell.h"
#import "StudentResumeViewController.h"
#import "UIImageView+WebCache.h"
#import "FillWorkTimeViewController.h"

@interface WaitInviteViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSInteger _currentPage;
    NSMutableArray *_dataArr;
    int _totalCount;
}
@end

@implementation WaitInviteViewController



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
    //请求待签约列表数据
    _currentPage = 1;
    [self requestWaitInviteList];
}

#pragma mark 请求待签约列表数据
-(void)requestWaitInviteList
{
    if (_dataArr.count==0)
    {
        [self.tableView showLoadingImageWithStatus:LoadingStatusOnLoading];
    }
    [YMWebServiceClient getWaitInviteListWithParams:@{@"pageNum":[NSNumber numberWithInteger:_currentPage],@"pageSize":[NSNumber numberWithInteger:DATASIZE]} Success:^(YMWaitInviteListReponse *response) {
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
            __block WaitInviteViewController *waitInviteVC = self;
            [self.tableView handleReload:^{
                waitInviteVC->_currentPage=1;
                [waitInviteVC requestWaitInviteList];
            }];
        }
    } ];
}
#pragma mark 处理返回列表数据
- (void)dealWithBackList:(NSArray*)list{
    if (list.count==0)
    {
        _dataArr = [NSMutableArray array];
        if (_currentPage==1)
        {
            [self.tableView showLoadingImageWithStatus:LoadingStatusNoData];
            self.tableView.loadingLabel.text = @"当前没有待签约的人";
        }
        else
        {
            self.tableView.mj_footer =nil;
        }
    }
    else
    {
        if (_currentPage==1)
        {
            _dataArr = [NSMutableArray arrayWithArray:list];
            //添加上拉刷新
            __block WaitInviteViewController *waitInviteVC = self;
            if (!self.tableView.mj_header)
            {
                MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    waitInviteVC->_currentPage=1;
                    [waitInviteVC requestWaitInviteList];
                }];
                header.lastUpdatedTimeLabel.hidden = YES;
                self.tableView.mj_header = header;
            }
            
            //添加下拉刷新
            if (_totalCount>_dataArr.count)
            {
                if (!self.tableView.mj_footer) {
                    self.tableView.mj_insetB =0.0;
                    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        waitInviteVC->_currentPage++;
                        [waitInviteVC requestWaitInviteList];
                    }];
                    self.tableView.mj_footer = footer;
                }
                
            }
            else
            {
                self.tableView.mj_footer = nil;
            }
        }
        else
        {
            [_dataArr addObject:list];
            if (_totalCount<=_dataArr.count)
            {
                self.tableView.mj_footer = nil;
            }
        }
    }
}

#pragma mark tableViewDelegate,dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 50.0;
    }
    else if (indexPath.row==1)
    {
        return 120;
    }
    return 44.0;
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
    YMWaitInviteSummary *info = _dataArr[indexPath.section];
    if (indexPath.row==0)
    {
        static NSString *identifier = @"StuInfoCell";
        StuInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"StuInfoCell" owner:nil options:nil]lastObject];
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
        return cell;
    }
    else if (indexPath.row==1)
    {
       static NSString *identifier = @"WaitInviteInfoCell";
        WaitInviteInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"WaitInviteInfoCell" owner:nil options:nil]lastObject];
        }
        
        cell.jobNameLabel.text = info.jobName;
        NSString *salaryCountStr = [NSString stringWithFormat:@"%d",info.pay];
        NSString *salaryStr = [NSString stringWithFormat:@"工资待遇：%@%@",salaryCountStr,[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:info.payUnit]];
        NSMutableAttributedString *salaryAttStr = [[NSMutableAttributedString alloc] initWithString:salaryStr attributes:@{NSFontAttributeName:Default_Font_13,NSForegroundColorAttributeName:DefaultGrayTextColor}];
        [salaryAttStr addAttribute:NSForegroundColorAttributeName value:NavigationBarColor range:NSMakeRange(5, salaryCountStr.length)];
        cell.salaryLabel.attributedText = salaryAttStr;
        cell.reportTimeLabel.text = [NSString stringWithFormat:@"报名时间：%@",[ProjectUtil changeStandardDateStrWithSp:info.regiTime]];
        cell.inviteBtn.layer.borderColor = DefaultGrayTextColor.CGColor;
        [cell.inviteBtn addTarget:self action:@selector(inviteAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.refuseBtn.layer.borderColor = DefaultGrayTextColor.CGColor;
        [cell.refuseBtn addTarget:self action:@selector(refuseAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else
    {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0)
    {
        YMWaitInviteSummary *info = _dataArr[indexPath.section];
        StudentResumeViewController *stuResumeVC = [[StudentResumeViewController alloc]init];
        stuResumeVC.title = @"学生简历";
        stuResumeVC.stuId = info.stuId;
        [self.navigationController pushViewController:stuResumeVC animated:YES];
    }
}

#pragma mark 拨打电话按钮
-(void)callBtnAction:(UIButton *)sender
{
    [ProjectUtil showLog:@"%d",sender.tag];
    YMWaitInviteSummary *info = _dataArr[sender.tag];
    [self callWithPhoneNum:info.stuPhone];
}

#pragma mark 拒绝动作
-(void)refuseAction:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确认要拒绝该学生的报名吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 1000+sender.tag;
    [alertView show];

    }

#pragma mark 邀约动作
-(void)inviteAction:(UIButton *)sender
{
    YMWaitInviteSummary *info = _dataArr[sender.tag];
    FillWorkTimeViewController *fillTimeVC = [[FillWorkTimeViewController alloc]init];
    fillTimeVC.title = @"填写工作时间";
    fillTimeVC.invitedId = info.id;
    [self.navigationController pushViewController:fillTimeVC animated:YES];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag>=1000)
    {
        if (buttonIndex!=alertView.cancelButtonIndex)
        {
            YMWaitInviteSummary *info = _dataArr[alertView.tag-1000];
            [self.view makeProgress:@"拒绝中..."];
            [YMWebServiceClient refuserStuWithParams:@{@"id":[NSNumber numberWithInt:info.id]} Success:^(YMNomalResponse *response) {
                [self.view hiddenProgress];
                if(response.code==ERROR_OK){
                    self.tabBarController.selectedIndex = 2;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:JumpOrderListNotification object:[NSNumber numberWithInt:0]];
                    [self.view.window makeToast:@"已拒绝"];
                }else{
                    [self handleErrorWithErrorResponse:response];

                }
            }];

        }
    }
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
