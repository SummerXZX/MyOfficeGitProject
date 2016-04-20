//
//  PostSuccessCertiViewController.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/24.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostSuccessCertiViewController.h"
#import "JobsManagerViewController.h"
#import "HomeViewController.h"

@interface PostSuccessCertiViewController ()

@end

@implementation PostSuccessCertiViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
        // Do any additional setup after loading the view from its nib.
}

#pragma mark 职位管理
-(IBAction)jumpToJobManager {
    NSArray *vcsArr = self.navigationController.viewControllers;
    HomeViewController *homeVC = vcsArr[vcsArr.count-2];
    [self.navigationController popViewControllerAnimated:NO];
    [homeVC jobManagerAction];
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
