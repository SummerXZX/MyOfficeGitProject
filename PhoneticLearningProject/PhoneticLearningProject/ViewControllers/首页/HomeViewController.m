//
//  FirstViewController.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/11.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeBookCell.h"
#import "HomeNoBookCell.h"
#import "MyRefreshHeader.h"
#import "MyRefreshFooter.h"
#import "MyLoadingView.h"
#import <UIImageView+WebCache.h>
#import <GDataXMLNode.h>
#import "BookDataBaseManager.h"
#import <AFNetworking.h>
#import "MBProgressHUD.h"
#import "BookUnitViewController.h"

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *_dataArr;
    int _currentPage; //当前数据页码
    int _totalCount;//数据总数
}
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation HomeViewController

#pragma mark collectionView
- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* flowLayout =
        [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/2.0, HomeBookCellHeight);
        flowLayout.minimumLineSpacing = 0.0;
        flowLayout.minimumInteritemSpacing = 0.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0-49.0)
                                             collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeBookCell"
                                                    bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"HomeBookCell"];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeNoBookCell"
                                                    bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"HomeNoBookCell"];
        
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    _currentPage  = 1;
    
    UITabBarItem* barItem = self.tabBarController.tabBar.items[0];
    barItem.selectedImage = [[UIImage imageNamed:@"tabbar_home_selected"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //添加背景图片
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_bg.jpg"]];
    bgImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bgImageView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bgImageView]-0-|" options:0 metrics:nil views:@{@"bgImageView":bgImageView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bgImageView]-0-|" options:0 metrics:nil views:@{@"bgImageView":bgImageView}]];
    
    [self.view addSubview:self.collectionView];
    
    UIButton *myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myBtn.frame = CGRectMake(0, 0, 26, 27);
    [myBtn setImage:[UIImage imageNamed:@"home_my"] forState:UIControlStateNormal];
    [myBtn addTarget:self action:@selector(jumpToMy) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:myBtn];
    
    //获取首页数据
    [self getHomeBookList];
}

#pragma mark 跳转我的
-(void)jumpToMy {
    self.tabBarController.selectedIndex = 1;
}

#pragma mark 获取首页数据
-(void)getHomeBookList {
    
    if (_dataArr.count==0) {
        [MyLoadingView showFromView:self.collectionView WithLoadingStatus:LoadingStatusOnLoading];
    }
    
    [WebServiceClient getHomeBookListWithParams:@{@"page":@(_currentPage),@"rows":@(DATASIZE)} success:^(WebHomeBookListResponse *response) {
        
        [MyLoadingView hiddenForView:self.collectionView];
        if (self.collectionView.mj_header.isRefreshing) {
            [self.collectionView.mj_header endRefreshing];
        }
        if (self.collectionView.mj_footer.isRefreshing) {
            [self.collectionView.mj_footer endRefreshing];
        }
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:response.data.data];
       
        if (tempArr.count%2!=0) {
            [tempArr addObject:[[HomeBookInfo alloc] init]];
        }
        _totalCount = response.data.totalNum;

        [self dealWithBackList:tempArr];
        [self.collectionView reloadData];
    } Fail:^(NSError *error) {
        if (self.collectionView.mj_header.isRefreshing) {
            [self.collectionView.mj_header endRefreshing];
        }
        if (self.collectionView.mj_footer.isRefreshing) {
            [self.collectionView.mj_footer endRefreshing];
        }
        self.collectionView.mj_header = nil;
        self.collectionView.mj_footer = nil;
        
        _dataArr = [NSMutableArray array];
        [self.collectionView reloadData];
        
        [MyLoadingView hiddenForView:self.collectionView];
        __block HomeViewController *blockVC = self;
        [MyLoadingView showFromView:self.collectionView HandleReloadAction:^{
            [MyLoadingView hiddenForView:self.collectionView];
            _currentPage = 1;
            [blockVC getHomeBookList];
        }];
        
    }];
}

#pragma mark 处理返回列表数据
- (void)dealWithBackList:(NSArray*)list
{
    if (list.count == 0) {
        if (_currentPage == 1) {
            _dataArr = [NSMutableArray array];
            [MyLoadingView showFromView:self.collectionView WithLoadingStatus:LoadingStatusNoData];
        }
        else {
            self.collectionView.mj_footer = nil;
        }
    }
    else {
        if (_currentPage == 1) {
            _dataArr = [NSMutableArray arrayWithArray:list];
            //添加下拉刷新
            __block HomeViewController* blockVC = self;
            if (!self.collectionView.mj_header) {
                
                MyRefreshHeader *header = [MyRefreshHeader headerWithRefreshingBlock:^{
                    blockVC->_currentPage = 1;
                    [blockVC getHomeBookList];
                }];
                self.collectionView.mj_header = header;
            }
            //添加上拉加载
            if (_totalCount > _dataArr.count) {
                if (!self.collectionView.mj_footer) {
                    self.collectionView.mj_insetB = 0.0;
                    
                    MyRefreshFooter *footer = [MyRefreshFooter footerWithRefreshingBlock:^{
                        blockVC -> _currentPage ++;
                        [blockVC getHomeBookList];
                    }];
                    self.collectionView.mj_footer = footer;
                }
            }
            else {
                self.collectionView.mj_footer = nil;
            }
        }
        else {
            [_dataArr addObjectsFromArray:list];
            if (_totalCount <= _dataArr.count) {
                self.collectionView.mj_footer = nil;
            }
        }
    }
}


#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:
(UICollectionView*)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeBookInfo *info = _dataArr[indexPath.row];
    if (info.name.length==0) {
         HomeNoBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeNoBookCell" forIndexPath:indexPath];
        return cell;
    }
    else {
        HomeBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBookCell" forIndexPath:indexPath];
        if (indexPath.row%2!=0) {
            cell.itemBgImageView.image = [UIImage imageNamed:@"home_right_unit_bg"];
        }
        else {
            cell.itemBgImageView.image = [UIImage imageNamed:@"home_left_unit_bg"];
        }
        [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:info.imgUrl] placeholderImage:[UIImage imageNamed:@"home_book_bg"]];
        cell.bookNameLabel.text = info.name;
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeBookInfo *info = _dataArr[indexPath.row];
    if (info.name.length!=0) {
        if ([BookDataBaseManager getBookIsExistWithBookName:info.name]) {
            //检查是否需要更新
            if ([BookDataBaseManager getBookIsNeedUpdateWithModifyTime:info.modifyTime]) {

                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"这本书有更新您确认要下载吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alertView.tag = indexPath.row;
                [alertView show];
                
            }
            else {
                //跳转书本目录
                [self jumpToBookUnitVCWithBookName:info.name];
                
            }
        }
        else {
            //下载书本内容
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确认要下载这本书吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.tag = indexPath.row;
            [alertView show];
        }
    }
}

#pragma mark 跳转单元目录
-(void)jumpToBookUnitVCWithBookName:(NSString *)bookname {
    BookUnitViewController *nextVC = [[BookUnitViewController alloc]init];
    nextVC.title = @"单元目录";
    nextVC.hidesBottomBarWhenPushed = YES;
    nextVC.bookname = bookname;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex!=alertView.cancelButtonIndex) {
       __block HomeBookInfo *info = _dataArr[alertView.tag];
        //先删除已有的数据
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[BookDataBaseManager getBookFilesPath],info.name] error:nil];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.progress = 0.0;
        hud.label.text = @"下载中...0%";
        
        [WebServiceClient downloadBookInfoWithParams:@{@"gradeId":@(info.id)} success:^(WebNomalResponse *response) {
            GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc]initWithData:response.data encoding:NSUTF8StringEncoding error:nil];
            GDataXMLElement *rootxml = [xmlDoc rootElement];
            if (rootxml.children) {
                //定义一些常量
                __block int totalFilesCount = 0;
                
                NSMutableArray *unitsArr = [NSMutableArray array];
                for (GDataXMLElement *unit in rootxml.children) {
                    BookUnitInfo *unitInfo = [[BookUnitInfo alloc]init];
                    unitInfo.id = [[[unit attributeForName:@"id"] stringValue] intValue];
                    unitInfo.name =[[unit attributeForName:@"name"] stringValue];
                    [unitsArr addObject:unitInfo];
                    NSMutableArray *coursesArr = [NSMutableArray array];
                    int i = 0;
                    for (GDataXMLElement *course in unit.children) {
                        UnitCourseInfo *courseInfo = [[UnitCourseInfo alloc]init];
                        courseInfo.name = [[course attributeForName:@"name"] stringValue];
                        [coursesArr addObject:courseInfo];
                        NSMutableArray *filesArr = [NSMutableArray array];
                        for (GDataXMLElement *file in course.children) {
                            CourseFileInfo *fileInfo = [[CourseFileInfo alloc]init];
                            fileInfo.name = [[file attributeForName:@"name"] stringValue];
                            fileInfo.size = [[[file attributeForName:@"size"] stringValue] intValue];
                            fileInfo.type = [[file attributeForName:@"type"] stringValue];
                            fileInfo.url = [file stringValue];
                            [filesArr addObject:fileInfo];
                            totalFilesCount++;
                        }
                        courseInfo.coursefiles = [NSArray arrayWithArray:filesArr];
                        i ++;
                    }
                    unitInfo.courses = [NSArray arrayWithArray:coursesArr];
                }
                info.units = [NSArray arrayWithArray:unitsArr];
                
                //下载课程文件,先判断附件是否存在
                __block int currentDataSize = 0;
                __block float totalDataSize = [info.bookSize floatValue];
                __block int downloadFilsCount = 0;
                __block HomeViewController *blockVC = self;
                for (BookUnitInfo *unitInfo in info.units) {
                    for (UnitCourseInfo *courseInfo in unitInfo.courses) {
                        for (CourseFileInfo *fileInfo in courseInfo.coursefiles) {
                            NSString *fileDirectories = [NSString stringWithFormat:@"%@/%@/%@/%@",[BookDataBaseManager getBookFilesPath],info.name,unitInfo.name,courseInfo.name];
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            __block  NSString *filePath = [NSString stringWithFormat:@"%@/%@",fileDirectories,[[fileInfo.url componentsSeparatedByString:@"/"] lastObject]];
                            if (![fileManager fileExistsAtPath:fileDirectories]) {
                                [fileManager createDirectoryAtPath:fileDirectories withIntermediateDirectories:YES attributes:nil error:nil];
                            }
                            //多线程下载文件
                            __block   BOOL _iscontinueDownload = YES;
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[fileInfo.url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
                                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
                                operation.inputStream   = [NSInputStream inputStreamWithURL:[NSURL URLWithString:fileInfo.url]];
                                operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
                                __block AFHTTPRequestOperation *myOperation  = operation;
                                [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                                    currentDataSize += bytesRead;
                                    float percent = (float)(currentDataSize/totalDataSize)*100;
                                    [ProjectUtil showLog:@"percent:%f",percent];
                                    [ProjectUtil showLog:@"currentfileCount:%d,\ntotalBytesExpectedToRead:%lld",downloadFilsCount,totalBytesExpectedToRead];
                                    hud.progress = percent/100.0;
                                    hud.label.text =[NSString stringWithFormat:@"下载中...%.1f%@",percent,@"%"];
                                    if (_iscontinueDownload==NO) {
                                        [myOperation cancel];
                                    }
                                }];
                                
                                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                    [ProjectUtil showLog:@"下载成功:%@",filePath];
                                    downloadFilsCount++;
                                    
                                    if (downloadFilsCount==totalFilesCount) {
                                        if (_iscontinueDownload) {
                                            [blockVC.view hiddenProgress];
                                            //插入图书数据
                                            [BookDataBaseManager insertBooksWithBookInfo:info];
                                            [self.view.window makeToast:@"下载成功！"];
                                            [self jumpToBookUnitVCWithBookName:info.name];
                                        }
                                        else {
                                            [blockVC.view hiddenProgress];
                                            [blockVC.view makeToast:@"下载失败！"];
                                            NSFileManager *fileManager = [NSFileManager defaultManager];
                                            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[BookDataBaseManager getBookFilesPath],info.name] error:nil];
                                        }
                                        
                                    }
                                } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                    [ProjectUtil showLog:@"下载失败:%@,\nerror:%@",filePath,error];
                                    _iscontinueDownload = NO;
                                    downloadFilsCount ++;
                                    if (downloadFilsCount==totalFilesCount) {
                                        [blockVC.view hiddenProgress];
                                        [blockVC.view makeToast:@"下载失败！"];
                                        NSFileManager *fileManager = [NSFileManager defaultManager];
                                        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[BookDataBaseManager getBookFilesPath],info.name] error:nil];
                                    }
                                    
                                }];
                                [operation start];
                            });
                        }
                    }
                }

            }
            else {
                [self.view hiddenProgress];
                [ProjectUtil showAlert:@"提示" message:@"该书尚未上传，敬请期待"];
            }
            
        } Fail:^(NSError *error) {
            [self.view hiddenProgress];
            [self.view makeToast:error.domain];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
