//
//  AnnounceDetailViewController.m
//  MyCloud
//
//  Created by test on 15/7/26.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "AnnounceDetailViewController.h"
#import "UIView+Hint.h"

@interface AnnounceDetailViewController ()

@property (nonatomic,retain)UILabel *titleLabel;

@property (nonatomic,retain)UILabel *timeLabel;

@property (nonatomic,retain)UILabel *contentLabel;

@property (nonatomic,retain)UIScrollView *scrollView;

@end

@implementation AnnounceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
}

#pragma mark titleLabel
-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
        _titleLabel.font = Default_Font_17;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom, SCREEN_WIDTH, 20)];
        _timeLabel.font = Default_Font_13;
        _timeLabel.textColor = DefaultLightGrayTextColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

-(UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.timeLabel.bottom+15, SCREEN_WIDTH-30, 0)];
        _contentLabel.font = Default_Font_15;
        _contentLabel.textColor = DefaultGrayTextColor;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}


-(void)layoutSubViews
{
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.timeLabel];
    [self.scrollView addSubview:self.contentLabel];
    [self.view addSubview:self.scrollView];
    
    //请求公告详情数据
    [self requestAnnounceDetailData];
}

#pragma mark 请求公告详情数据

-(void)requestAnnounceDetailData
{
    WebClient *webClient = [WebClient shareClient];
    [self.view showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载公告详情..."];
    [webClient getAnnounceDetailWithParameters:@{@"AnnounceId":_announceId} Success:^(id data) {
        [self.view hiddenLoadingView];
        if ([data[@"code"]intValue]==0)
        {
            NSDictionary *resultDic = data[@"result"][0];
            _titleLabel.text = resultDic[@"title"];
            _timeLabel.text = [resultDic[@"times"]substringToIndex:8];
            NSString *contentStr = resultDic[@"content"];
            _contentLabel.height = [contentStr getSizeWithFont:_contentLabel.font Width:_contentLabel.width].height;
            _contentLabel.text = contentStr;
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _contentLabel.bottom);
        }
        else
        {
            [self.view makeToast:data[@"message"]];
        }
    } Fail:^(NSError *error) {
        [self.view showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:HintWithNetError];
    }];
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
