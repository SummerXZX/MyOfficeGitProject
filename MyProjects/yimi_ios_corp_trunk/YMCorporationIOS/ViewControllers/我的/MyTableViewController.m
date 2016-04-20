//
//  MyViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "MyTableViewController.h"
#import "UIImageView+WebCache.h"
#import "CorpInfoTableViewViewController.h"
#import "UserSetViewController.h"
#import "UserInfoTableViewController.h"
#import "ApplyCertificateViewController.h"
#import "MyWalletViewController.h"


@interface MyTableViewController ()<UIActionSheetDelegate>
{
    BOOL _isStartExsit;
}
@property (weak, nonatomic) IBOutlet UILabel *corpNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *corpImageView;
@property (weak, nonatomic) IBOutlet UILabel *corpInfoStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *barItem = self.tabBarController.tabBar.items[3];
    barItem.selectedImage = [[UIImage imageNamed:@"tabbar_wode_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    //请求商家信息
    [self requestCorpInfo];
}

#pragma mark 请求商家信息
-(void)requestCorpInfo
{
    [YMWebServiceClient getCorpInfoSuccess:^(YMCorpInfoResponse *response) {
        if(response.code==ERROR_OK){
            
            YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
            _balanceLabel.text = [NSString stringWithFormat:@"%.2f元",[response.data.amount doubleValue]];
            loginInfo.isPublish = response.data.isPublish;
            loginInfo.corp = response.data.corp;
            [ProjectUtil saveLoginInfo:loginInfo];
            //更新信息
            [self updateCorpInfo];
        }else{
            [self handleErrorWithErrorResponse:response];
        }
    }];
}


#pragma mark 更新商家信息
-(void)updateCorpInfo
{
    YMCorpSummary *corpInfo = [ProjectUtil getCorpInfo];
    _corpNameLabel.text = corpInfo.loginName;
    [_corpImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,corpInfo.logoscale]] placeholderImage:[UIImage imageNamed:@"my_mrtx"]];
    if ([ProjectUtil isCompleteCorpInfo])
    {
        _corpInfoStatusLabel.text = @"已完善";
    }
    else
    {
        _corpInfoStatusLabel.text = @"未完善";
    }
    if (!_isStartExsit)
    {
        //创建星级view
        for (int i=0; i<corpInfo.rank; i++)
        {
            UIImage *starImage = [UIImage imageNamed:@"my_star"];
            UIImageView *starImageV = [[UIImageView alloc]initWithFrame:CGRectMake(_corpNameLabel.left+(starImage.size.width+5)*i, _corpNameLabel.bottom+10, starImage.size.width, starImage.size.height)];
            starImageV.image = starImage;
            [_corpNameLabel.superview addSubview:starImageV];
        }
        _isStartExsit = YES;
    }
   

}


-(void)layoutSubViews
{
    
    _corpImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _corpImageView.layer.masksToBounds = YES;
    _corpImageView.layer.borderWidth = 1.0;
    
    
    
}

#pragma mark 跳转下级页面设置
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushCorpInfoVC"])
    {
        CorpInfoTableViewViewController *corpInfoVC = segue.destinationViewController;
        if ([ProjectUtil isCompleteCorpInfo])
        {
            YMCorpSummary *corpInfo = [ProjectUtil getCorpInfo];
            NSMutableDictionary *corpInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"address":corpInfo.address,@"cityId":[NSNumber numberWithInt:corpInfo.cityId],@"contact":corpInfo.contact,@"ctypeId":[NSNumber numberWithInt:corpInfo.ctypeId],@"email":corpInfo.email,@"industryId":[NSNumber numberWithInt:corpInfo.industryId],@"intro":corpInfo.intro,@"name":corpInfo.name,@"propertyId":[NSNumber numberWithInt:corpInfo.propertyId],@"sizeId":[NSNumber numberWithInt:corpInfo.sizeId],@"tel":corpInfo.tel,@"notice":corpInfo.notice}];
            corpInfoVC.corpInfoDic = corpInfoDic;
        }
        else
        {
            corpInfoVC.corpInfoDic = [NSMutableDictionary dictionary];
            
        }
    }
   
}

#pragma mark tableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = DefaultBackGroundColor;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        return 3;
    }
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
            if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
                cell.layoutMargins = UIEdgeInsetsZero;
            }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==2)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"客服电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"400-0458091", nil];
        [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=actionSheet.cancelButtonIndex)
    {
        [self callWithPhoneNum:[actionSheet buttonTitleAtIndex:buttonIndex]];
    }
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
