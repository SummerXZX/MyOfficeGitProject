//
//  ChargeRecordViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/7/15.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "RechargeRecordViewController.h"
#import "UIView+Hint.h"
#import "MJRefresh.h"
#import "RecordCell.h"
#import <AlipaySDK/AlipaySDK.h>

@interface RechargeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currentPage;
    NSMutableArray *_dataArr;
    int _totalCount;
}


@end

@implementation RechargeRecordViewController


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
    [self requestRechargeRecordList];
    
    //支付成功后的更新数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chargeSuccessNotification) name:ChargeSuccessNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ChargeSuccessNotification object:nil];
}

#pragma mark 通知更新数据
-(void)chargeSuccessNotification
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 请求充值记录
-(void)requestRechargeRecordList
{
    if (_dataArr.count==0)
    {
        [self.tableView showLoadingImageWithStatus:LoadingStatusOnLoading];
    }
    [YMWebServiceClient getRechargeRecordWithParams:@{@"pageNum":[NSNumber numberWithInteger:_currentPage],@"pageSize":[NSNumber numberWithInteger:DATASIZE]} Success:^(YMRechargeReponse *response) {
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
            [self handleErrorWithErrorResponse:response];
            __block RechargeRecordViewController *rechargeRecordVC = self;
            [self.tableView handleReload:^{
                rechargeRecordVC->_currentPage=1;
                [rechargeRecordVC requestRechargeRecordList];
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
            self.tableView.loadingLabel.text = @"您还有充过值哦";
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
            __block RechargeRecordViewController *rechargeRecordVC = self;
            if (!self.tableView.mj_header)
            {
                MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    rechargeRecordVC->_currentPage = 1;
                    [rechargeRecordVC requestRechargeRecordList];
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
                        rechargeRecordVC->_currentPage+=1;
                        [rechargeRecordVC requestRechargeRecordList];
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
    YMRechargeSummary *info = _dataArr[section];
    if (info.status==0)
    {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1)
    {
        return 40.0;
    }
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
    YMRechargeSummary *info = _dataArr[indexPath.section];
    if (indexPath.row==0)
    {
        static NSString *identifier = @"RecordCell";
        RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RecordCell" owner:nil options:nil]lastObject];
        }
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@元",info.amount];
        cell.timeLabel.text = [ProjectUtil changeStandardDateStrWithSp:info.creatTime];
        cell.statusLabel.text = [ProjectUtil getRechargeStatusStrWithStatus:info.status];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NSString *identifier = @"ChargeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            NSArray *btnTitleArr = @[@"继续充值"];
            int btnCount = 1;
            CGFloat btnWidth = 80.0;
            CGFloat btnHeight = 30.0;
            for (NSString *str in btnTitleArr)
            {
                UIButton *btn = [self getBottomBtnWithFrame:CGRectMake(SCREEN_WIDTH-10-(btnWidth+5)*btnCount, 5, btnWidth, btnHeight) Title:str];
                btn.tag = indexPath.section;
                [cell.contentView addSubview:btn];
                btnCount++;
            }
        }
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                view.tag = indexPath.section;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark 创建底部按钮
-(UIButton *)getBottomBtnWithFrame:(CGRect)frame Title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = Default_Font_15;
    btn.backgroundColor = RGBCOLOR(255, 102, 51);
    btn.layer.cornerRadius = 2.0;
    [btn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark 底部按钮方法
-(void)bottomBtnAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"继续充值"])
    {
        YMRechargeSummary *info = _dataArr[sender.tag];
        [self.view makeProgress:@"充值中..."];
        [YMWebServiceClient rechargeRecordChargeWithParams:@{@"id":[NSNumber numberWithInt:info.id]} Success:^(YMNomalResponse *response) {
            [self.view hiddenProgress];
            
            if(response.code==ERROR_OK){
                [[AlipaySDK defaultService] payOrder:response.data fromScheme:@"YMCorporationIOSPay" callback:^(NSDictionary *resultDic) {
                }];
            }else{
                [self handleErrorWithErrorResponse:response];
            }
        }];
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
