//
//  ContactViewController.m
//  MyCloud
//
//  Created by test on 15/7/26.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "ContactViewController.h"
#import "UserInfoViewController.h"
#import <PinYin4Objc.h>
#import <UIImageView+WebCache.h>
#import "UserCell.h"
#import "CallRecordDBManager.h"
#import "ContactDepartDetailViewController.h"

#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"

typedef NS_ENUM(NSInteger, SelectedType)
{
    SelectedTypeAllContact,
    SelectedTypeDepart,
    SelectedTypeRecentContact
};

@interface ContactViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>
{
    UIButton *_selectedBtn;
    UILabel *_selectedLabel;
    SelectedType _selectedType;
    NSArray *_dataArr;
    NSMutableArray *_searchResultArr;
}
@property (nonatomic,retain)UISearchDisplayController *userSearchDisplayController;

@property (nonatomic,retain)UITableView *tableView;

@property (nonatomic,retain)UISearchBar *searchBar;

@end


@implementation ContactViewController

#pragma mark tableView
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45.0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0-45.0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorColor = DefaultBackGroundColor;
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexColor = DefaultBlueTextColor;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        //ios8SDK 兼容6 和 7 cell下划线
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

#pragma mark userSearchDisplayController
-(UISearchDisplayController *)userSearchDisplayController
{
    if (!_userSearchDisplayController)
    {
        
        self.tableView.tableHeaderView = self.searchBar;
        _userSearchDisplayController =  [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
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


#pragma mark 
-(UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
        [_searchBar setBackgroundImage:[ProjectUtil creatUIImageWithColor:self.view.backgroundColor Size:CGSizeMake(1.0, 1.0)]];
        _searchBar.barTintColor = self.view.backgroundColor;
    }
    return _searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    [self.view addSubview:self.tableView];
    self.userSearchDisplayController.delegate = self;
    UIButton *localBtn = (UIButton *)[self.view viewWithTag:11];
    [self topBtnAction:localBtn];
}

#pragma mark 顶部按钮动作
- (IBAction)topBtnAction:(UIButton *)sender
{
    [_tableView hiddenLoadingView];
    
    if (_selectedBtn!=sender)
    {
        [UIView animateWithDuration:0.2 animations:^{
            sender.selected = YES;
            _selectedBtn.selected = NO;
            UILabel *titleLabel = (UILabel *)[self.view viewWithTag:sender.tag+90];
            titleLabel.textColor = DefaultBlueTextColor;
            _selectedLabel.textColor = DefaultGrayTextColor;
            _selectedLabel = titleLabel;
            _selectedBtn = sender;
            _dataArr = [NSMutableArray array];
            [_tableView reloadData];
            if (sender.tag==11)
            {
                //加载全部联系人
                _selectedType = SelectedTypeAllContact;
                _tableView.tableHeaderView = _searchBar;
                [self requestAllUserList];
            }
            else if (sender.tag==12)
            {
                //加载部门列表
                _selectedType = SelectedTypeDepart;
                _tableView.tableHeaderView = nil;
                [self requestDepartList];
            }
            else if (sender.tag==13)
            {
                //加载最近联系人
                _selectedType = SelectedTypeRecentContact;
                _tableView.tableHeaderView = nil;
                _dataArr = [NSMutableArray arrayWithArray:[CallRecordDBManager getCallRecordArr]];
                if (_dataArr.count==0)
                {
                    [_tableView showLoadingImageWithStatus:LoadingStatusNoData StatusStr:@"您最近还没有联系过任何人哦"];
                }
                else
                {
                    [_tableView reloadData];
                }
            }
        }];
    }
}

#pragma mark 获取所有用户列表
-(void)requestAllUserList
{
    if (_dataArr.count==0)
    {
        [_tableView showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载云端联系人..."];
    }

    LoginUserInfo *info = [ProjectUtil getLoginUserInfo];
    
    [WebClient getContactListWithParams:@{@"companyCode":info.companyCode,@"type":@2} Success:^(WebContactListResponse *response) {
        [_tableView hiddenLoadingView];
        if (response.code==ResponseCodeSuceess) {
            if (response.data.count==0) {
                [_tableView showLoadingImageWithStatus:LoadingStatusNoData StatusStr:@"云端还没有任何联系人"];
            }
            else {
                _dataArr = response.data.list;
            }
            [_tableView reloadData];
        }
        else {
            _dataArr = [NSArray array];
            [_tableView reloadData];
            [_tableView showLoadingImageWithStatus:LoadingStatusNetError StatusStr:response.codeInfo];
        }
    }];
}

#pragma mark 获取部门列表
-(void)requestDepartList
{
    LoginUserInfo *info = [ProjectUtil getLoginUserInfo];
    if (_dataArr.count==0)
    {
        [_tableView showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载部门列表..."];
    }
    [WebClient getDepListWithParams:@{@"companyCode":info.companyCode} Success:^(WebDepListResponse *response) {
        [_tableView hiddenLoadingView];
        if (response.code==ResponseCodeSuceess) {
            if (response.data.count==0) {
                [_tableView showLoadingImageWithStatus:LoadingStatusNoData StatusStr:@"还没有任何部门"];
            }
            else {
                _dataArr = response.data.list;
            }
            [_tableView reloadData];

        }
        else {
            _dataArr = [NSArray array];
            [_tableView reloadData];
            [_tableView showLoadingImageWithStatus:LoadingStatusNetError StatusStr:response.codeInfo];
        }
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableView==tableView) {
        return _dataArr.count;
    }
    else {
        return _searchResultArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedType==SelectedTypeDepart)
    {
        return 44.0;
    }
    return 70.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedType == SelectedTypeDepart)
    {
        static NSString *identifier = @"SectionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.textColor = DefaultBlueTextColor;
            cell.textLabel.font = FONT(15);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //ios8SDK 兼容6 和 7
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        WebDepInfo *info = _dataArr[indexPath.row];
        cell.textLabel.text = info.departmentFullName;
        return cell;
    }
    else
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
        if (_selectedType==SelectedTypeAllContact)
        {
            WebContactInfo *info =nil;
            if (tableView!=_tableView)
            {
                info =  _searchResultArr[indexPath.row];
            }
            else
            {
                info = _dataArr[indexPath.row];
            }
            
            NSMutableAttributedString *userInfoArrStr = [[NSMutableAttributedString alloc]initWithString:info.userName attributes:@{NSFontAttributeName:FONT(17),NSForegroundColorAttributeName:[UIColor blackColor]}];
            [userInfoArrStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",info.departmentFullName] attributes:@{NSFontAttributeName:FONT(13),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
            cell.nameLabel.attributedText =userInfoArrStr;
            cell.phoneLabel.text = info.userPhone;
            cell.phoneLabel.font = FONT(15);
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUEST_IMG_URL,info.userIcon]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        }
        else if (_selectedType==SelectedTypeRecentContact)
        {
            NSDictionary *dataDic = _dataArr[indexPath.row];
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUEST_IMG_URL,dataDic[@"callavatar"]]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
            NSMutableAttributedString *userInfoArrStr = [[NSMutableAttributedString alloc]initWithString:dataDic[@"callname"] attributes:@{NSFontAttributeName:FONT(17),NSForegroundColorAttributeName:[UIColor blackColor]}];
            [userInfoArrStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",dataDic[@"callnum"]] attributes:@{NSFontAttributeName:FONT(13),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
            cell.nameLabel.attributedText = userInfoArrStr;
            cell.phoneLabel.font = FONT(13);
            cell.phoneLabel.text = [ProjectUtil changeDateToDateStr:[NSDate dateWithTimeIntervalSince1970:[dataDic[@"calltime"]integerValue]]];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectedType==SelectedTypeDepart)
    {
        WebDepInfo *info = _dataArr[indexPath.row];
        ContactDepartDetailViewController *jumpVC = [[ContactDepartDetailViewController alloc]init];
        jumpVC.departmentCode =info.departmentCode;
        jumpVC.title = info.departmentFullName;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else
    {

        NSString *userCode = @"";
        if (_selectedType==SelectedTypeAllContact)
        {
            WebContactInfo *info =nil;
            if (tableView!=_tableView)
            {
                info =  _searchResultArr[indexPath.row];
            }
            else
            {
                info = _dataArr[indexPath.row];
            }
            
            userCode = info.userCode;
        }
        else if (_selectedType==SelectedTypeRecentContact)
        {
            NSDictionary *dataDic = _dataArr[indexPath.row];
            userCode = dataDic[@"calluserid"];;
        }
        UserInfoViewController *jumpVC = [[UserInfoViewController alloc]init];
        jumpVC.title = @"用户详情";
        jumpVC.userCode = userCode;
        jumpVC.isUserCenter = NO;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}

#pragma mark UISearchDisplayDelegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    _searchResultArr = [NSMutableArray array];
    for (WebContactInfo *info in _dataArr)
    {
        NSString *userName =info.userName;
        NSString *departName = info.departmentFullName;
        NSString *userPinYName = [ProjectUtil getPinYinWithChinese:userName];
        NSString *departPinYName = [ProjectUtil getPinYinWithChinese:departName];
      
        BOOL isContain = NO;
        if ([userName rangeOfString:searchString].length!=0)
        {
            isContain = YES;
        }
        else if ([userPinYName rangeOfString:[searchString lowercaseString]].length!=0)
        {
            isContain = YES;
        }
        else if ([departName rangeOfString:searchString].length!=0)
        {
            isContain = YES;
        }
        else if ([departPinYName rangeOfString:[searchString lowercaseString]].length!=0)
        {
            isContain = YES;
        }
        if (isContain)
        {
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
