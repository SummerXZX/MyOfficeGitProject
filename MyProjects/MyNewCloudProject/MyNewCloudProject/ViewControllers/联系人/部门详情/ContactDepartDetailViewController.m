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
    NSArray  *_dataArr;
    
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
//        if (_departmentCode.length==0)
//        {
//            _userListTableView.height = SCREEN_HEIGHT-64.0;
//        }
//        else
//        {
//            _userListTableView.height = SCREEN_HEIGHT-64.0;
//        }
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
        [searchBar setBackgroundImage:[ProjectUtil creatUIImageWithColor:self.view.backgroundColor Size:CGSizeMake(1.0, 1.0)]];
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
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    
    _dataArr = [NSArray array];
    [self.view addSubview:self.userListTableView];
    [self getUserListData];
    
    self.userSearchDisplayController.delegate = self;
}

#pragma mark 获取用户列表
-(void)getUserListData
{
    if (_dataArr.count==0)
    {
        [_userListTableView showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载云端联系人..."];
    }

    [WebClient getDepContactListWithParams:@{@"dptCode":_departmentCode} Success:^(WebDepContactListResponse *response) {
        [_userListTableView hiddenLoadingView];
        if (response.code==ResponseCodeSuceess) {
            if (response.data.count==0) {
                if (_departmentCode.length==0)
                {
                    [_userListTableView showLoadingImageWithStatus:LoadingStatusNoData StatusStr:@"本地还没有任何人员"];
                }
                else
                {
                    [_userListTableView showLoadingImageWithStatus:LoadingStatusNoData StatusStr:@"该部门下还没有任何人员"];
                }
            }
            else {
                _dataArr = response.data.list;
            }
            [_userListTableView reloadData];
        }
        else {
            _dataArr = [NSArray array];
            [_userListTableView reloadData];
            [_userListTableView showLoadingImageWithStatus:LoadingStatusNetError StatusStr:response.codeInfo];
        }
    }];
}


#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_userListTableView==tableView) {
        return _dataArr.count;
    }
    else {
        return _searchResultArr.count;
    }
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
    WebContactInfo *info =nil;
    if (tableView!=_userListTableView)
    {
        info =  _searchResultArr[indexPath.row];
    }
    else
    {
        info = _dataArr[indexPath.row];
    }
    
    NSMutableAttributedString *userInfoArrStr = [[NSMutableAttributedString alloc]initWithString:info.userName attributes:@{NSFontAttributeName:FONT(17),NSForegroundColorAttributeName:[UIColor blackColor]}];
//    [userInfoArrStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",info.departmentFullName] attributes:@{NSFontAttributeName:FONT(13),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
    cell.nameLabel.attributedText =userInfoArrStr;
    cell.phoneLabel.text = info.userPhone;
    cell.phoneLabel.font = FONT(15);
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",REQUEST_IMG_URL,info.userIcon]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *userCode = @"";
        WebContactInfo *info =nil;
        if (tableView!=_userListTableView)
        {
            info =  _searchResultArr[indexPath.row];
        }
        else
        {
            info = _dataArr[indexPath.row];
        }
        
        userCode = info.userCode;

    UserInfoViewController *jumpVC = [[UserInfoViewController alloc]init];
    jumpVC.title = @"用户详情";
    jumpVC.userCode = userCode;
    jumpVC.isUserCenter = NO;
    [self.navigationController pushViewController:jumpVC animated:YES];
}

#pragma mark UISearchDisplayDelegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    _searchResultArr = [NSMutableArray array];
    for (WebContactInfo *info in _dataArr)
    {
        if ([info.userName rangeOfString:searchString].length!=0) {
            [_searchResultArr addObject:info];
        }
    }
    if (_searchResultArr.count==0)
    {
        for(UIView *subview in _userSearchDisplayController.searchResultsTableView.subviews) {
            if([subview isKindOfClass:[UILabel class]]) {
                
                [(UILabel*)subview setText:@"无相关联系人"];
            }
            
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
