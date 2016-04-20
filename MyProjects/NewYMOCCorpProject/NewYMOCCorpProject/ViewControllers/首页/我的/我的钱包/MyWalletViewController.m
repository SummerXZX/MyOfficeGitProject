//
//  MyWalletViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/5.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "MyWalletViewController.h"
#import "ReChargeViewController.h"
#import "MyWalletCell.h"
#import <MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "EmptyViewFactory.h"

typedef enum : NSUInteger {
    MyWalletTypeIncome=1,///<收入
    MyWalletTypePay=2,///<支出
} MyWalletType;

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MyWalletType _walletType;//当前账单类型
    NSMutableArray* _dataArr; //数据数组
    NSInteger _currentPage; //当前数据页码
    NSInteger _totalCount; //数据总数
}
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;//余额label
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation MyWalletViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)layoutSubViews {
    [ProjectUtil insertOrangeGradientBackColorWithLayer:_topBackView.layer Frame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    
    //请求余额
    [self checkBalance];
    
    self.tableView.top = 290.0;
    self.tableView.height = SCREEN_HEIGHT-290.0;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
  
    [self.view addSubview:self.tableView];
    
    _currentPage =1;
    _walletType = MyWalletTypeIncome;
    //获取账单
    [self getBillList];
}

#pragma mark 请求余额
-(void)checkBalance {
    [YMWebClient checkBalanceWithSuccess:^(YMNomalResponse *response) {
        if (response.code==ERROR_OK) {
            
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"当前余额（元）\n" attributes:@{NSFontAttributeName:BOLDFONT(12)}];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[response.data doubleValue]] attributes:@{NSFontAttributeName:BOLDFONT(18)}]];
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr.length)];
            _balanceLabel.attributedText = attStr;
        }
        else {
            [self handleErrorWithErrorResponse:response ShowHint:NO];
        }
    }];
}
#pragma mark 获取账单
-(void)getBillList {
    if (_dataArr.count==0) {
        [self.view showProgressHintWith:@"加载中"];
    }
    [YMWebClient getBillRecordWithParams:@{@"pageSize":@(DATASIZE),@"pageNum":@(_currentPage),@"type":@(_walletType)} Success:^(YMBillListResponse *response) {
        
        [self.view dismissProgress];
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (response.data.list == nil) {
            self.tableView.mj_header = nil;
            self.tableView.mj_footer = nil;
            _dataArr = nil;
            if (response.code==ERROR_UNAUTHORIZED|response.code==ERROR_EXPIRED_TOKEN|response.code==ERROR_INVALID_TOKEN) {
                [self handleErrorWithErrorResponse:response ShowHint:NO];
            }
            else {
                
                MyWalletViewController *__weak weakVC = self;
                [EmptyViewFactory errorNetwork:self.tableView btnBlock:^{
                    MyWalletViewController *__block blockVC = weakVC;
                    blockVC -> _currentPage = 1;
                    [weakVC getBillList];
                }];
            }
            [self.tableView reloadData];
        }
        else {
            _totalCount = response.data.count;
            [self dealWithBackList:response.data.list];
            [self.tableView reloadData];
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
            NSString *text;
            if (_walletType==MyWalletTypeIncome) {
                text = @"您还没任何收入记录哦！";
            }
            else if (_walletType==MyWalletTypePay) {
                text = @"您还没任何支出记录哦！";
            }
            [EmptyViewFactory errorNoData:self.tableView WithImageName:@"wdqb_wjl" Title:text];
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
            MyWalletViewController*__weak weakVC = self;
            if (!self.tableView.mj_header) {
                
                MyRefreshHeader* header = [MyRefreshHeader headerWithRefreshingBlock:^{
                    MyWalletViewController *blockVC = weakVC;
                    blockVC->_currentPage = 1;
                    [blockVC getBillList];
                }];
                self.tableView.mj_header = header;
            }
            //添加上拉加载
            if (_totalCount >= _dataArr.count) {
                if (!self.tableView.mj_footer) {
                    self.tableView.mj_insetB = 0.0;
                    
                    MyRefreshFooter* footer = [MyRefreshFooter footerWithRefreshingBlock:^{
                        MyWalletViewController *blockVC = weakVC;
                        blockVC->_currentPage++;
                        [blockVC getBillList];
                    }];
                    if (_walletType==MyWalletTypeIncome) {
                        footer.noMoreDataStr = @"已没有更多收入记录";
                    }
                    else if (_walletType==MyWalletTypePay) {
                        footer.noMoreDataStr = @"已没有更多支出记录";
                    }
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


- (IBAction)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rechargeAction {
    ReChargeViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReChargeViewController"];
    nextVC.title = @"充值";
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

- (IBAction)switchBtnAction:(UISegmentedControl *)sender {
    _dataArr = [NSMutableArray array];
    _walletType = (MyWalletType)sender.selectedSegmentIndex+1;
    _currentPage = 1;
    [self getBillList];
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
   static NSString *idenfier = @"MyWalletCell";
    MyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyWalletCell" owner:nil options:nil]lastObject];
    }
    
    YMBillInfo *info = _dataArr[indexPath.row];
    
    if (_walletType==MyWalletTypeIncome) {
        cell.typeImageView.image = [UIImage imageNamed:@"wdqb_sr"];
        cell.moneyLabel.text = [NSString stringWithFormat:@"+%.2f元",info.amount];
    }
    else if (_walletType==MyWalletTypePay) {
        cell.typeImageView.image = [UIImage imageNamed:@"wdqb_zc"];
        cell.moneyLabel.text = [NSString stringWithFormat:@"-%.2f元",info.amount];

    }
    cell.titleLabel.text = info.name;
    cell.timeLabel.text = [ProjectUtil changeToDateWithSp:info.time Format:@"yyyy年MM月dd日 HH:mm"];
    return cell;
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
