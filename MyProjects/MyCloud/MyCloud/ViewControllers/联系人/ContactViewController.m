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
#import "UIView+Hint.h"
#import <UIImageView+WebCache.h>
#import "UserCell.h"
#import "CallRecordDBManager.h"
#import "UserInfo.h"
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
    NSMutableArray *_searchResultArr;
    NSMutableArray *_sectionTitleArr;
    NSMutableArray *_dataArr;
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
        _tableView.height = SCREEN_HEIGHT-64.0-45.0;
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
        [_searchBar setBackgroundImage:[CreatCustom creatUIImageWithColor:self.view.backgroundColor]];
        _searchBar.barTintColor = self.view.backgroundColor;
    }
    return _searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    WebClient *webClient = [WebClient shareClient];
    if (_dataArr.count==0)
    {
        [_tableView showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载云端联系人..."];
    }
    [webClient getUserListWithParameters:@{@"sText":@"",@"pageIndex":@"1",@"pageSize":@"10000",@"deptid":@""} Success:^(id data)
     {
         [_tableView hiddenLoadingView];
         if ([data[@"code"]intValue]==0)
         {
             NSArray *resultArr = data[@"result"];
             if (resultArr.count==0)
             {
                 [_tableView showLoadingImageWithStatus:LoadingStatusNoData StatusStr:@"云端还没有任何联系人"];
             }
             else
             {
                 [self dealWithRequestData:data[@"result"]];
                 [_tableView reloadData];
             }
         }
         else
         {
             [self.view makeToast:data[@"message"]];
         }
     } Fail:^(NSError *error) {
         [_tableView hiddenLoadingView];
         _dataArr = [NSMutableArray array];
         [_tableView reloadData];
         [_tableView showLoadingImageWithStatus:LoadingStatusNetError StatusStr:HintWithNetError];
     }];
}

#pragma mark 处理得到的数据
-(void)dealWithRequestData:(NSArray *)dataArr
{
    _dataArr = [NSMutableArray arrayWithObjects:@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{}, nil];
    _sectionTitleArr = [NSMutableArray array];
    for (NSDictionary *dataDic in dataArr)
    {
        //得到大写字母
        NSString *firstStr = [PinyinHelper chineseConvertToPinYinHead:dataDic[@"truename"]];
        firstStr = [[firstStr uppercaseString]substringToIndex:1];
        NSInteger objIndex = [ALPHA rangeOfString:firstStr].location;
        //填充对应项
        if ([_dataArr[objIndex] isEqualToDictionary:@{}])
        {
            NSDictionary *replaceDic = @{firstStr:@[dataDic]};
            [_dataArr replaceObjectAtIndex:objIndex withObject:replaceDic];
            [_sectionTitleArr addObject:firstStr];
        }
        else
        {
            //替换对应项目
            NSArray *lastArr = _dataArr[objIndex][firstStr];
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:lastArr];
            [tempArr addObject:dataDic];
            NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"truename" ascending:NO]];
            [tempArr sortUsingDescriptors:sortDescriptors];
            
            NSDictionary *replaceDic = @{firstStr:[NSArray arrayWithArray:tempArr]};
            [_dataArr replaceObjectAtIndex:objIndex withObject:replaceDic];
            
        }
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_dataArr];
    for (NSDictionary *dic in tempArr) {
        if ([dic isEqualToDictionary:@{}])
        {
            [_dataArr removeObject:dic];
        }
    }
    [_sectionTitleArr sortUsingSelector:@selector(compare:)];
}

#pragma mark 获取部门列表
-(void)requestDepartList
{
    WebClient *webClient = [WebClient shareClient];
    if (_dataArr.count==0)
    {
        [_tableView showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载部门列表..."];
    }
    [webClient getSectionListParameters:@{@"sText":@"",@"pageIndex":@"1",@"pageSize":@"1000"} Success:^(id data) {
        [_tableView hiddenLoadingView];
        if ([data[@"code"] intValue]==0)
        {
            NSArray *resultArr = data[@"result"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:resultArr];
            //获取登录信息
            UserInfo *loginInfo = [ProjectUtil getCustomObjFromUserDefaultsWithKey:@"login"];
            [resultArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj[@"id"]intValue]==[loginInfo.DEPTIDS intValue])
                {
                    [tempArr removeObject:obj];
                    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:obj];
                    [dataDic setObject:@"我的部门" forKey:@"gname"];
                    obj = [NSDictionary dictionaryWithDictionary:dataDic];
                    [tempArr insertObject:obj atIndex:0];
                    *stop = YES;
                }
            }];
            
            _dataArr = tempArr;
            
            [_tableView reloadData];
        }
        else
        {
             [_tableView showLoadingImageWithStatus:LoadingStatusNetError StatusStr:data[@"message"]];
        }
    } Fail:^(NSError *error) {
        [_tableView hiddenLoadingView];
        _dataArr = [NSMutableArray array];
        [_tableView reloadData];
        [_tableView showLoadingImageWithStatus:LoadingStatusNetError StatusStr:HintWithNetError];
    }];

}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_selectedType==SelectedTypeAllContact)
    {
        if (tableView!=_tableView)
        {
            return _searchResultArr.count;
        }
        else
        {
            return _dataArr.count;
        }
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectedType==SelectedTypeAllContact)
    {
        NSDictionary *dataDic =nil;
        if (tableView!=_tableView)
        {
            dataDic =  _searchResultArr[section];
        }
        else
        {
            dataDic = _dataArr[section];
        }
        NSArray *dataArr = dataDic.allValues[0];
        return dataArr.count;
    }
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedType==SelectedTypeDepart)
    {
        return 44.0;
    }
    return 70.0;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_selectedType==SelectedTypeAllContact)
    {
        return _sectionTitleArr;
    }
    else
    {
        return [NSArray array];
    }
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (_selectedType==SelectedTypeAllContact)
    {
        return [_sectionTitleArr indexOfObject:title];
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.0)];
    view.backgroundColor = DefaultBackGroundColor;
    if (_selectedType == SelectedTypeAllContact)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, view.width-15.0, view.height)];
        label.text = _sectionTitleArr[section];
        [view addSubview:label];
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_selectedType==SelectedTypeAllContact)
    {
        return 30.0;
    }
    return 0.0;
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
        }
        //ios8SDK 兼容6 和 7
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        NSDictionary *dataDic = _dataArr[indexPath.row];
        NSString *countStr = dataDic[@"zs"];
        cell.textLabel.textColor = DefaultBlueTextColor;
        cell.textLabel.text = [NSString stringWithFormat:@"%@（%@）",dataDic[@"gname"],countStr.length==0?@"0":countStr];
        if ([dataDic[@"gname"]isEqualToString:@"我的部门"])
        {
           cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        else
        {
            cell.textLabel.font = Default_Font_15;
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            NSDictionary *dataDic =nil;
            if (tableView!=_tableView)
            {
                dataDic =  _searchResultArr[indexPath.section];
            }
            else
            {
                dataDic = _dataArr[indexPath.section];
            }
            NSDictionary *userDic = dataDic.allValues[0][indexPath.row];
            NSMutableAttributedString *userInfoArrStr = [[NSMutableAttributedString alloc]initWithString:userDic[@"truename"] attributes:@{NSFontAttributeName:Default_Font_17,NSForegroundColorAttributeName:[UIColor blackColor]}];
            [userInfoArrStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",userDic[@"uLevID"]] attributes:@{NSFontAttributeName:Default_Font_13,NSForegroundColorAttributeName:DefaultGrayTextColor}]];
            cell.nameLabel.attributedText =userInfoArrStr;
            cell.phoneLabel.text = [self getUserPhoneWithUserDic:userDic];
            cell.phoneLabel.font = Default_Font_15;
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userDic[@"userface"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        }
        else if (_selectedType==SelectedTypeRecentContact)
        {
            NSDictionary *dataDic = _dataArr[indexPath.row];
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"callavatar"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
            NSMutableAttributedString *userInfoArrStr = [[NSMutableAttributedString alloc]initWithString:dataDic[@"callname"] attributes:@{NSFontAttributeName:Default_Font_17,NSForegroundColorAttributeName:[UIColor blackColor]}];
            [userInfoArrStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",dataDic[@"callnum"]] attributes:@{NSFontAttributeName:Default_Font_13,NSForegroundColorAttributeName:DefaultGrayTextColor}]];
            cell.nameLabel.attributedText = userInfoArrStr;
            cell.phoneLabel.font = Default_Font_13;
            cell.phoneLabel.text = [ProjectUtil changeToChineseDateStrWithSp:[dataDic[@"calltime"]integerValue]];
        }
        return cell;
    }
}

#pragma mark 获取用户电话信息
-(NSString *)getUserPhoneWithUserDic:(NSDictionary *)userDic;
{
    NSString *phoneStr = @"";
    UserInfo *userInfo = [[UserInfo alloc]initWithDic:userDic];
    
    if (userInfo.phone.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingString:userInfo.phone];
    }
    if (userInfo.mobile.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingFormat:@" %@",userInfo.mobile];
    }
    if (userInfo.zwtnum.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingFormat:@" %@",userInfo.zwtnum];
    }
    if (userInfo.zwtnum2.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingFormat:@" %@",userInfo.zwtnum2];
    }
    if (userInfo.officeTel.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingFormat:@" %@",userInfo.officeTel];
    }
    if (userInfo.officeMob.length!=0)
    {
        phoneStr = [phoneStr stringByAppendingFormat:@" %@",userInfo.officeMob];
    }
    return phoneStr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectedType==SelectedTypeDepart)
    {
        NSDictionary *dataDic = _dataArr[indexPath.row];
        ContactDepartDetailViewController *jumpVC = [[ContactDepartDetailViewController alloc]init];
        jumpVC.sectionId = dataDic[@"id"];
        NSString *countStr = dataDic[@"zs"];
        jumpVC.title = [NSString stringWithFormat:@"%@（%@）",dataDic[@"gname"],countStr.length==0?@"0":countStr];
        [jumpVC creatBackButtonWithPushType:Push];
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else
    {
        NSString *userId = @"";
        if (_selectedType==SelectedTypeAllContact)
        {
            NSDictionary *dataDic =nil;
            if (tableView!=_tableView)
            {
                dataDic =  _searchResultArr[indexPath.section];
            }
            else
            {
                dataDic = _dataArr[indexPath.section];
            }
            NSDictionary *userDic = dataDic.allValues[0][indexPath.row];
            userId = userDic[@"id"];
        }
        else if (_selectedType==SelectedTypeRecentContact)
        {
            NSDictionary *dataDic = _dataArr[indexPath.row];
            userId = dataDic[@"calluserid"];;
        }
        UserInfoViewController *jumpVC = [[UserInfoViewController alloc]init];
        jumpVC.title = @"用户详情";
        jumpVC.userId = userId;
        jumpVC.isUserCenter = NO;
        [jumpVC creatBackButtonWithPushType:Push];
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}

#pragma mark UISearchDisplayDelegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    _searchResultArr = [NSMutableArray array];
    for (NSDictionary *dataDic in _dataArr)
    {
        NSArray *dataArr = dataDic.allValues[0];
        NSMutableArray *cityArr = [NSMutableArray array];
        for (NSDictionary *userDic in dataArr)
        {
            NSString *userName = userDic[@"truename"];
            NSString *departName = userDic[@"DEPTNAME"];
            NSString *userPinYName = [PinyinHelper chineseConvertToPinYin:userName];
            NSString *departPinYName = [PinyinHelper chineseConvertToPinYin:departName];
            BOOL isContain = NO;
            if ([userName rangeOfString:searchString].length!=0)
            {
                isContain = YES;
            }
            else if ([userPinYName rangeOfString:[searchString uppercaseString]].length!=0)
            {
                isContain = YES;
            }
            else if ([departName rangeOfString:searchString].length!=0)
            {
                isContain = YES;
            }
            else if ([departPinYName rangeOfString:[searchString uppercaseString]].length!=0)
            {
                isContain = YES;
            }
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
