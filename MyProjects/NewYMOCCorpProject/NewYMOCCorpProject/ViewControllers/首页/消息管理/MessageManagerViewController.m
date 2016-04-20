//
//  MessageManagerViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/15.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "MessageManagerViewController.h"
#import "NewsInfoCell.h"
#import "EmptyViewFactory.h"
#import <MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "AppDelegate.h"

@interface MessageManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray* _dataArr; //数据数组
    NSInteger _currentPage; //当前数据页码
    NSInteger _totalCount; //数据总数
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation MessageManagerViewController

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeNomal];
        _tableView.height = SCREEN_HEIGHT-64.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"NewsInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NewsInfoCellIdentifier];
    }
    return _tableView;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    [self.view addSubview:self.tableView];
    _currentPage = 1;
    //获取消息数据
    [self getNewsList];
}

#pragma mark 获取消息数据
-(void)getNewsList{
    if (_dataArr.count == 0) {
        [self.view showProgressHintWith:@"加载中"];
    }
    [YMWebClient getNewsListWithParams:@{@"isRead":@1,@"pageNum":@(_currentPage),@"pageSize":@(DATASIZE)} Success:^(YMNewsListResponse *response) {
        [self.view dismissProgress];
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (response.code == ERROR_OK) {
            _totalCount = response.data.count;
            [self dealWithBackList:response.data.list];
        }
        else {
            self.tableView.mj_header = nil;
            self.tableView.mj_footer = nil;
            _dataArr = [NSMutableArray array];
            __weak typeof(self) weakVC = self;
            [EmptyViewFactory errorNetwork:self.tableView btnBlock:^{
                typeof(self) blockVC = weakVC;
                blockVC->_currentPage = 1;
                [blockVC getNewsList];
            }];
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
            [EmptyViewFactory errorNoData:self.tableView WithImageName:@"sy_wxx" Title:@"您还没有任何消息"];
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
                MyRefreshHeader* header =
                [MyRefreshHeader headerWithRefreshingBlock:^{
                    typeof(self) blockVC = weakVC;
                    blockVC->_currentPage = 1;
                    [blockVC getNewsList];
                }];
                
                self.tableView.mj_header = header;
            }
            //添加上拉加载
            if (_totalCount >= _dataArr.count) {
                if (!self.tableView.mj_footer) {
                    self.tableView.mj_insetB = 0.0;
                    MyRefreshFooter* footer = [MyRefreshFooter footerWithRefreshingBlock:^{
                        typeof(self) blockVC = weakVC;
                        blockVC->_currentPage++;
                        [blockVC getNewsList];
                    }];
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
            NSMutableArray* tempArr = [NSMutableArray arrayWithArray:list];
            for (YMJobInfo* info in list) {
                if ([_dataArr containsObject:info]) {
                    [tempArr removeObject:info];
                }
            }
            [_dataArr addObjectsFromArray:tempArr];
            if (_totalCount <= _dataArr.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsInfoCellIdentifier];
    YMNewsInfo *info = _dataArr[indexPath.row];
    NSString *imageName;
    if (info.type==1) {
        imageName = @"xx_ywtz";
    }
    else if (info.type==4) {
        imageName = @"xx_yhdj";
    }
    else {
        imageName = @"xx_txtz";
    }
    cell.isReadImageView.hidden = info.isRead;
    cell.typeImageView.image = [UIImage imageNamed:imageName];
    cell.titleLabel.text = info.title;
    cell.contentLabel.text = info.content;
    cell.timeLabel.text = [ProjectUtil changeToDateWithSp:info.createTime Format:@"yyyy.MM.dd"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMNewsInfo *info = _dataArr[indexPath.row];
    _selectedIndex = indexPath.row;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:info.title message:info.content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
    [alertView show];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex!=buttonIndex) {
        //标记已读未读
        YMNewsInfo *info = _dataArr[_selectedIndex];
        
        [YMWebClient markerNewIsReadWithParams:@{@"pushId":@(info.pushId),@"isRead":@(info.isRead)} Success:^(YMNomalResponse *response) {
            if (response.code==ERROR_OK) {
                //更新数据
                _currentPage = 1;
                [self getNewsList];
            }
        }];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate dealWithUrl:info.action];
    }
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
