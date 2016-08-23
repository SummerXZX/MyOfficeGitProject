//
//  UIViewController+ProjectCategory.m
//  NewYMOCProject
//
//  Created by test on 15/12/16.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import "UIViewController+ProjectCategory.h"

@implementation UIViewController (ProjectCategory)

#pragma mark 设置view的默认属性
- (void)setViewBasicProperty {
    //设置默认背景
    self.view.backgroundColor = DefaultBackGroundColor;
}

#pragma mark 设置tableview的默认属性
- (void)setTableViewBasicProperty {
    [self setViewBasicProperty];
    UITableViewController *tableViewVC = (UITableViewController *)self;
    tableViewVC.tableView.tableFooterView = [[UIView alloc] init];
    tableViewVC.tableView.separatorColor = DefaultBackGroundColor;
}

#pragma mark 获取storyboard
- (UIStoryboard*)storyboard
{
    return [UIStoryboard storyboardWithName:@"Main"
                                     bundle:[NSBundle mainBundle]];
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
