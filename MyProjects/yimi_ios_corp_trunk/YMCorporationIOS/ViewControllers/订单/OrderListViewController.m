//
//  ShangGangViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "OrderListViewController.h"
#import "UIView+Hint.h"
#import "MJRefresh.h"
#import "LocalDicDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import "OrderInfoCell.h"
#import "StuInfoCell.h"
#import "StudentResumeViewController.h"
#import "JobDetailViewController.h"
#import "PayViewController.h"
#import "MyConfirmInfoView.h"
#import "PayPassViewController.h"
#import "THOrderListCell.h"
@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    OrderStatus _orderStatus;
    NSInteger _currentPage;
    NSMutableArray *_dataArr;
    int _totalCount;
    BOOL _isNotFirst;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *topSegment;
@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *barItem = self.tabBarController.tabBar.items[2];
    barItem.selectedImage = [[UIImage imageNamed:@"tabbar_shanggang_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_topSegment setTitleTextAttributes:@{NSFontAttributeName:Default_Font_15} forState:UIControlStateNormal];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    self.tableView.frame = CGRectMake(0, _topSegment.height+11, SCREEN_WIDTH, SCREEN_HEIGHT-64.0-_topSegment.height-11-49.0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    _isNotFirst = YES;
    //更新数据通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNotificationAction:) name:JumpOrderListNotification object:nil];
    //请求数据
    [self segmentAction:_topSegment];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:JumpOrderListNotification object:nil];
}

#pragma mark 更新数据通知方法
-(void)updateNotificationAction:(NSNotification *)noti
{
    if (_isNotFirst)
    {
        _topSegment.selectedSegmentIndex = [noti.object intValue];
        [self segmentAction:_topSegment];
    }
}

#pragma mark segmentAction
- (IBAction)segmentAction:(UISegmentedControl *)sender
{
    
    if (sender.selectedSegmentIndex==0)
    {
        _orderStatus = OrderStatusAll;
    }
    else if (sender.selectedSegmentIndex==1)
    {
        _orderStatus = OrderStatusUnCharged;
    }
    else if (sender.selectedSegmentIndex==2)
    {
        _orderStatus = OrderStatusCharged;
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    _currentPage = 1;
    _dataArr = [NSMutableArray array];
    [self.tableView reloadData];
    [self requestWorkOrderListWithType:_orderStatus];
}

#pragma mark 获取订单数据
-(void)requestWorkOrderListWithType:(NSInteger)type
{
    if (_dataArr.count==0)
    {
        [self.tableView showLoadingImageWithStatus:LoadingStatusOnLoading];
    }
    [YMWebServiceClient getWorkOrderListWithParams:@{@"pageNum":[NSNumber numberWithInteger:_currentPage],@"pageSize":[NSNumber numberWithInteger:DATASIZE],@"status":[NSNumber numberWithInteger:type]} Success:^(YMOrderResponse *response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(response.code==ERROR_OK){
        [self.tableView hiddenLoadingView];
            _totalCount = response.data.count;
            [self dealWithBackList:response.data.list];
            [self.tableView reloadData];
        }else{
            self.tableView.mj_header=nil;
            self.tableView.mj_footer=nil;
            _dataArr = [NSMutableArray array];
            [self.tableView reloadData];
            [self handleErrorWithErrorResponse:response];
            __block OrderListViewController *orderVC = self;
            [self.tableView handleReload:^{
                orderVC->_currentPage=1;
                [orderVC requestWorkOrderListWithType:_orderStatus];
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
            if (_topSegment.selectedSegmentIndex==0)
            {
                self.tableView.loadingLabel.text = @"您还没有订单";
            }
            else if (_topSegment.selectedSegmentIndex==1)
            {
                self.tableView.loadingLabel.text = @"您还没有未支付的订单";
            }
            else if (_topSegment.selectedSegmentIndex==2)
            {
                self.tableView.loadingLabel.text = @"您还没有已支付的订单";
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
            __block OrderListViewController *orderVC = self;
            if (!self.tableView.mj_header)
            {
                MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    orderVC->_currentPage = 1;
                    [orderVC requestWorkOrderListWithType:_orderStatus];
                }];
                header.lastUpdatedTimeLabel.hidden = YES;
                self.tableView.mj_header =  header;
            }
            //添加下拉刷新
            if (_totalCount>_dataArr.count)
            {
                if (self.tableView.mj_footer==nil) {
                    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        orderVC->_currentPage+=1;
                        [orderVC requestWorkOrderListWithType:_orderStatus];
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
     YMOrderSummary *info = _dataArr[section];
    if (info.status==1) {
        return 4;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 50.0;
    }
    else if (indexPath.row==1)
    {
        return 90.0;
    }
    else if (indexPath.row==3)
    {
        return 40.0;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     YMOrderSummary *info = _dataArr[indexPath.section];
    if (indexPath.row==0)
    {
        StudentResumeViewController *stuResumeVC = [[StudentResumeViewController alloc]init];
        stuResumeVC.title = @"学生简历";
        stuResumeVC.stuId = info.stuId;
        stuResumeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:stuResumeVC animated:YES];
    }
    else if (indexPath.row==2)
    {
        JobDetailViewController *jobDetailVC = [[JobDetailViewController alloc]init];
        jobDetailVC.title = @"职位详情";
        jobDetailVC.hidesBottomBarWhenPushed = YES;
        jobDetailVC.jobId = info.jobId;
        [self.navigationController pushViewController:jobDetailVC animated:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMOrderSummary *info = _dataArr[indexPath.section];
    if (indexPath.row==0)
    {
        static NSString *identifier = @"StuInfoCell";
        StuInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"StuInfoCell" owner:nil options:nil]lastObject];
        }
        [cell.stuAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,info.photoscale]] placeholderImage:[UIImage imageNamed:@"stu_avatar"]];
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
        static NSString *identifier = @"OrderInfoCell";
        OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderInfoCell" owner:nil options:nil]lastObject];
            
        }
        
        NSString *timeStr = [ProjectUtil changeStandardDateStrWithSp:info.workStartTime];
        cell.dateLabel.text = [timeStr substringToIndex:10];
        cell.weekLabel.text = [ProjectUtil getWeekDayStrWithTimeSp:info.workStartTime];
        cell.timeLabel.text = [[timeStr substringFromIndex:11]substringToIndex:5];
        cell.workTimesLabel.text = [NSString stringWithFormat:@"%g%@",info.workTimes,[ProjectUtil getOrderStatusStrWithStatus:info.workTimesUnit]];
        if (info.status == OrderStatusCharged)
        {
            cell.payMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",info.pay];
            if (info.payType==0)
            {
                cell.statusLabel.text = @"现金支付";
            }
            else if (info.payType==1)
            {
                cell.statusLabel.text = @"在线支付";
            }
            cell.payMoneyLabelTop.constant = 25.0;
        }
        else
        {
            cell.payMoneyLabel.text = @"";
            cell.payMoneyLabelTop.constant = 15.0;
            cell.statusLabel.text = [ProjectUtil getOrderStatusStrWithStatus:info.status];
        }
        if (info.status==3)
        {
            cell.statusLabel.textColor = DefaultGreenTextColor;
        }
        else if (info.status==4)
        {
            cell.statusLabel.textColor = DefaultGrayTextColor;
        }
        else
        {
            cell.statusLabel.textColor = DefaultOrangeTextColor;
        }

        return cell;
    }
    else if (indexPath.row==2)
    {
        static NSString *identifier = @"JobInfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %d%@",info.jobName,info.jobPay,[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:info.jobPayUnit]];
        cell.textLabel.textColor = DefaultGrayTextColor;
        cell.textLabel.font = Default_Font_15;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else
    {
        
        static NSString *identifier = @"ChargeCell";
        THOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"THOrderListCell" owner:nil options:nil]lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        cell.btn_cancel.tag=indexPath.section;
        cell.btn_downBoard.tag=indexPath.section;
        cell.btn_pay.tag=indexPath.section;
        [cell.btn_pay addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_downBoard addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_cancel addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

}
#pragma mark 底部按钮方法
-(void)bottomBtnAction:(UIButton *)sender
{
    YMOrderSummary *info = _dataArr[sender.tag];
    if ([sender.titleLabel.text isEqualToString:@"支付"])
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        PayViewController *payVC = [storyBoard instantiateViewControllerWithIdentifier:@"payVC"];
        payVC.title = @"支付";
        payVC.orderId = info.id;
        payVC.formVcType = FormVCTypeOrderList;
        [payVC handlePayErrorBackHandle:^(int errorCode) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有设置支付密码，将不能进行支付提现等操作！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            [alertView show];
        }];
        NSString *timeStr = [ProjectUtil changeStandardDateStrWithSp:info.workStartTime];
        
        NSString *salaryCountStr = [NSString stringWithFormat:@"%d",info.jobPay];
        
        NSString *salaryStr = [NSString stringWithFormat:@"%@%@",salaryCountStr,[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:info.jobPayUnit]];
        NSMutableAttributedString *salaryAttStr = [[NSMutableAttributedString alloc]initWithString:salaryStr attributes:@{NSFontAttributeName:Default_Font_12,NSForegroundColorAttributeName:DefaultGrayTextColor}];
        [salaryAttStr addAttribute:NSForegroundColorAttributeName value:DefaultOrangeTextColor range:NSMakeRange(0, salaryCountStr.length)];
        
        payVC.payInfoDic = @{@"jobName":info.jobName,@"salary":salaryAttStr,@"address":info.jobAddress,@"stuName":info.stuName,@"time":[NSString stringWithFormat:@"%@ %@",[timeStr substringToIndex:10],[ProjectUtil getWeekDayStrWithTimeSp:info.workStartTime]],@"timeDetail":[[timeStr substringFromIndex:11]substringToIndex:5],@"worktime":[NSString stringWithFormat:@"%g%@",info.workTimes,[ProjectUtil getWorkTimeUnitStrWithUnitId:info.workTimesUnit]]};
        payVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payVC animated:YES];

    }
    else if ([sender.titleLabel.text isEqualToString:@"未上岗"])
    {
        
        MyConfirmInfoView *confirmInfoView = [[MyConfirmInfoView alloc]initWithBound:15.0 Title:@"确认未上岗"];
        [confirmInfoView showFromView:self.view WithContentArr:@[[NSString stringWithFormat:@"职位名称：%@",info.jobName],[NSString stringWithFormat:@"学生姓名：%@",info.stuName],[NSString stringWithFormat:@"工作时间：%@",[ProjectUtil changeToDefaultDateStrWithSp:info.workStartTime]],[NSString stringWithFormat:@"工作时长：%@",[NSString stringWithFormat:@"%g%@",info.workTimes,[ProjectUtil getWorkTimeUnitStrWithUnitId:info.workTimesUnit]]]]];
        [confirmInfoView handleWithCancel:nil Affirm:^{
            
            [self.view makeProgress:@"确认中..."];
            [YMWebServiceClient markUnWorkOrderWithParams:@{@"id":[NSNumber numberWithInt:info.id]} Success:^(YMNomalResponse *response) {
                [self.view hiddenProgress];
                if(response.code==ERROR_OK){
                _topSegment.selectedSegmentIndex = 0;
                    [self segmentAction:_topSegment];
                    [self.view makeToast:@"确认未上岗成功"];
                }else{
                    [self handleErrorWithErrorResponse:response];
                }
            }];

        }];
        
    }
    else if ([sender.titleLabel.text isEqualToString:@"取消"])
    {
        MyConfirmInfoView *confirmInfoView = [[MyConfirmInfoView alloc]initWithBound:15.0 Title:@"确认取消订单"];
        [confirmInfoView showFromView:self.view WithContentArr:@[[NSString stringWithFormat:@"职位名称：%@",info.jobName],[NSString stringWithFormat:@"学生姓名：%@",info.stuName],[NSString stringWithFormat:@"工作时间：%@",[ProjectUtil changeToDefaultDateStrWithSp:info.workStartTime]],[NSString stringWithFormat:@"工作时长：%@",[NSString stringWithFormat:@"%g%@",info.workTimes,[ProjectUtil getWorkTimeUnitStrWithUnitId:info.workTimesUnit]]]]];
        [confirmInfoView handleWithCancel:nil Affirm:^{
          
            [self.view makeProgress:@"取消中..."];
            [YMWebServiceClient cancelOrderWithParams:@{@"id":[NSNumber numberWithInt:info.id]} Success:^(YMNomalResponse *response) {
                [self.view hiddenProgress];
                if(response.code==ERROR_OK){
                    _topSegment.selectedSegmentIndex = 0;
                    [self segmentAction:_topSegment];
                    [self.view makeToast:@"您已成功取消该订单"];
                }else{
                    [self handleErrorWithErrorResponse:response];

                }
            }];

        }];
    }
}

#pragma mark 拨打电话按钮
-(void)callBtnAction:(UIButton *)sender
{
    [ProjectUtil showLog:@"%d",sender.tag];
    YMOrderSummary *info = _dataArr[sender.tag];
    [self callWithPhoneNum:info.stuPhone];
}

#pragma mark alertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex)
    {
        PayPassViewController *payPassVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WithdrawPassVC"];
        payPassVC.hidesBottomBarWhenPushed = YES;
        payPassVC.isSet = NO;
        [self.navigationController pushViewController:payPassVC animated:YES];
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
