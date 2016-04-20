//
//  StartAdViewController.m
//  NewYMOCProject
//
//  Created by test on 15/9/1.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "StartAdViewController.h"
#import "UIImageView+WebCache.h"
#import "HomeViewController.h"

static NSTimeInterval delayTime = 2.0; //广告显示延迟时间

@interface StartAdViewController ()
@property (strong, nonatomic) UIImageView* adImageView; ///<广告图片

@end

@implementation StartAdViewController

#pragma mark adImageView
- (UIImageView*)adImageView
{
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _adImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setViewBasicProperty];

    [self layoutSubViews];
}

- (void)layoutSubViews
{
    [super layoutSubViews];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.adImageView];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[adImageView]-120-|" options:0 metrics:nil views:@{ @"adImageView" : self.adImageView }]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[adImageView]-0-|" options:0 metrics:nil views:@{ @"adImageView" : self.adImageView }]];

    NSString* imageStr = @"";
    if (SCREEN_HEIGHT == 480.0) // iPhone 4s
    {
        imageStr = [ProjectUtil getWholeImageUrlWithResponseUrl:@"/upload/corpstart/start3.5inch.jpg"];
    }
    else if (SCREEN_HEIGHT == 568.0) // iPhone 5s
    {
        imageStr = [ProjectUtil getWholeImageUrlWithResponseUrl:@"/upload/corpstart/start4inch.jpg"];
    }
    else if (SCREEN_HEIGHT == 1334 / 2.0) { // iPhone 6

        imageStr = [ProjectUtil getWholeImageUrlWithResponseUrl:@"/upload/corpstart/start4.7inch.jpg"];
    }
    else if (SCREEN_HEIGHT == 1472 / 2.0) { // iPhone 6plus

        imageStr = [ProjectUtil getWholeImageUrlWithResponseUrl:@"/upload/corpstart/start5.5inch.jpg"];
    }

    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    [self performSelector:@selector(jumpToChooseLogin)
               withObject:nil
               afterDelay:delayTime];
}

#pragma mark 跳转到选择登录
- (void)jumpToChooseLogin
{
    if ([ProjectUtil getLoginInfo]) {
        
        YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
        if (loginInfo.isPublish==0) {
            UIViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CorpInfoViewController"];
            nextVC.title = @"完善商家信息";
            self.view.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:nextVC];
        }
        else {
            [ProjectUtil showLog:@"跳转首页"];
            self.view.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc] init]];
        }
    }
    else {
        [ProjectUtil showLog:@"跳转登录"];
        self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaVC"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
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
