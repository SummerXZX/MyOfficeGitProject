//
//  ChooseCityViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/13.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "ChooseCityViewController.h"
#import "CityDataBaseManager.h"
#import "MyTableViewHeaderView.h"
#import "ChooseCountyViewController.h"
#import "UIScrollView+EmptyDataSet.h"


@interface ChooseCityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSArray* _searchResultArr;//搜索结果
    NSArray* _dataArr;//数据
    NSArray *_sectionTitleArr;
}

@property (nonatomic,strong) UISearchDisplayController *searchDisplayPlayController;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ChooseCityViewController

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeNomal];
        _tableView.sectionIndexColor = DefaultGrayTextColor;
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark 
-(UISearchDisplayController *)searchDisplayPlayController {
    if (!_searchDisplayPlayController) {
        
        UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0)];
        searchBar.placeholder = @"搜索城市";
        
        [searchBar setBackgroundImage:[ProjectUtil creatUIImageWithColor:DefaultBackGroundColor Size:CGSizeMake(1.0, 1.0)]];
        searchBar.barTintColor = DefaultBackGroundColor;
        self.tableView.tableHeaderView = searchBar;
        
        _searchDisplayPlayController = [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
        _searchDisplayPlayController.searchResultsTableView.tableFooterView = [UIView new];
        _searchDisplayPlayController.searchResultsTableView.backgroundColor = DefaultBackGroundColor;
        _searchDisplayPlayController.searchResultsTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _searchDisplayPlayController.searchResultsTableView.emptyDataSetSource = self;
        _searchDisplayPlayController.searchResultsTableView.emptyDataSetDelegate = self;
        _searchDisplayPlayController.searchResultsDelegate = self;
        _searchDisplayPlayController.searchResultsDataSource = self;
    }
    return _searchDisplayPlayController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews {
    
    _dataArr = [CityDataBaseManager getCity];
    _sectionTitleArr = [CityDataBaseManager getCityLetters];
    self.tableView.height = SCREEN_HEIGHT-64.0;
    [self.view addSubview:self.tableView];
    self.searchDisplayPlayController.delegate = self;
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView==_tableView) {
        return _dataArr.count;
    }
    else {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==_tableView) {
        NSArray *itemArr = _dataArr[section][@"items"];
        return itemArr.count;
    }
    else {
        return _searchResultArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView==_tableView) {
        return 30.0;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifier = @"headerView";
    MyTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[MyTableViewHeaderView alloc]initWithReuseIdentifier:identifier];
    }
    headerView.titleLabel.text = _sectionTitleArr[section];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"cell";
    UITableViewCell* cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.textLabel.font = FONT(14);
        cell.textLabel.textColor = DefaultGrayTextColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (tableView==_tableView) {
        cell.textLabel.text = _dataArr[indexPath.section][@"items"][indexPath.row][@"name"];
    }
    else {
        cell.textLabel.text = _searchResultArr[indexPath.row][@"name"];
    }
    return cell;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView==_tableView) {
        return _sectionTitleArr;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSInteger cityId = 0;
    if (tableView==_tableView) {
        cityId = [_dataArr[indexPath.section][@"items"][indexPath.row][@"id"]integerValue];
    }
    else {
        cityId = [_searchResultArr[indexPath.row][@"id"]integerValue];
    }
    NSArray *countyArr = [CityDataBaseManager getCountyWithParentId:cityId];
    if (countyArr.count==0) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:GetSelectedCityNotification object:@{@"cityId":@(cityId),@"areaId":@0}];
    }
    else {
        ChooseCountyViewController *nextVC = [[ChooseCountyViewController alloc] init];
        nextVC.title = @"选择县区";
        if (_isNearby) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:countyArr];
            [tempArr insertObject:@{@"id":@0,@"name":@"就近安排"} atIndex:0];
            countyArr = [NSArray arrayWithArray:tempArr];
        }
        nextVC.cityId = cityId;
        nextVC.countyArr = countyArr;
        [self.navigationController pushViewController:nextVC animated:YES];
    }
  
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

#pragma mark UISearchDisplayDelegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString {
    

    NSMutableArray *tempArr = [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"ename contains[cd] '%@' OR name contains[cd] '%@'",searchString,searchString]];
    for (NSDictionary *dic in _dataArr) {
        NSArray *itemsArr = dic[@"items"];
        [tempArr addObjectsFromArray:[itemsArr filteredArrayUsingPredicate:predicate]];
    }
    _searchResultArr = [NSArray arrayWithArray:tempArr];
    return YES;
}



#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"load_nodata"];
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
