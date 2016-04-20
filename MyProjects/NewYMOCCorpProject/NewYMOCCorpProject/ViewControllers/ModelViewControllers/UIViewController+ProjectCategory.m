//
//  UIViewController+ProjectCategory.m
//  NewYMOCProject
//
//  Created by test on 15/12/16.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "UIViewController+ProjectCategory.h"
#import "AppDelegate.h"

@implementation UIViewController (ProjectCategory)

#pragma mark 设置view的默认属性
-(void)setViewBasicProperty {
    //适配IOS7、8坐标体系
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置默认背景
    self.view.backgroundColor = DefaultBackGroundColor;
    if ([self isKindOfClass:[UITableViewController class]]) {
        UITableViewController *tableViewVC = (UITableViewController *)self;
        tableViewVC.tableView.separatorColor = DefaultBackGroundColor;
        tableViewVC.tableView.tableFooterView = [UIView new];
        tableViewVC.tableView.showsVerticalScrollIndicator = NO;
    }
}

#pragma mark 初始化self.view上子控件View
-(void)layoutSubViews {
    
}

#pragma mark 获取storyboard
- (UIStoryboard*)storyboard
{
    return [UIStoryboard storyboardWithName:@"Main"
                                     bundle:[NSBundle mainBundle]];
}

#pragma mark 处理请求错误
- (void)handleErrorWithErrorResponse:(id)errorResponse ShowHint:(BOOL)showHint
{
    YMNomalResponse* response = (YMNomalResponse*)errorResponse;
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    if (response.code == ERROR_NOT_SUPPORT) {
        [appDelegate showUpdateAlertViewWithMessage:response.codeInfo UpdateUrl:response.data];
    }
    else if (response.code == ERROR_UNAUTHORIZED | response.code == ERROR_EXPIRED_TOKEN | response.code == ERROR_INVALID_TOKEN) {
        //清空用户信息并跳入登录页面
        [ProjectUtil removeLoginInfo];
         appDelegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaVC"];
    }
    else {
        if (showHint) {
            if (response.codeInfo.length > 20) {
                [ProjectUtil showAlert:@"提示" message:response.codeInfo];
            }
            else {
                [appDelegate.window showFailHintWith:response.codeInfo];
            }
        }
        
    }
}



#pragma mark 拨打电话
- (void)callWithPhoneNum:(NSString*)phoneNum
{
    NSString* urlStr = [NSString stringWithFormat:@"tel:%@", phoneNum];
    NSURLRequest* request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    UIWebView* webView = [[UIWebView alloc] init];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

@end
