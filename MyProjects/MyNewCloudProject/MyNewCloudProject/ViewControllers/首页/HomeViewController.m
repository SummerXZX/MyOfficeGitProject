//
//  ViewController.m
//  MyCloud
//
//  Created by test on 15/7/25.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "HomeViewController.h"
#import "UserInfoViewController.h"
#import "NotiViewController.h"
#import "AnnounceViewController.h"
#import "ContactViewController.h"
#import <UIImageView+WebCache.h>

@interface HomeViewController ()

@property (strong, nonatomic)  UILabel *contactCountLabel;
@property (strong, nonatomic)  UILabel *unReadNotiLabel;
@property (strong, nonatomic)  UIImageView *avatarImageView;

@end

@implementation HomeViewController

- (UILabel *)contactCountLabel {
    if (!_contactCountLabel) {
        _contactCountLabel = [[UILabel alloc] init];
        _contactCountLabel.font = BOLDFONT(30);
        _contactCountLabel.textColor = [UIColor whiteColor];
        _contactCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contactCountLabel;
}

- (UILabel *)unReadNotiLabel {
    if (!_unReadNotiLabel) {
        _unReadNotiLabel = [[UILabel alloc] init];
        _unReadNotiLabel.textColor = [UIColor whiteColor];
        _unReadNotiLabel.backgroundColor = DefaultRedColor;
        _unReadNotiLabel.layer.cornerRadius = 15.0;
        _unReadNotiLabel.layer.masksToBounds = YES;
        _unReadNotiLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _unReadNotiLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 50.0;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    //获取登录信息
    LoginUserInfo *loginInfo = [ProjectUtil getLoginUserInfo];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",REQUEST_IMG_URL,loginInfo.userIcon]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    self.title = loginInfo.companyFullName;
//    //获取首页数据并更新UI
    [self getHomeDataAndUpdateUIIsNoti:NO];
    

}

-(void)layoutSubViews
{
    [self setViewBasicProperty];
    
    CGFloat space = 8.0;
    CGFloat viewHeight = SCREEN_HEIGHT - 64.0 - space*4;
    CGFloat subViewTop = 0.0;
    CGFloat subViewWidth = (SCREEN_WIDTH - space*3)/2.0;
    CGFloat topViewHeight = viewHeight * 0.25;
    CGFloat middleViewHeight = viewHeight*0.3;
    CGFloat bottomViewHeight = viewHeight*0.45;
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(space, space+subViewTop, subViewWidth, topViewHeight)];
    dateView.layer.borderWidth = 1.0;
    dateView.layer.borderColor = NavigationBarColor.CGColor;
    dateView.backgroundColor = [UIColor whiteColor];
    dateView.layer.cornerRadius = 5.0;
    
    //添加日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE,MMMM,d"];
    NSArray *dateInfoArr = [[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@","];
    UILabel *weakLabel = [[UILabel alloc] init];
    weakLabel.font = FONT(17);
    weakLabel.text = dateInfoArr[0];
    weakLabel.textColor = NavigationBarColor;
    [weakLabel sizeToFit];
    [dateView addSubview:weakLabel];

    [weakLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(dateView);
        make.bottom.mas_equalTo(dateView.mas_centerY).mas_offset(-10.0);
    }];
    
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.font = FONT(35);
    dayLabel.text = dateInfoArr[2];
    dayLabel.textColor = NavigationBarColor;
    [dayLabel sizeToFit];
    [dateView addSubview:dayLabel];

    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(dateView);
        make.top.mas_equalTo(dateView.mas_centerY);
    }];
    
    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.font = FONT(15);
    monthLabel.text = dateInfoArr[1];
    monthLabel.textColor = NavigationBarColor;
    [monthLabel sizeToFit];
    [dateView addSubview:monthLabel];

    [monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(dayLabel.mas_left).mas_offset(-8);
        make.baseline.mas_equalTo(dayLabel.mas_baseline);
    }];
    [self.view addSubview:dateView];
    
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.backgroundColor = NavigationBarColor;
    contactBtn.layer.cornerRadius = 5.0;
    contactBtn.frame = CGRectMake(dateView.left, dateView.bottom+space, dateView.width, bottomViewHeight);
    [contactBtn addTarget:self action:@selector(jumpToContact) forControlEvents:UIControlEventTouchUpInside];
    //添加人数
    UIImageView *contactImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lianxiren"]];
    [contactBtn addSubview:contactImageView];

    [contactImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(contactBtn);
    }];
    
    [contactBtn addSubview:self.contactCountLabel];
    [_contactCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40.0);
        make.bottom.mas_equalTo(contactImageView.mas_top).mas_offset(-8.0);
        
    }];

    UILabel *contactLabel = [[UILabel alloc] init];
    contactLabel.font = BOLDFONT(18);
    contactLabel.text = @"云端联系人";
    contactLabel.textColor = [UIColor whiteColor];
    [contactLabel sizeToFit];
    [contactBtn addSubview:contactLabel];
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contactImageView);
        make.top.mas_equalTo(contactImageView.mas_bottom).mas_offset(8.0);
    }];
    
    [self.view addSubview:contactBtn];
    
    UIButton *announceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    announceBtn.backgroundColor = NavigationBarColor;
    announceBtn.layer.cornerRadius = 5.0;
    announceBtn.frame = CGRectMake(dateView.left, contactBtn.bottom+space, dateView.width, middleViewHeight);
    [announceBtn addTarget:self action:@selector(jumpToAnnounce) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *announceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gonggao"]];
    [announceBtn addSubview:announceImageView];
    
    [announceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(announceBtn);
    }];
    
    UILabel *announceLabel = [[UILabel alloc] init];
    announceLabel.font = BOLDFONT(18);
    announceLabel.text = @"公告信息";
    announceLabel.textColor = [UIColor whiteColor];
    [announceLabel sizeToFit];
    [announceBtn addSubview:announceLabel];
    [announceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(announceImageView);
        make.top.mas_equalTo(announceImageView.mas_bottom).mas_offset(8.0);
    }];

    [self.view addSubview:announceBtn];
    
    //用户信息
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(dateView.right+space, dateView.top, dateView.width, dateView.height)];
    userInfoView.layer.borderWidth = 1.0;
    userInfoView.layer.borderColor = NavigationBarColor.CGColor;
    userInfoView.backgroundColor = [UIColor whiteColor];
    userInfoView.layer.cornerRadius = 5.0;
    
    LoginUserInfo *loginInfo = [ProjectUtil getLoginUserInfo];

    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.font = FONT(18);
    userNameLabel.textColor = NavigationBarColor;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.text = loginInfo.userName;
    [userNameLabel sizeToFit];
    [userInfoView addSubview:userNameLabel];
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(userInfoView.mas_centerY).mas_offset(-5);
    }];
    
    UILabel *userPhoneLabel = [[UILabel alloc] init];
    userPhoneLabel.font = FONT(18);
    userPhoneLabel.textColor = NavigationBarColor;
    userPhoneLabel.textAlignment = NSTextAlignmentCenter;
    userPhoneLabel.text = loginInfo.userPhone;
    [userPhoneLabel sizeToFit];
    [userInfoView addSubview:userPhoneLabel];
    
    [userPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(userInfoView.mas_centerY).mas_offset(5);
    }];
    
    [self.view addSubview:userInfoView];
    
    //通知
    UIButton *noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noticeBtn.backgroundColor = NavigationBarColor;
    noticeBtn.layer.cornerRadius = 5.0;
    noticeBtn.frame = CGRectMake(userInfoView.left, userInfoView.bottom+space, userInfoView.width, middleViewHeight);
    [noticeBtn addTarget:self action:@selector(jumpToNoti) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *noticeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongzhi"]];
    [noticeBtn addSubview:noticeImageView];
    
    [noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(noticeBtn);
        make.centerY.mas_equalTo(noticeBtn).mas_offset(-16.0);
    }];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.font = BOLDFONT(18);
    noticeLabel.text = @"未读通知";
    noticeLabel.textColor = [UIColor whiteColor];
    [noticeLabel sizeToFit];
    [noticeBtn addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(noticeImageView);
        make.top.mas_equalTo(noticeImageView.mas_bottom).mas_offset(8.0);
    }];
    
    [noticeBtn addSubview:self.unReadNotiLabel];
    _unReadNotiLabel.hidden = YES;
    [_unReadNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30.0, 30.0));
        make.left.mas_equalTo(noticeImageView.mas_right).mas_offset(-15.0);
        make.bottom.mas_equalTo(noticeImageView.mas_top).mas_equalTo(15.0);
    }];
    [self.view addSubview:noticeBtn];
    
    //个人信息
    UIButton *userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userInfoBtn.backgroundColor = NavigationBarColor;
    userInfoBtn.layer.cornerRadius = 5.0;
    userInfoBtn.frame = CGRectMake(userInfoView.left, noticeBtn.bottom+space, userInfoView.width, bottomViewHeight);
    [userInfoBtn addTarget:self action:@selector(jumpToUserInfo) forControlEvents:UIControlEventTouchUpInside];

    [userInfoBtn addSubview:self.avatarImageView];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100.0, 100.0));
        make.center.mas_equalTo(userInfoBtn);
    }];
    
    UILabel *userInfoLabel = [[UILabel alloc] init];
    userInfoLabel.font = BOLDFONT(18);
    userInfoLabel.text = @"个人信息";
    userInfoLabel.textColor = [UIColor whiteColor];
    [userInfoLabel sizeToFit];
    [userInfoBtn addSubview:userInfoLabel];
    [userInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_avatarImageView);
        make.top.mas_equalTo(_avatarImageView.mas_bottom).mas_offset(8.0);
    }];
    
    
    [self.view addSubview:userInfoBtn];

}

#pragma mark 通知消息动作
-(void)reciveNotiAction
{
    [self getHomeDataAndUpdateUIIsNoti:YES];
}

#pragma mark 获取首页数据并更新UI
-(void)getHomeDataAndUpdateUIIsNoti:(BOOL)noti
{
//    if (!noti) {
//        [self.view showProgressHintWith:@"加载中..."];
//    }
    [WebClient getHomeInfoWithParams:@{@"userCode":[ProjectUtil getLoginUserCode]} Success:^(WebHomeInfoResponse *response) {
//        [self.view dismissProgress];
        if (response.code==ResponseCodeSuceess) {
            NSInteger unReadNum = [response.data.receipt_number integerValue];
            if (unReadNum==0) {
                _unReadNotiLabel.hidden = YES;
            }
            else {
                _unReadNotiLabel.hidden = NO;
                _unReadNotiLabel.text = response.data.receipt_number;
            }
            _contactCountLabel.text = [NSString stringWithFormat:@"%@人",response.data.user_number];
        }
        else {
            [self.view showToastWith:response.codeInfo];
        }
    }];
}

#pragma mark 跳转联系人
- (void)jumpToContact
{
    ContactViewController *jumpVC = [[ContactViewController alloc]init];
    jumpVC.title = @"云端联系人";
    [self.navigationController pushViewController:jumpVC animated:YES];
}

#pragma mark 跳转通知
- (void)jumpToNoti
{
    NotiViewController *jumpVC = [[NotiViewController alloc]init];
    jumpVC.title = @"通知";
    [self.navigationController pushViewController:jumpVC animated:YES];
}
#pragma mark 跳转公告
- (void)jumpToAnnounce
{
    AnnounceViewController *jumpVC = [[AnnounceViewController alloc]init];
    jumpVC.title = @"公告";
    [self.navigationController pushViewController:jumpVC animated:YES];
}

#pragma mark 跳转个人信息
- (void)jumpToUserInfo
{
    UserInfoViewController *jumpVC = [[UserInfoViewController alloc]init];
    jumpVC.title = @"个人信息";
    jumpVC.isUserCenter = YES;
    jumpVC.userCode = [ProjectUtil getLoginUserCode];
    [self.navigationController pushViewController:jumpVC animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:HomeUpdataUINotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
