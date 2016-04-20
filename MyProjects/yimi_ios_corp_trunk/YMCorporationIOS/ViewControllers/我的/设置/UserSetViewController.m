//
//  UserSetViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/29.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "UserSetViewController.h"
#import "ModelWebViewController.h"
#import "FeedbackViewController.h"

@interface UserSetViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation UserSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{

    _versionLabel.text = [NSString stringWithFormat:@"iPhone %@版",[ProjectUtil getCurrentAppVersion]];
}

#pragma mark tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    if (indexPath.row==1)
    {
        [self jumpToAboutYMWithUrl:[NSString stringWithFormat:@"%@/about/corp_about.html",REQUEST_SERVER_URL]];
    }
    
   else if (indexPath.row==3)
    {
        //退出
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您确定要退出一米商家版？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [alertView show];
    }
}

#pragma mark 跳转关于一米网页
-(void)jumpToAboutYMWithUrl:(NSString *)url
{
    ModelWebViewController *webVC = [[ModelWebViewController alloc]initWithURL:[NSURL URLWithString:url]];
    webVC.title = @"关于一米商家";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        //退出操作
         [ProjectUtil deleteLoginInfo];
        
       
            self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaVC"];
    
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
