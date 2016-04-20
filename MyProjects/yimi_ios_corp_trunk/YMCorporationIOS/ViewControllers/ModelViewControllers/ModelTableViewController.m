//
//  ModelTableViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ModelTableViewController.h"
#import "AppDelegate.h"
#import "UIView+Hint.h"

@interface ModelTableViewController ()

@end

@implementation ModelTableViewController

-(void)dealloc {
    NSLog(@"销毁%@",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配IOS7、8坐标体系
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置默认背景
    self.view.backgroundColor = DefaultBackGroundColor;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = DefaultBackGroundColor;
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
