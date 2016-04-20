//
//  PostSuccessCertiViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/24.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostSuccessUnCertiViewController.h"
#import "JobsManagerViewController.h"
#import "ApplyForAuthenticateViewController.h"
#import "HomeViewController.h"

@interface PostSuccessUnCertiViewController ()

@end

@implementation PostSuccessUnCertiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}


#pragma mark 职位管理
-(IBAction)jumpToJobManager {
    
    NSArray *vcsArr = self.navigationController.viewControllers;
    HomeViewController *homeVC = vcsArr[vcsArr.count-2];
    [self.navigationController popViewControllerAnimated:NO];
    [homeVC jobManagerAction];

}

#pragma mark 申请认证 
-(IBAction)applyCerti {
    [self.navigationController popViewControllerAnimated:NO];
    UIWindow *window = [ProjectUtil getCurrentWindow];
    UINavigationController *naVC = (UINavigationController *)window.rootViewController;
    ApplyForAuthenticateViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ApplyForAuthenticateViewController"];
    nextVC.title = @"申请认证";
    [naVC pushViewController:nextVC animated:YES];
    [naVC setNavigationBarHidden:NO animated:YES];
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
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
