//
//  NotiViewController.m
//  MyCloud
//
//  Created by test on 15/7/26.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "NotiViewController.h"
#import "UIView+Hint.h"
#import "UserInfo.h"
#import <MJRefresh.h>
#import "NotiCell.h"
#import "NotiDetailViewController.h"

@interface NotiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currentPage;
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
     [self layoutSubViews];
    [self.view addSubview:self.tableView];
    //请求充通知列表
    _currentPage = 1;
    [self requestDataList];
}

-(void)requestDataList
{
    WebClient *webClient = [WebClient shareClient];
    if (_currentPage==1)
    {
        [_tableView showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载通知..."];
    }
    UserInfo *loginInfo = [ProjectUtil getCustomObjFromUserDefaultsWithKey:@"login"];
    [webClient getNoticeListWithParameters:@{@"UserId":loginInfo.uid,@"Status":@"",@"sText":@"",@"pageIndex":[NSString stringWithFormat:@"%ld",(long)_currentPage],@"pageSize":[NSString stringWithFormat:@"%d",DATASIZE]} Success:^(id data) {
        [_tableView hiddenLoadingView];
        if ([data[@"code"] intValue]==0)
        {
            NSArray *resultArr = data[@"result"];
            
            if (resultArr.count==0)
            {
                if (_currentPage==1)
                {
                    [_tableView showLoadingImageWithStatus:LoadingStatusNoData StatusStr:@"您还没有任何通知信息!"];
                }
                else
                {
                    _tableView.footer = nil;
                    [self.view makeToast:@"已没有更多通知！"];
                }
            }
            else
            {
                if (_currentPage==1)
                {
                    _dataArr = [NSMutableArray arrayWithArray:resultArr];
                    __block NotiViewController *blockVC = self;
                    //添加上拉刷新
                    if (!_tableView.header)
                    {
                        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                            blockVC->_currentPage = 1;
                            [blockVC requestDataList];
                        }];
                        header.lastUpdatedTimeLabel.hidden = YES;
                        _tableView.header =  header;
                    }
                    //添加下拉刷新
                    if (resultArr.count==DATASIZE)
                    {
                        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            blockVC->_currentPage+=1;
                            [blockVC requestDataList];
                        }];
                        _tableView.footer = footer;
                    }
                    else
                    {
                        _tableView.footer=nil;
                    }
                }
                else
                {
                    [_dataArr addObjectsFromArray:resultArr];
                    if (resultArr.count<DATASIZE)
                    {
                        _tableView.footer = nil;
                    }
                }
            }
            [_tableView.header endRefreshing];
            [_tableView.footer endRefreshing];
            [_tableView reloadData];
        }
        else
        {
            [self.view makeToast:data[@"message"]];
        }

    } Fail:^(NSError *error) {
        [_tableView hiddenLoadingView];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        _tableView.header=nil;
        _tableView.footer=nil;
        _dataArr = [NSMutableArray array];
        [_tableView reloadData];
        [_tableView showLoadingImageWithStatus:LoadingStatusNetError StatusStr:HintWithNetError];
    }];
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
    NSDictionary *dataDic = _dataArr[indexPath.row];
    cell.contentLabel.text = dataDic[@"content"];
    cell.titleLabel.text = dataDic[@"title"];
    cell.timeLabel.text = [dataDic[@"times"] substringToIndex:8];
    if ([dataDic[@"attachs"]intValue]==0)
    {
        cell.attachImageView.hidden = YES;
    }
    else
    {
        cell.attachImageView.hidden = NO;
       
    }
    if ([dataDic[@"status"]intValue]!=0)
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
    NSDictionary *notiDic = _dataArr[indexPath.row];
    WebClient *webClient = [WebClient shareClient];
    if ([notiDic[@"status"]intValue]==0)
    {
        [webClient checkNoticeWithParameters:@{@"LzId":notiDic[@"lzid"]} Success:^(id data) {
            if ([data[@"code"]intValue]==0)
            {
                [_tableView.header beginRefreshing];
                [[NSNotificationCenter defaultCenter]postNotificationName:HomeUpdataUINotification object:nil];
            }
            
        } Fail:^(NSError *error) {
            
        }];
    }
    
    NotiDetailViewController *jumpVC = [[NotiDetailViewController alloc]init];
    jumpVC.title = @"通知详情";
    [jumpVC creatBackButtonWithPushType:Push];
    jumpVC.notiId = notiDic[@"id"];
    BOOL hasAttach = NO;
    if ([notiDic[@"attachs"]intValue]>0)
    {
        hasAttach = YES;
    }
    jumpVC.hasAttach = hasAttach;
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
