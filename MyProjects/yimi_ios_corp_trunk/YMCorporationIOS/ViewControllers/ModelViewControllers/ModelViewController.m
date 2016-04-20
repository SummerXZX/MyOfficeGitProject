//
//  ModelViewController.m
//  SalesHelper_C
//
//  Created by summer on 14-10-10.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelViewController.h"
#import "AppDelegate.h"
#import "UIView+Hint.h"

@interface ModelViewController ()<UIAlertViewDelegate> {
    BOOL _alertShow;
    NSString* _updateUrl;
}

@end

@implementation ModelViewController

-(void)dealloc {
    NSLog(@"销毁%@",NSStringFromClass([self class]));
}

#pragma mark tableView
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView =
         [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _tableView.backgroundColor = DefaultBackGroundColor;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = DefaultLineColor;
        // cell线到头
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        } // ios8SDK 兼容6 和 7 cell下划线
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配IOS7、8坐标体系
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置默认背景
    self.view.backgroundColor = DefaultBackGroundColor;
}


#pragma mark 初始化self.view上子控件View
-(void)layoutSubViews
{
    
}

#pragma mark 处理请求错误
- (void)handleErrorWithErrorResponse:(id)errorResponse
{
    YMNomalResponse *response = (YMNomalResponse *)errorResponse;
    if (response.code == ERROR_NOT_SUPPORT) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate showUpdateAlertViewWithMessage:response.codeInfo UpdateUrl:response.data];
    }
    else if (response.code == ERROR_UNAUTHORIZED || response.code == ERROR_EXPIRED_TOKEN || response.code == ERROR_INVALID_TOKEN) {
        //清空用户信息并跳入登录页面
        [ProjectUtil deleteLoginInfo];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.view.window.rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"loginNaVC"];
    }
    else {
        if (response.codeInfo.length > 20) {
            [ProjectUtil showAlert:@"提示" message:response.codeInfo];
        }
        else {
            [self.view.window makeToast:response.codeInfo];
        }
    }
}


#pragma mark 拨打电话
-(void)callWithPhoneNum:(NSString *)phoneNum
{
    NSString *urlStr = [NSString stringWithFormat:@"tel:%@",phoneNum];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    UIWebView *webView = [[UIWebView alloc]init];
    [webView loadRequest:request];
    [self.view addSubview:webView];
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
