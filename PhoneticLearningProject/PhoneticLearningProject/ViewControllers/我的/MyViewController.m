//
//  SecondViewController.m
//  PhoneticLearningProject
//
//  Created by test on 15/11/11.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "MyViewController.h"
#import "ChangeSchoolViewController.h"
#import "ChangeClassViewController.h"
#import "ChangeGradeViewController.h"
#import "ChangeNameViewController.h"
#import "ChangePassViewController.h"
#import "FeedbackViewController.h"


@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArr;
    WebLoginData *_userInfo;
}

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)layoutSubViews {
    
    
    UITabBarItem* barItem = self.tabBarController.tabBar.items[1];
    barItem.selectedImage = [[UIImage imageNamed:@"tabbar_my_selected"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.titleLabel.font = FONT(15);
    saveBtn.frame = CGRectMake(0, 0, 60, 30);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.tableView.height = SCREEN_HEIGHT-64.0-49.0;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    _userInfo = [ProjectUtil getLoginData];
    [self updateMyUI];
    //创建tableFootView
    [self creatTableFootView];
}

#pragma mark 创建tableFootView
-(void)creatTableFootView {
    UIView *footView  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 60.0)];
    UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOutBtn.frame  =CGRectMake(15.0, (footView.height-40.0)/2.0, footView.width-30.0, 40.0);
    loginOutBtn.backgroundColor = RGBCOLOR(255, 128, 128);
    [loginOutBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOutBtn addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:loginOutBtn];
    self.tableView.tableFooterView = footView;
}

#pragma mark 更新数据 
-(void)updateMyUI{
    _dataArr = @[@[@{@"title":@"用户名",@"detail":_userInfo.userId}],
                 @[@{@"title":@"学校",@"detail":_userInfo.address2},
                   @{@"title":@"年级",@"detail":_userInfo.grade},
                   @{@"title":@"班级",@"detail":_userInfo.school},
                   @{@"title":@"姓名",@"detail":[NSString stringWithFormat:@"%@%@",_userInfo.firstName,_userInfo.lastName]}
                   ],
                 @[@{@"title":@"意见反馈",@"detail":@""},
                   @{@"title":@"关于软件",@"detail":@""}
                   ],
                 @[@{@"title":@"密码修改",@"detail":@""}]
                 ];
    [self.tableView reloadData];
}

#pragma mark 退出登陆动作
-(void)loginOutAction {
    //清空用户信息
    [ProjectUtil removeLoginData];
    
    self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

#pragma mark 保存
-(void)saveAction {
    WebLoginData *loginData = [ProjectUtil getLoginData];
    [self.view makeProgress:@"保存中..."];
    [WebServiceClient updateUserInfoWithParams:@{@"name":loginData.userId,@"school":loginData.address2,@"grade":loginData.grade,@"classname":loginData.school,@"realName":loginData.firstName} success:^(WebNomalResponse *response) {
        [self.view hiddenProgress];
        //保存用户信息
        [ProjectUtil saveLoginData:_userInfo];
        [self.view makeToast:@"保存成功"];
    } Fail:^(NSError *error) {
        [self.view hiddenProgress];
        [self.view makeToast:error.domain];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *itemArr = _dataArr[section];
    return itemArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0.0;
    }
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headView = (UITableViewHeaderFooterView *)view;
    headView.contentView.backgroundColor = DefaultBackGroundColor;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identitfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identitfier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identitfier];
        cell.textLabel.font = FONT(15);
        cell.detailTextLabel.font = FONT(15);
        cell.detailTextLabel.textColor = DefaultGrayTextColor;
    }
    if (indexPath.section==0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    NSDictionary *dataDic = _dataArr[indexPath.section][indexPath.row];
    cell.textLabel.text = dataDic[@"title"];
    cell.detailTextLabel.text = dataDic[@"detail"];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            //修改学校
            ChangeSchoolViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeSchoolViewController"];
            nextVC.title = @"修改学校";
            nextVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nextVC animated:YES];
            [nextVC getSelectedSchool:^(id object) {
                _userInfo.address2 = object;
                [self updateMyUI];
            }];
        }
        else if (indexPath.row==1) {
            //修改年级
            ChangeGradeViewController *nextVC = [[ChangeGradeViewController alloc] init];
            nextVC.title = @"修改年级";
            nextVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nextVC animated:YES];
            [nextVC getSelectedGradeInfo:^(id object) {
                _userInfo.grade = object;
                [self updateMyUI];
            }];
        }
        else if (indexPath.row==2) {
            //修改班级
            ChangeClassViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeClassViewController"];
            nextVC.title = @"修改班级";
            nextVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nextVC animated:YES];
            [nextVC getSelectedClass:^(id object) {
                _userInfo.school = object;
                [self updateMyUI];
            }];
        }
        else if (indexPath.row==3) {
            //修改姓名
            ChangeNameViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeNameViewController"];
            nextVC.title = @"修改姓名";
            nextVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nextVC animated:YES];
            [nextVC getSelectedName:^(id object) {
                _userInfo.firstName = object;
                [self updateMyUI];
            }];
        }
    }
    else if (indexPath.section==2) {
        if (indexPath.row==0) {
            //意见反馈
            FeedbackViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
            nextVC.title = @"意见反馈";
            nextVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nextVC animated:YES];
        }
    }
    else if (indexPath.section==3) {
        if (indexPath.row==0) {
            //跳转密码修改
            ChangePassViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassViewController"];
            nextVC.title = @"修改密码";
            nextVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nextVC animated:YES];
        }
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
