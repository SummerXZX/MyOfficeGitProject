//
//  ContactLocalViewController.m
//  MyCloud
//
//  Created by test on 15/7/26.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "ContactDepartDetailViewController.h"
#import "UserInfoViewController.h"
#import <PinYin4Objc.h>
#import "UIView+Hint.h"
#import <UIImageView+WebCache.h>
#import "UserCell.h"

#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"

@interface ContactDepartDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>
{
    NSMutableArray *_searchResultArr;
    NSMutableArray *_sectionTitleArr;
    NSMutableArray *_userListArr;
}

@property (nonatomic,retain)UISearchDisplayController *userSearchDisplayController;

@property (nonatomic,retain)UITableView *userListTableView;

@end

@implementation ContactDepartDetailViewController

#pragma mark userListTableView
-(UITableView *)userListTableView
{
    if (!_userListTableView)
    {
        _userListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0) style:UITableViewStylePlain];
        if (_sectionId.length==0)
        {
            _userListTableView.height = SCREEN_HEIGHT-64.0-45.0;
        }
        else
        {
            _userListTableView.height = SCREEN_HEIGHT-64.0;
        }
        _userListTableView.delegate = self;
        _userListTableView.dataSource = self;
        _userListTableView.backgroundColor = self.view.backgroundColor;
        _userListTableView.separatorColor = DefaultBackGroundColor;
        _userListTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _userListTableView.sectionIndexColor = DefaultBlueTextColor;
        _userListTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        if ([_userListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_userListTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        //ios8SDK 兼容6 和 7 cell下划线
        if ([_userListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_userListTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _userListTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _userListTableView;
}

#pragma mark userSearchDisplayController
-(UISearchDisplayController *)userSearchDisplayController
{
    if (!_userSearchDisplayController)
    {
        UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        searchBar.placeholder = @"搜索";
        searchBar.delegate = self;
        [searchBar setBackgroundImage:[CreatCustom creatUIImageWithColor:self.view.backgroundColor]];
        searchBar.barTintColor = self.view.backgroundColor;
        self.userListTableView.tableHeaderView = searchBar;
        
        _userSearchDisplayController =  [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
        _userSearchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _userSearchDisplayController.searchResultsTableView.backgroundColor = DefaultBackGroundColor;
        if ([_userSearchDisplayController.searchResultsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_userSearchDisplayController.searchResultsTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        //ios8SDK 兼容6 和 7 cell下划线
        if ([_userSearchDisplayController.searchResultsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_userSearchDisplayController.searchResultsTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _userSearchDisplayController.searchResultsTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _userSearchDisplayController.searchResultsDataSource = self;
        _userSearchDisplayController.searchResultsDelegate = self;
    }
    return _userSearchDisplayController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    
    _userListArr = [NSMutableArray array];
    [self.view addSubview:self.userListTableView];
    [self getUserListData];
    
    self.userSearchDisplayController.delegate = self;
}

#pragma mark 获取用户列表
-(void)getUserListData
{
    WebClient *webClient = [WebClient shareClient];
    if (_userListArr.count==0)
    {
        [_userListTableView showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载云端联系人..."];
    }
    [webClient getUserListWithParameters:@{@"sText":@"",@"pageIndex":@"1",@"pageSize":@"10000",@"deptid":_sectionId} Success:^(id data)
     {
         [_userListTableView hiddenLoadingView];
         if ([data[@"code"]intValue]==0)
         {
             NSArray *resultArr = data[@"result"];
             if (resultArr.count==0)
             {
                 if (_sectionId.length==0)
                 {
                     [_userListTableView showLoadingImageWithStatus:LoadingStatusNoData StatusStr:@"本地还没有任何人员"];
                 }
                 else
                 {
                     [_userListTableView showLoadingImageWithStatus:LoadingStatusNoData StatusStr:@"该部门下还没有任何人员"];
                 }
             }
             else
             {
                 [self dealWithRequestData:data[@"result"]];
                 [_userListTableView reloadData];
             }
         }
         else
         {
             [self.view makeToast:data[@"message"]];
         }
     } Fail:^(NSError *error) {
         [_userListTableView hiddenLoadingView];
         [self.userListTableView makeToast:HintWithNetError];
     }];
}

#pragma mark 处理得到的数据
-(void)dealWithRequestData:(NSArray *)dataArr
{
    _userListArr = [NSMutableArray arrayWithObjects:@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{}, nil];
    _sectionTitleArr = [NSMutableArray array];
    for (NSDictionary *dataDic in dataArr)
    {
        //得到大写字母
        NSString *firstStr = [PinyinHelper chineseConvertToPinYinHead:dataDic[@"truename"]];
        firstStr = [[firstStr uppercaseString]substringToIndex:1];
        NSInteger objIndex = [ALPHA rangeOfString:firstStr].location;
        //填充对应项
        if ([_userListArr[objIndex] isEqualToDictionary:@{}])
        {
            NSDictionary *replaceDic = @{firstStr:@[dataDic]};
            [_userListArr replaceObjectAtIndex:objIndex withObject:replaceDic];
            [_sectionTitleArr addObject:firstStr];
        }
        else
        {
            //替换对应项目
            NSArray *lastArr = _userListArr[objIndex][firstStr];
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:lastArr];
            [tempArr addObject:dataDic];
            NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"truename" ascending:NO]];
            [tempArr sortUsingDescriptors:sortDescriptors];
            
            NSDictionary *replaceDic = @{firstStr:[NSArray arrayWithArray:tempArr]};
            [_userListArr replaceObjectAtIndex:objIndex withObject:replaceDic];
            
        }
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_userListArr];
    for (NSDictionary *dic in tempArr) {
        if ([dic isEqualToDictionary:@{}])
        {
            [_userListArr removeObject:dic];
        }
    }
    [_sectionTitleArr sortUsingSelector:@selector(compare:)];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView!=_userListTableView)
    {
        return _searchResultArr.count;
    }
    else
    {
        
        return _userListArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dataDic =nil;
    if (tableView!=_userListTableView)
    {
        dataDic =  _searchResultArr[section];
    }
    else
    {
        dataDic = _userListArr[section];
    }
    NSArray *dataArr = dataDic.allValues[0];
    return dataArr.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dataDic =nil;
    if (tableView!=_userListTableView)
    {
        dataDic =  _searchResultArr[section];
    }
    else
    {
        dataDic = _userListArr[section];
    }
    return dataDic.allKeys[0];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sectionTitleArr;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_sectionTitleArr indexOfObject:title];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.0)];
    view.backgroundColor = DefaultBackGroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, view.width-15.0, view.height)];
    label.text = _sectionTitleArr[section];
    [view addSubview:label];
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UserCell";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"UserCell" owner:nil options:nil]lastObject];
    }
    //ios8SDK 兼容6 和 7
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    NSDictionary *dataDic =nil;
    if (tableView!=_userListTableView)
    {
        dataDic =  _searchResultArr[indexPath.section];
    }
    else
    {
        dataDic = _userListArr[indexPath.section];
    }
    NSDictionary *userDic = dataDic.allValues[0][indexPath.row];
    cell.nameLabel.text = userDic[@"truename"];
    cell.phoneLabel.text = userDic[@"phone"];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userDic[@"userface"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dataDic =nil;
    if (tableView!=_userListTableView)
    {
        dataDic =  _searchResultArr[indexPath.section];
    }
    else
    {
        dataDic = _userListArr[indexPath.section];
    }
    NSDictionary *userDic = dataDic.allValues[0][indexPath.row];
    UserInfoViewController *jumpVC = [[UserInfoViewController alloc]init];
    jumpVC.title = @"用户详情";
    jumpVC.userId = userDic[@"id"];
    jumpVC.isUserCenter = NO;
    [jumpVC creatBackButtonWithPushType:Push];
    [self.navigationController pushViewController:jumpVC animated:YES];
}

#pragma mark UISearchDisplayDelegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    _searchResultArr = [NSMutableArray array];
    for (NSDictionary *dataDic in _userListArr)
    {
        NSArray *dataArr = dataDic.allValues[0];
        NSMutableArray *cityArr = [NSMutableArray array];
        for (NSDictionary *userDic in dataArr)
        {
            NSString *userName = userDic[@"truename"];
            
            BOOL isContain = [userName containsString:searchString];
            if (isContain)
            {
                [cityArr addObject:userDic];
            }
        }
        if (cityArr.count!=0)
        {
            [_searchResultArr addObject:@{dataDic.allKeys[0]:cityArr}];
        }
    }
    return YES;
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
