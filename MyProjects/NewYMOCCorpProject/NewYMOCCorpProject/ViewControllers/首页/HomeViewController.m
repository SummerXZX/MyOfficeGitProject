//
//  ViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 15/12/31.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "HomeViewController.h"
#import <UIImageView+WebCache.h>
#import "MyViewController.h"
#import "ApplyForAuthenticateViewController.h"
#import "PostJobViewController.h"
#import "JobsManagerViewController.h"
#import "PostJobViewController.h"
#import "MessageManagerViewController.h"
#import "CityDataBaseManager.h"
#import "EmptyViewFactory.h"
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "AppDelegate.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray* _dataArr; //数据数组
    NSInteger _currentPage; //当前数据页码
    NSInteger _totalCount; //数据总数
    NSInteger _selectedIndex;
}
@property (weak, nonatomic) IBOutlet UIView *topBackView;//头部背景view
@property (weak, nonatomic) IBOutlet UIImageView *corpLogoImageView;//公司头像
@property (weak, nonatomic) IBOutlet UILabel *corpNameLabel;//公司名字label
@property (weak, nonatomic) IBOutlet UIButton *isCheckBtn;

@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *identifierBtnHeightConstraint;

@end

@implementation HomeViewController

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeNomal];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
    _corpNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH-145;
    _corpNameLabel.text = loginInfo.name.length==0?@"您还没有填写商家名称":loginInfo.name;
    
    //获取是否认证
    [self resetIdentifeirBtnWithStatus:loginInfo.checkStatus];
    
    [_corpLogoImageView sd_setImageWithURL:[NSURL URLWithString:[ProjectUtil getWholeImageUrlWithResponseUrl:loginInfo.logo]] placeholderImage:[UIImage imageNamed:@"sy_sj"]];
}

-(void)layoutSubViews {
    
    //添加渐变背景
    [ProjectUtil insertOrangeGradientBackColorWithLayer:_topBackView.layer Frame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    
    self.tableView.top = 260;
    self.tableView.height = SCREEN_HEIGHT-260;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    [YMWebClient getNewsListWithParams:@{@"isRead":@0,@"pageNum":@(_currentPage),@"pageSize":@(DATASIZE)} Success:^(YMNewsListResponse *response) {
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

#pragma mark 设置认证按钮
-(void)resetIdentifeirBtnWithStatus:(NSInteger)status {
    //判断是否认证
    if (status==2) {
        _isCheckBtn.selected = YES;
        _isCheckBtn.backgroundColor = [UIColor clearColor];
        _isCheckBtn.userInteractionEnabled = NO;
        _identifierBtnHeightConstraint.constant = 40.0;
    }
    else {
        //查询是否认证接口
        [YMWebClient getCheckStatusSuccess:^(YMNomalResponse *response) {
            if (response.code==ERROR_OK) {
                YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
                loginInfo.checkStatus = [response.data integerValue];
                if (loginInfo.checkStatus==2) {
                    [self resetIdentifeirBtnWithStatus:loginInfo.checkStatus];
                }
                else if (loginInfo.checkStatus==1) {
                    [_isCheckBtn setTitle:@"申请认证" forState:UIControlStateNormal];
                }
                else if (loginInfo.checkStatus==3) {
                    [_isCheckBtn setTitle:@"认证失败" forState:UIControlStateNormal];
                }
                else if (loginInfo.checkStatus==4) {
                    [_isCheckBtn setTitle:@"认证中" forState:UIControlStateNormal];
                }
                [ProjectUtil saveLoginInfo:loginInfo];
            }
            else {
                [self handleErrorWithErrorResponse:response ShowHint:NO];
            }

        }];
    }

}

#pragma mark 跳转我的
-(IBAction)jumpToMyAction {
    MyViewController *nextVC = [[MyViewController alloc]init];
    nextVC.title = @"我的";
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark 申请认证页面
- (IBAction)applyIdentifier {
    ApplyForAuthenticateViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ApplyForAuthenticateViewController"];
    nextVC.title = @"申请认证";
    [self.navigationController pushViewController:nextVC animated:YES];

}

#pragma mark 发布职位
- (IBAction)postJobAction {
    PostJobViewController *nextVC = [[PostJobViewController alloc]init];
    nextVC.title = @"发布职位";
    [self.navigationController pushViewController:nextVC animated:YES];

}

#pragma mark 跳转职位管理
- (IBAction)jobManagerAction {
    JobsManagerViewController *nextVC = [[JobsManagerViewController alloc]init];
    nextVC.title = @"职位管理";
    YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
    if (loginInfo.checkStatus==2) {
        nextVC.cellType = JobManagerListCellTypeRecruiting;
    }
    else {
        nextVC.cellType = JobManagerListCellTypeChecking;
    }
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark 消息管理
- (IBAction)messageManagerAction {
    MessageManagerViewController *nextVC = [[MessageManagerViewController alloc]init];
    nextVC.title = @"消息管理";
    [self.navigationController pushViewController:nextVC animated:YES];
       
}


#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifier = @"Header";
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identifier];
        headerView.textLabel.font = FONT(15);
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 34.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = DefaultBackGroundColor;
        [headerView addSubview:lineView];
    }
    headerView.textLabel.text = @"待办事宜";
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    YMNewsInfo *info = _dataArr[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.imageView.image = [UIImage imageNamed:@"sy_d"];
        cell.textLabel.font = FONT(13);
    }
    cell.textLabel.text = info.content;
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

@end
