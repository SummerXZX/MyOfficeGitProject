//
//  AnnounceDetailViewController.m
//  MyCloud
//
//  Created by test on 15/7/26.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "AnnounceDetailViewController.h"

@interface AnnounceDetailViewController ()

@property (nonatomic,retain)UILabel *titleLabel;

@property (nonatomic,retain)UILabel *timeLabel;

@property (nonatomic,retain)UILabel *contentLabel;

@property (nonatomic,retain)UIScrollView *scrollView;

@end

@implementation AnnounceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self layoutSubViews];
}

#pragma mark titleLabel
-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
        _titleLabel.font = FONT(17);
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
        _timeLabel.font = FONT(13);
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
        _contentLabel.font = FONT(15);
        _contentLabel.textColor = DefaultGrayTextColor;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0)];
        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.backgroundColor = [UIColor cyanColor];
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
    [self.view showProgressHintWith:@"加载中..."];
    [WebClient getAnnounceDetailWithParams:@{@"afficheCode":_afficheCode,@"userCode":[ProjectUtil getLoginUserCode]} Success:^(WebAnnounceDetailResponse *response) {
        [self.view dismissProgress];
        if (response.code==ResponseCodeSuceess) {
            _titleLabel.text = response.data.afficheTitle;
            _contentLabel.text = response.data.afficheContent;
            _timeLabel.text = response.data.create_time;
            [_contentLabel sizeToFit];
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _contentLabel.bottom+10.0);
        }
        else {
            [self.view showToastWith:response.codeInfo];
        }
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
