//
//  ModelTableViewController.m
//  YMCorporationIOS
//
//  Created by test on 15/6/25.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "ModelTableViewController.h"


@interface ModelTableViewController ()

@end

@implementation ModelTableViewController

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

#pragma mark 创建统一的返回按钮
-(void)creatBackButtonWithPushType:(PushType)pushType
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0,13,60);
    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    back.tag = pushType;
    [back setTitle:@"返回" forState:UIControlStateNormal];
    back.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToFormViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
}

#pragma mark 返回按钮方法
-(void)backToFormViewController:(UIButton *)sender
{
    if (sender.tag == Present)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (sender.tag == Push)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 拨打电话
-(void)callWithPhoneNum:(NSString *)phoneNum
{
//    NSString *urlStr = [NSString stringWithFormat:@"tel:%@",phoneNum];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    UIWebView *webView = [[UIWebView alloc]init];
//    [webView loadRequest:request];
//    [self.view addSubview:webView];
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel:%@",phoneNum];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
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
