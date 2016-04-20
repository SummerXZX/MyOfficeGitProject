//
//  JobsManagerViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/15.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "JobsManagerViewController.h"
#import <MJRefresh.h>
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import <UIImageView+WebCache.h>
#import "LocalDicDataBaseManager.h"
#import "CityDataBaseManager.h"
#import "PostJobViewController.h"
#import "ReportManagerViewController.h"
#import "EmptyViewFactory.h"

@interface JobsManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _dataArr; //数据数组
    NSInteger _currentPage; //当前数据页码
    NSInteger _totalCount; //数据总数
}
@property (strong, nonatomic) UIView* lineView; //按钮底部线
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JobsManagerViewController

#pragma mark lineView
-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH/3.0, 2)];
        _lineView.backgroundColor = HEXCOLOR(0x068411);
    }
    return _lineView;
}
#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeNomal];
        _tableView.top = 41.0;
        _tableView.height = SCREEN_HEIGHT-41.0-64.0;
        _tableView.delegate =self;
        _tableView.dataSource = self;
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}


-(void)layoutSubViews {
    //设置已选中的按钮的tag
    
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.tableView];
    //选中按钮并请求数据
    if (_cellType==JobManagerListCellTypeChecking) {
        _currentPage = 1;
        [self getJobListWithIsUpdate:NO];
    }
    else {
        NSInteger selectedBtnTag = _cellType;
        _cellType = JobManagerListCellTypeChecking;
        [self topBtnAction:[self.view viewWithTag:selectedBtnTag]];
    }
    
}

#pragma mark 顶部按钮方法
- (IBAction)topBtnAction:(UIButton *)sender {
    if (sender.tag!=_cellType) {
        //获取上一个选中的按钮，将其设置为为选中的状态
        UIButton *lastSelectedBtn = (UIButton *)[self.view viewWithTag:_cellType];
        lastSelectedBtn.selected = NO;
        //改变当前选中按钮的状态,并给_selectedBtnTag赋值
        sender.selected = !sender.selected;
        _cellType = sender.tag;
        
        JobsManagerViewController*__weak weakVC = self;
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     weakVC.lineView.left = sender.left;
                                 }];
        _dataArr = [NSMutableArray array];
        _currentPage = 1;
        [self getJobListWithIsUpdate:NO];
    }
    
}

#pragma mark 获取职位列表
-(void)getJobListWithIsUpdate:(BOOL)isUpdate {
    if (_dataArr.count==0) {
        [self.view showProgressHintWith:@"加载中"];
    }
    [YMWebClient getJobListWithParams:@{@"pageSize":@(DATASIZE),@"pageNum":@(_currentPage),@"type":@(_cellType-99)} Success:^(YMJobListResponse *response) {
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
                JobsManagerViewController *__weak weakVC = self;
                [EmptyViewFactory errorNetwork:self.tableView btnBlock:^{
                    JobsManagerViewController *__block blockVC = weakVC;
                    blockVC -> _currentPage = 1;
                    [weakVC getJobListWithIsUpdate:NO];
                }];
            }
            
        }
        else {
            if (isUpdate) {
                NSInteger count = 0;
                for (YMJobListInfo *info in response.data.list) {
                    [_dataArr replaceObjectAtIndex:(_currentPage-1)*DATASIZE+count withObject:info];
                    count++;
                }
            }
            else {
                _totalCount = response.data.count;
                [self dealWithBackList:response.data.list];
            }
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
            NSString *text;
            if (_cellType==JobManagerListCellTypeChecking) {
                text = @"您还没任何审核中的职位";
            }
            else if (_cellType==JobManagerListCellTypeRecruiting) {
                text = @"您还没任何招聘中的职位";
            }
            else if (_cellType==JobManagerListCellTypeEnd) {
                text = @"您还没任何已结束的职位";
            }
            [EmptyViewFactory errorNoData:self.tableView WithImageName:@"zwgl_wlr" Title:text];
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
            JobsManagerViewController*__weak weakVC = self;
            if (!self.tableView.mj_header) {
                
                MyRefreshHeader* header = [MyRefreshHeader headerWithRefreshingBlock:^{
                    JobsManagerViewController *blockVC = weakVC;
                    blockVC->_currentPage = 1;
                    [blockVC getJobListWithIsUpdate:NO];
                }];
                self.tableView.mj_header = header;
            }
            //添加上拉加载
            if (_totalCount >= _dataArr.count) {
                if (!self.tableView.mj_footer) {
                    self.tableView.mj_insetB = 0.0;
                    
                    MyRefreshFooter* footer = [MyRefreshFooter footerWithRefreshingBlock:^{
                        JobsManagerViewController *blockVC = weakVC;
                        blockVC->_currentPage++;
                        [blockVC getJobListWithIsUpdate:NO];
                    }];
                    footer.noMoreDataStr = @"已没有更多职位信息";
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


#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_cellType==JobManagerListCellTypeEnd&&section!=0) {
        
        return 10.0;
    }
    return 0.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellType==JobManagerListCellTypeEnd) {
        return 100.0;
    }
    return 70.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JobManagerListCell *cell = [tableView dequeueReusableCellWithIdentifier:[JobManagerListCell getReuserIdentifierWithType:_cellType]];
    if (cell==nil) {
        cell = [[JobManagerListCell alloc]initWithType:_cellType];
        cell.jobTypeLogoImageView.userInteractionEnabled = YES;
        [cell.jobTypeLogoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToJobDetail:)]];
        if (_cellType==JobManagerListCellTypeRecruiting) {
            [cell.stopBtn addTarget:self action:@selector(stopJobBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    cell.stopBtn.tag = indexPath.row;
    cell.jobTypeLogoImageView.tag = indexPath.section;
    YMJobListInfo *info = _dataArr[indexPath.section];
    [cell.jobTypeLogoImageView sd_setImageWithURL:[NSURL URLWithString:[ProjectUtil getWholeImageUrlWithResponseUrl:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobTypeLogo VersionId:info.jobtypeId]]]];
    
    NSMutableAttributedString *jobInfoAttStr = [[NSMutableAttributedString alloc]init];
    [jobInfoAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:info.name attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:[UIColor blackColor]}]];
    [jobInfoAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"       %g",info.pay] attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:DefaultOrangeColor}]];
    [jobInfoAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobPayUnit VersionId:info.payUnit] attributes:@{NSFontAttributeName:FONT(11),NSForegroundColorAttributeName:[UIColor blackColor]}]];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:@[@{@"image":@"zwgl_dd",@"title":[NSString stringWithFormat:@" %@  ",info.areaId==0?@"就近安排":[CityDataBaseManager getCityNameWithType:CityTypeCounty CityId:info.areaId]]},
                        @{@"image":@"zwgl_sj",@"title":[NSString stringWithFormat:@" %@ ",[ProjectUtil changeToDateWithSp:info.creatTime Format:@"MM-dd"]]}
                                                               ]];
        if (_cellType==JobManagerListCellTypeEnd) {
            cell.statLabel.text = [NSString stringWithFormat:@"共计：上岗%ld次 支出工资：%g元",(long)info.workNum,info.totalPay];
        }
        if (_cellType != JobManagerListCellTypeChecking) {
            [dataArr insertObject:@{@"image":@"zwgl_rs",@"title":[NSString stringWithFormat:@" %ld人报名  ",(long)info.regiNum]} atIndex:1];
        }

    cell.jobInfoLabel.attributedText = jobInfoAttStr;
    cell.jobInfoDetailLabel.attributedText = [self getDetailAttStrWithItemArr:dataArr];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellType!=JobManagerListCellTypeChecking) {
        ReportManagerViewController *nextVC = [[ReportManagerViewController alloc]init];
        nextVC.title = @"报名管理";
        nextVC.jobInfo = _dataArr[indexPath.section];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    
}

#pragma mark 进入职位详情
-(void)jumpToJobDetail:(UITapGestureRecognizer *)tap {
    YMJobListInfo *info = _dataArr[tap.view.tag];
    PostJobViewController *nextVC = [[PostJobViewController alloc]init];
    nextVC.title = @"职位详情";
    nextVC.jobId = info.id;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark 停招动作
-(void)stopJobBtnAction:(UIButton *)sender {

    YMJobListInfo * info = _dataArr[sender.tag];
    [self.view showSuccessHintWith:@"停招中"];
    [YMWebClient stopJobWithParams:@{@"id":@(info.id)} Success:^(YMNomalResponse *response) {
        [self.view dismissProgress];
        if (response.code==ERROR_OK) {
            [self.view showSuccessHintWith:@"停招该职位成功"];
            _currentPage = 1;
            [self getJobListWithIsUpdate:NO];
            [UIView animateWithDuration:0.3 animations:^{
                sender.superview.left = 0.0;
            }];
        }
        else {
            [self handleErrorWithErrorResponse:response ShowHint:YES];
        }
    }];
}


#pragma mark 获取详细信息富文本字符串
-(NSAttributedString *)getDetailAttStrWithItemArr:(NSArray *)itemArr{
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
    for (NSDictionary *dataDic in itemArr) {
        NSTextAttachment *attach = [[NSTextAttachment alloc]init];
        attach.image = [UIImage imageNamed:dataDic[@"image"]];
        attach.bounds = CGRectMake(0, -2, 12, 12);
        [attStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:dataDic[@"title"] attributes:@{NSFontAttributeName:FONT(13),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
    }
    return [[NSAttributedString alloc]initWithAttributedString:attStr];

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
