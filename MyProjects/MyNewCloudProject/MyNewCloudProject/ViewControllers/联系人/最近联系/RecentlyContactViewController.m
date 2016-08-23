//
//  RecentlyContactViewController.m
//  MyCloud
//
//  Created by test on 15/8/3.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "RecentlyContactViewController.h"
#import "CallRecordDBManager.h"
#import "UIView+Hint.h"
#import "UserInfoViewController.h"
#import <UIImageView+WebCache.h>
#import "CallRecordCell.h"

@interface RecentlyContactViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArr;
}

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation RecentlyContactViewController

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
    _dataArr = [CallRecordDBManager getCallRecordArr];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CallRecordCell";
    CallRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CallRecordCell" owner:nil options:nil]lastObject];
    }
    //ios8SDK 兼容6 和 7
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    NSDictionary *dataDic = _dataArr[indexPath.row];
    [cell.callAvatarImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"callavatar"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    NSMutableAttributedString *userInfoArrStr = [[NSMutableAttributedString alloc]initWithString:dataDic[@"callname"] attributes:@{NSFontAttributeName:FONT(17),NSForegroundColorAttributeName:[UIColor blackColor]}];
    [userInfoArrStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",dataDic[@"callnum"]] attributes:@{NSFontAttributeName:FONT(13),NSForegroundColorAttributeName:DefaultGrayTextColor}]];
    cell.callUserInfoLabel.attributedText = userInfoArrStr;
    cell.callTimeLabel.text = [ProjectUtil changeDateToDateStr:[NSDate dateWithTimeIntervalSince1970:[dataDic[@"calltime"]integerValue]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dataDic = _dataArr[indexPath.row];
    UserInfoViewController *jumpVC = [[UserInfoViewController alloc]init];
    jumpVC.title = @"用户详情";
    jumpVC.userCode = dataDic[@"calluserid"];
    jumpVC.isUserCenter = NO;
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
