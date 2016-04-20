//
//  ModelViewController.m
//  SalesHelper_C
//
//  Created by summer on 14-10-10.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelViewController.h"

@interface ModelViewController () {
   
}
@end

@implementation ModelViewController

#pragma mark tableView
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView =
            [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _tableView.backgroundColor = DefaultBackGroundColor;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = DefaultBackGroundColor;

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

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self creatBackButton];
}

-(UIStoryboard *)storyboard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
}


#pragma mark 创建返回按钮
-(void)creatBackButton {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //适配IOS7、8坐标体系
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置默认背景
    self.view.backgroundColor = DefaultBackGroundColor;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

}

#pragma mark 初始化self.view上子控件View
- (void)layoutSubViews
{
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
