//
//  ViewController.m
//  MyCloud
//
//  Created by test on 15/7/25.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "HomeViewController.h"
#import "UserInfo.h"

#import "UserInfoViewController.h"
#import "NotiViewController.h"
#import "AnnounceViewController.h"
#import "ContactViewController.h"
#import <UIImageView+WebCache.h>

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unReadNotiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    //获取登录信息
    UserInfo *loginInfo = [ProjectUtil getCustomObjFromUserDefaultsWithKey:@"login"];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:loginInfo.userface] placeholderImage:[UIImage imageNamed:@"touxiang"]];
}

-(void)layoutSubViews
{
    _topSpace.constant = 0.0;
    
    //获取当前日期信息
    [self getCurrentDateInfo];
    
    
    //获取登录信息
    UserInfo *loginInfo = [ProjectUtil getCustomObjFromUserDefaultsWithKey:@"login"];
    _phoneLabel.text = loginInfo.phone;
    _nameLabel.text = loginInfo.truename;
    
    //获取首页数据并更新UI
    [self getHomeDataAndUpdateUIIsNoti:NO];
    
    //注册有通知消息过来时的推送
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveNotiAction) name:HomeUpdataUINotification object:nil];
}

#pragma mark 通知消息动作
-(void)reciveNotiAction
{
    [self getHomeDataAndUpdateUIIsNoti:YES];
}

#pragma mark 获取首页数据并更新UI
-(void)getHomeDataAndUpdateUIIsNoti:(BOOL)noti
{
    WebClient *webClient =[WebClient shareClient];
    UserInfo *loginInfo = [ProjectUtil getCustomObjFromUserDefaultsWithKey:@"login"];
    if (!noti)
    {
        [self.view makeProgress:@"正在加载"];
    }
    [webClient getHomeIndexWithParameters:@{@"UserId":loginInfo.uid} Success:^(id data) {
        [self.view hiddenProgress];
        if ([data[@"code"]intValue]==0)
        {
            NSString *unReadNotiNum = data[@"result"][0][@"zs"];
            _unReadNotiLabel.text = unReadNotiNum;
            NSString *cloudUserNum = data[@"result"][1][@"zs"];
            _contactCountLabel.text = [cloudUserNum stringByAppendingString:@"人"];
        }
        else
        {
            
            [self.view makeToast:data[@"message"]];
        }
    } Fail:^(NSError *error) {
        
        [self.view hiddenProgress];
        [self.view makeToast:HintWithNetError];
    }];
}


#pragma mark 获取当前日期信息
-(void)getCurrentDateInfo
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDate *nowDate = [NSDate date];
    comps =  [calendar components:unitFlags fromDate:nowDate];
    ;
    
    _weekLabel.text = [NSString stringWithFormat:@"星期%@",[self changeNumberToChineseNum:[self getWeekDayWithWeekday:comps.weekday] Type:ChineseNumTypeWeek]];
    _monthLabel.text = [NSString stringWithFormat:@"%@月",[self
                                                          changeNumberToChineseNum:comps.month Type:ChineseNumTypeMonth]];
    _dayLabel.text = [NSString stringWithFormat:@"%ld",(long)comps.day];
}

#pragma mark 获取星期几
-(NSInteger)getWeekDayWithWeekday:(NSInteger)weekday
{
    if (weekday==1)
    {
        return 7;
    }
    else
    {
        return weekday-1;
    }
}

#pragma mark 将数字转换成中文数字
-(NSString *)changeNumberToChineseNum:(NSInteger)num Type:(ChineseNumType)type
{
    NSString *chineseNum = @"";
    if (num==1)
    {
        chineseNum = @"一";
    }
    else if (num==2)
    {
        chineseNum = @"二";
    }
    else if (num==3)
    {
        chineseNum = @"三";
    }
    else if (num==4)
    {
        chineseNum = @"四";
    }
    else if (num==5)
    {
        chineseNum = @"五";
    }
    else if (num==6)
    {
        chineseNum = @"六";
    }
    else if (num==7)
    {
        if (type==ChineseNumTypeWeek)
        {
            chineseNum = @"天";
        }
        else if(type==ChineseNumTypeMonth)
        {
            chineseNum = @"七";
        }
    }
    else if (num==8)
    {
        chineseNum = @"八";
    }
    else if (num==9)
    {
        chineseNum = @"九";
    }
    else if (num==10)
    {
        chineseNum = @"十";
    }
    else if (num==11)
    {
        chineseNum = @"十一";
    }
    else if (num==12)
    {
        chineseNum = @"十二";
    }
    
    return chineseNum;
}



#pragma mark 跳转联系人
- (IBAction)jumpToContact:(id)sender
{
    ContactViewController *jumpVC = [[ContactViewController alloc]init];
    jumpVC.title = @"云端联系人";
    [jumpVC creatBackButtonWithPushType:Push];
    [self.navigationController pushViewController:jumpVC animated:YES];
}

#pragma mark 跳转通知
- (IBAction)jumpToNoti:(id)sender
{
    NotiViewController *jumpVC = [[NotiViewController alloc]init];
    jumpVC.title = @"通知";
    [jumpVC creatBackButtonWithPushType:Push];
    [self.navigationController pushViewController:jumpVC animated:YES];
}
#pragma mark 跳转公告
- (IBAction)jumpToAnnounce:(id)sender
{
    AnnounceViewController *jumpVC = [[AnnounceViewController alloc]init];
    jumpVC.title = @"公告";
    [jumpVC creatBackButtonWithPushType:Push];
    [self.navigationController pushViewController:jumpVC animated:YES];
}

#pragma mark 跳转个人信息
- (IBAction)jumpToUserInfo:(id)sender
{
    UserInfoViewController *jumpVC = [[UserInfoViewController alloc]init];
    jumpVC.title = @"个人信息";
    jumpVC.isUserCenter = YES;
    UserInfo *loginInfo = [ProjectUtil getCustomObjFromUserDefaultsWithKey:@"login"];
    jumpVC.userId = loginInfo.uid;
    [jumpVC creatBackButtonWithPushType:Push];
    [self.navigationController pushViewController:jumpVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
