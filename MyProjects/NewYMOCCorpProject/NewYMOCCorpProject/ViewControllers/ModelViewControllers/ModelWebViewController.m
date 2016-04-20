//
//  ModelWebViewController.m
//  FunnyPie
//
//  Created by summer on 14-10-14.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelWebViewController.h"

@interface ModelWebViewController ()

@property (nonatomic, strong) UIProgressView* progressView; //进度条

@property (nonatomic, strong) NSTimer* progressTimer; //进度条计时器

@property (nonatomic, strong) NSURL* url; //加载url

@end

@implementation ModelWebViewController

#pragma mark progressView
- (UIProgressView*)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]
            initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
        _progressView.progressTintColor = DefaultBlueTextColor;
        _progressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

#pragma mark webView
- (UIWebView*)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]
            initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}

#pragma mark progressTimer
- (NSTimer*)progressTimer
{
    if (_progressView && (_progressTimer == nil)) {
        
        _progressTimer =
            [NSTimer scheduledTimerWithTimeInterval:0.005
                                             target:self
                                           selector:@selector(progressTimerAction)
                                           userInfo:nil
                                            repeats:YES];
        [_progressTimer setFireDate:[NSDate distantFuture]];
    }
    return _progressTimer;
}

- (id)initWithURL:(NSURL*)url
{
    self = [super init];
    if (self) {
        _url = url;
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:[ProjectUtil getCurrentAppVersion] forHTTPHeaderField:@"access_version"];
        [request setValue:[ProjectUtil getToken] forHTTPHeaderField:@"access_token"];
        [self.webView loadRequest:request];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self layoutSubViews];
}

- (void)layoutSubViews
{
    
}

#pragma mark 进度条计时器方法
- (void)progressTimerAction
{
    _progressView.progress += 0.005;
    if (_progressView.progress >= 0.95) {
        [self.progressTimer setFireDate:[NSDate distantFuture]];
        if (!_webView.loading) {
            _progressView.progress = 0.0;
        }
    }
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView*)webView
{

    self.progressView.progress = 0.0;
    [self.progressTimer setFireDate:[NSDate distantPast]];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
    _progressView.progress = 0.0;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [self.progressTimer setFireDate:[NSDate distantFuture]];
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    _progressView.progress = 0.0;
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
