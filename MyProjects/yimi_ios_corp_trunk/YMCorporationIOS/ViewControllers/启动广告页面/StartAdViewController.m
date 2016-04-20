//
//  StartAdViewController.m
//  YimiJob
//
//  Created by test on 15/4/13.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "StartAdViewController.h"
#import "UIImageView+WebCache.h"

static NSTimeInterval delayTime = 1.5;

@interface StartAdViewController ()

@end

@implementation StartAdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //获取广告页图片
    [self getAdImage];
}

#pragma mark 获取广告页图片
-(void)getAdImage
{

    [YMWebServiceClient getStartAdWithSuccess:^(YMStartAdResponse *response) {
        if (response.code==200)
        {
            [_adImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUST_IMAGE_URL,response.data.startscreen]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        }
        else
        {
        }
        [self performSelector:@selector(jumpToHome) withObject:nil afterDelay:delayTime];
    } ];
}

#pragma mark 跳转到首页
-(void)jumpToHome
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"TabbarVC"];
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
