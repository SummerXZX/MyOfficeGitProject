//
//  ModelViewController.m
//  SalesHelper_C
//
//  Created by summer on 14-10-10.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelViewController.h"


@interface ModelViewController ()

@end

@implementation ModelViewController

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

#pragma mark 创建统一的返回按钮
-(void)creatBackButtonWithPushType:(PushType)pushType
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0,55,22);
    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    back.tag = pushType;
    [back setTitle:@"返回" forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont boldSystemFontOfSize:17];

    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    back.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
