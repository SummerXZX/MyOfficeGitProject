//
//  HomeViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "HomeViewController.h"
#import "PostJobViewController.h"
#import "JobStatusListViewController.h"
#import "WaitInviteViewController.h"
#import "CorpInfoTableViewViewController.h"
#import "OrderStatusListViewController.h"

@interface HomeViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *notCheckLabel;
@property (weak, nonatomic) IBOutlet UILabel *toBeInvitedLabel;
@property (weak, nonatomic) IBOutlet UILabel *toBeWorkLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobCheckLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *barItem = self.tabBarController.tabBar.items[0];
    barItem.selectedImage = [[UIImage imageNamed:@"tabbar_shouye_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //请求首页数据
    [self requestHomeData];
}

-(void)layoutSubViews
{
    
}

#pragma mark 按钮块动作
- (IBAction)jumpBtnAction:(UIButton *)sender
{
    if (sender.tag==100)
    {
        [self jumpJobListWithStatus:JobStatusUnChecked];
    }
    else if (sender.tag==101)
    {
        [self jumpJobListWithStatus:JobStatusChecked];
    }
    else if (sender.tag==102)
    {
        //待签约
        WaitInviteViewController *waitInviteVC = [[WaitInviteViewController alloc]init];
        waitInviteVC.title = @"待签约";
        waitInviteVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:waitInviteVC animated:YES];
    }
    else if (sender.tag==103)
    {
        //待上岗
        OrderStatusListViewController *orderVC = [[OrderStatusListViewController alloc]init];
        orderVC.title = @"待上岗";
        orderVC.status = OrderStatusUnCharged;
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

#pragma mark 跳转职位列表
-(void)jumpJobListWithStatus:(JobStatus)status
{
    JobStatusListViewController *jobStatusVC = [[JobStatusListViewController alloc]init];
    jobStatusVC.title = status==JobStatusChecked?@"已审核":@"待审核";
    jobStatusVC.hidesBottomBarWhenPushed = YES;
    jobStatusVC.jobStatus = status;
    [self.navigationController pushViewController:jobStatusVC animated:YES];
}

#pragma mark 请求首页数据
-(void)requestHomeData
{
    [YMWebServiceClient getHomeInfoSuccess:^(YMHomeResponse *response) {
        if(response.code==ERROR_OK){
            _notCheckLabel.text = [NSString stringWithFormat:@"%d",response.data.notCheckCount];
            _toBeInvitedLabel.text =[NSString stringWithFormat:@"%d",response.data.toBeInvitedCount];
            _toBeWorkLabel.text =[NSString stringWithFormat:@"%d",response.data.toBeWorkCount];
            _jobCheckLabel.text =[NSString stringWithFormat:@"%d",response.data.jobCheckCount];
        }else{
            
        }
    }];
}

#pragma mark 跳转发布职位
- (IBAction)postJobAction:(id)sender
{
    if ([ProjectUtil isCompleteCorpInfo])
    {
        [self jumpToPostJob];
    }
    else
    {
        [YMWebServiceClient getIsCompleteCorpInfoSuccess:^(YMCompleteCorpInfoResponse *response)
         {
            if(response.code==ERROR_OK){
                if (response.data.isPublish==0)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您还未完善商家信息还不能发布职位" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去完善", nil];
                    [alertView show];
                }
                else if (response.data.isPublish==1)
                {
                    
                    YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
                    loginInfo.isPublish = 1;
                    [ProjectUtil saveLoginInfo:loginInfo];
                    [self jumpToPostJob];
                }
            }else{
                [self handleErrorWithErrorResponse:response];
            }
        }];
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        CorpInfoTableViewViewController *corpInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CorpInfoVC"];
        corpInfoVC.corpInfoDic = [NSMutableDictionary dictionary];
        [self.navigationController pushViewController:corpInfoVC animated:YES];
        
    }
}

#pragma mark 跳转到发布职位VC
-(void)jumpToPostJob
{
    PostJobViewController *postJobVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostJobVC"];
    postJobVC.title = @"发布职位";
    [self.navigationController pushViewController:postJobVC animated:YES];
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
