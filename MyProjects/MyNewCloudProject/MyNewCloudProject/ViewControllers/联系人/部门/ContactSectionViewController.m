//
//  ContactSectionViewController.m
//  MyCloud
//
//  Created by test on 15/7/26.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "ContactSectionViewController.h"
#import "UIView+Hint.h"
#import "ContactDepartDetailViewController.h"

@interface ContactSectionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArr;
}
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation ContactSectionViewController

#pragma mark tableView
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0-45.0) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = DefaultBackGroundColor;
        _tableView.separatorColor = DefaultBackGroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            _tableView.layoutMargins = UIEdgeInsetsZero;
        }
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            _tableView.separatorInset = UIEdgeInsetsZero;
        }
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    [self.view addSubview:self.tableView];
    //请求部门列表
    _dataArr = [NSArray array];
     [self requestDataList];
}

-(void)requestDataList
{
    if (_dataArr.count==0)
    {
        [_tableView showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载部门列表..."];
    }

    [WebClient getDepListWithParams:@{@""} Success:<#^(WebDepListResponse *response)success#>]
    WebClient *webClient = [WebClient shareClient];
    [webClient getSectionListParameters:@{@"sText":@"",@"pageIndex":@"1",@"pageSize":@"1000"} Success:^(id data) {
        [_tableView hiddenLoadingView];
        if ([data[@"code"] intValue]==0)
        {
            _dataArr = data[@"result"];
            [_tableView reloadData];
        }
        else
        {
            [self.view makeToast:data[@"message"]];
        }
    } Fail:^(NSError *error) {
         [_tableView hiddenLoadingView];
        _dataArr = [NSArray array];
        [_tableView reloadData];
        [_tableView showLoadingImageWithStatus:LoadingStatusNetError StatusStr:HintWithNetError];
    }];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dataDic = _dataArr[indexPath.row];
    NSString *countStr = dataDic[@"zs"];
    
    cell.textLabel.textColor = DefaultBlueTextColor;
    cell.textLabel.text = [NSString stringWithFormat:@"%@（%@）",dataDic[@"gname"],countStr.length==0?@"0":countStr];
    cell.textLabel.font = Default_Font_15;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
      NSDictionary *dataDic = _dataArr[indexPath.row];
    ContactDepartDetailViewController *jumpVC = [[ContactDepartDetailViewController alloc]init];
    jumpVC.sectionId = dataDic[@"id"];
     NSString *countStr = dataDic[@"zs"];
    jumpVC.title = [NSString stringWithFormat:@"%@（%@）",dataDic[@"gname"],countStr.length==0?@"0":countStr];
    [jumpVC creatBackButtonWithPushType:Push];
    [self.navigationController pushViewController:jumpVC animated:YES];
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
