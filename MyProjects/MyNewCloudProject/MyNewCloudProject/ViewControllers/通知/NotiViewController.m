//
//  NotiViewController.m
//  MyCloud
//
//  Created by test on 15/7/26.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "NotiViewController.h"
#import "UIView+Hint.h"
#import <MJRefresh.h>
#import "NotiCell.h"
#import "NotiDetailViewController.h"

@interface NotiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currentPage; //当前数据页码
    NSInteger _totalCount; //数据总数
    
    NSMutableArray *_dataArr;
}

@property (nonatomic,strong)UITableView *tableView;


@end

@implementation NotiViewController

#pragma mark tableView
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = DefaultBackGroundColor;
        _tableView.separatorColor = DefaultBackGroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            _tableView.layoutMargins = UIEdgeInsetsZero;
        }
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            _tableView.separatorInset = UIEdgeInsetsZero;
        }
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self.view addSubview:self.tableView];
    //请求充通知列表
    _currentPage = 1;
    [self requestDataList];
}

-(void)requestDataList
{
    if (!self.tableView.mj_header.isRefreshing) {
        [_tableView showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载通知..."];
    }
    [WebClient getNoticeListWithParams:@{@"userCode":[ProjectUtil getLoginUserCode],@"pageNum":@(_currentPage),@"pageSize":@(DATASIZE)} Success:^(WebNoticeListResponse *response) {
        [_tableView hiddenLoadingView];
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (response.code==ResponseCodeSuceess) {
            _totalCount = response.data.count;
            [self dealWithBackList:response.data.list];
            [_tableView reloadData];
        }
        else {
            self.tableView.mj_footer = nil;
            self.tableView.mj_header = nil;
            _dataArr = [NSMutableArray array];
            [_tableView reloadData];
            [_tableView showLoadingImageWithStatus:LoadingStatusNetError StatusStr:response.codeInfo];
        }
    }];
}

#pragma mark 处理返回列表数据
- (void)dealWithBackList:(NSArray*)list
{
    if (list.count == 0) {
        if (_currentPage == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            _dataArr = [NSMutableArray array];
            [_tableView showLoadingImageWithStatus:LoadingStatusNoData StatusStr:@"您还没有任何通知信息"];
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
            __weak typeof(self) weakVC = self;
            if (!self.tableView.mj_header) {
                MJRefreshNormalHeader* header =
                [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    typeof(self) blockVC = weakVC;
                    blockVC->_currentPage = 1;
                    [blockVC requestDataList];
                }];
                
                self.tableView.mj_header = header;
            }
            //添加上拉加载
            if (_totalCount >= _dataArr.count) {
                if (!self.tableView.mj_footer) {
                    self.tableView.mj_insetB = 0.0;
                    MJRefreshAutoNormalFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        typeof(self) blockVC = weakVC;
                        blockVC->_currentPage++;
                        [blockVC requestDataList];
                    }];
                    [footer setTitle:@"已没有更多通知" forState:MJRefreshStateNoMoreData];

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


#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NotiCell";
    NotiCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NotiCell" owner:nil options:nil]lastObject];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    WebNoticeInfo *info = _dataArr[indexPath.row];
    cell.contentLabel.text = info.send_userName;
    cell.titleLabel.text = info.notice_title;
    cell.timeLabel.text = [info.create_time substringToIndex:10];
    cell.attachImageView.hidden = !info.if_havePic;
    if (info.if_read)
    {
        cell.statusView.backgroundColor = DefaultStatusGrayColor;
         cell.attachImageView.image = [UIImage imageNamed:@"attach_check"];
    }
    else
    {
        cell.statusView.backgroundColor = DefaultStatusBlueColor;
         cell.attachImageView.image = [UIImage imageNamed:@"attach"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebNoticeInfo *info = _dataArr[indexPath.row];
//    NSDictionary *notiDic = _dataArr[indexPath.row];
//    WebClient *webClient = [WebClient shareClient];
//    if ([notiDic[@"status"]intValue]==0)
//    {
//        [webClient checkNoticeWithParameters:@{@"LzId":notiDic[@"lzid"]} Success:^(id data) {
//            if ([data[@"code"]intValue]==0)
//            {
//                [_tableView.header beginRefreshing];
//                [[NSNotificationCenter defaultCenter]postNotificationName:HomeUpdataUINotification object:nil];
//            }
//            
//        } Fail:^(NSError *error) {
//            
//        }];
//    }
//    
    NotiDetailViewController *jumpVC = [[NotiDetailViewController alloc]init];
    jumpVC.title = @"通知详情";
    jumpVC.if_havePic = info.if_havePic;
    jumpVC.notice_code = info.notice_code;
    [self.navigationController pushViewController:jumpVC animated:YES];
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
