//
//  UserGuideViewController.m
//  AnJieWealth
//
//  Created by ZhipuTech on 14-7-27.
//  Copyright (c) 2014年 deayou. All rights reserved.
//

#import "UserGuideViewController.h"

@interface UserGuideViewController ()
{
    NSArray *_imageArr;
    UIScrollView *_scrollView;
}
@end

@implementation UserGuideViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imageArr = @[@"guide1",@"guide2",@"guide3",@"guide4"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //计算contentSize宽度
    CGFloat scrollViewWidth = _imageArr.count*SCREEN_WIDTH;

    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollView.contentSize = CGSizeMake(scrollViewWidth, _scrollView.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.bounces = NO;
    
    for (int i=0; i<_imageArr.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, _scrollView.top, _scrollView.width, _scrollView.height)];
        NSString *path;
        
        if (SCREEN_HEIGHT==480)//iPhone 4s
        {
            path = [[NSBundle mainBundle] pathForResource:[_imageArr objectAtIndex:i] ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }else if (SCREEN_HEIGHT==568)//iPhone 5s
        {
            path = [[NSBundle mainBundle] pathForResource:[[_imageArr objectAtIndex:i] stringByAppendingString:@"_4inch"] ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }else if (SCREEN_HEIGHT == 1334/2) {//iPhone 6
            path = [[NSBundle mainBundle] pathForResource:[[_imageArr objectAtIndex:i] stringByAppendingString:@"_4.7inch"] ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }else if (SCREEN_HEIGHT == 1472/2) {//iPhone 6plus
            path = [[NSBundle mainBundle] pathForResource:[[_imageArr objectAtIndex:i] stringByAppendingString:@"_5.5inch"] ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }
        
        imageView.userInteractionEnabled = YES;
        if (i==_imageArr.count-1)
        {
            //创建触发按钮
            UIButton *enterAppBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat btnWidth = 130;
            CGFloat btnHeight =35;
            CGFloat reduceHeight = 50.0;
            if (SCREEN_HEIGHT>480)
            {
                reduceHeight = 75.0;
            }
           
            enterAppBtn.frame = CGRectMake((imageView.width-btnWidth)/2, (imageView.height-reduceHeight), btnWidth, btnHeight);
            [enterAppBtn setTitleColor:RGBCOLOR(47, 152, 247) forState:UIControlStateNormal];
            [enterAppBtn setTitleColor:RGBCOLOR(47, 152, 247) forState:UIControlStateHighlighted];
            [enterAppBtn setTitle:@"立 即 体 验" forState:UIControlStateNormal];
            [enterAppBtn setTitle:@"立 即 体 验" forState:UIControlStateHighlighted];
            enterAppBtn.layer.cornerRadius = 5.0;
            [enterAppBtn setBackgroundColor:[UIColor whiteColor]];
            enterAppBtn.titleLabel.font = Default_Font_17;
            [enterAppBtn addTarget:self action:@selector(enterAppAction) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:enterAppBtn];
            
        }
        [_scrollView addSubview:imageView];
    }
    [self.view addSubview:_scrollView];
}

-(void)enterAppAction
{
    //更新登录状态
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"isNotFirstStart"];
    [userDefaults synchronize];

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"loginNaVC"];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
