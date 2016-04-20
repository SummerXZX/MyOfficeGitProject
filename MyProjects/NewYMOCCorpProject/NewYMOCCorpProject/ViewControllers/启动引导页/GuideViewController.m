//
//  GuideViewController.m
//  NewYMOCProject
//
//  Created by test on 15/9/1.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* contentWidth; ///<scrollview.contentsize 的宽度 注：需要代码去更新

@end

@implementation GuideViewController

#pragma mark

- (void)viewDidLoad
{

    [super viewDidLoad];
    [self setViewBasicProperty];
    NSArray* imageArr = @[ @"guide1", @"guide2", @"guide3" ,@"guide4" ];
    //计算contentSize宽度
    CGFloat scrollViewWidth = imageArr.count * SCREEN_WIDTH;
    self.contentWidth.constant = scrollViewWidth;

    UIScrollView* scrollView =
        [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollView.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.directionalLockEnabled = YES;
    scrollView.bounces = NO;

    for (NSInteger i = 0; i < imageArr.count; i++) {
        UIImageView* imageView = [[UIImageView alloc]
            initWithFrame:CGRectMake(SCREEN_WIDTH * i, scrollView.top,
                              scrollView.width, scrollView.height)];

        if (SCREEN_HEIGHT == 480.0) // iPhone 4s
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [imageArr objectAtIndex:i]]];
        }
        else if (SCREEN_HEIGHT == 568.0) // iPhone 5s
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [[imageArr objectAtIndex:i] stringByAppendingString:@"_4inch"]]];
        }
        else if (SCREEN_HEIGHT == 1334 / 2.0) { // iPhone 6

            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [[imageArr objectAtIndex:i] stringByAppendingString:@"_4.7inch"]]];
        }
        else if (SCREEN_HEIGHT == 1472 / 2.0) { // iPhone 6plus

            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [[imageArr objectAtIndex:i] stringByAppendingString:@"_5.5inch"]]];
        }

        imageView.userInteractionEnabled = YES;
        if (i == imageArr.count - 1) {
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                        action:@selector(enterAppAction)];
            [imageView addGestureRecognizer:tap];
        }
        [scrollView addSubview:imageView];
    }
    [self.view addSubview:scrollView];
}

#pragma mark 进入APP
- (void)enterAppAction
{
    [ProjectUtil showLog:@"进入APP"];

    //更新是否第一次启动状态
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"isNotFirstStart"];
    [userDefaults synchronize];

    [ProjectUtil showLog:@"跳转登录"];

    self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNaVC"];

}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
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
