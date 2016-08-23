//
//  NotiDetailViewController.m
//  MyCloud
//
//  Created by Summer on 15/7/27.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "NotiDetailViewController.h"
#import "UIView+Hint.h"
#import "ZLPhoto.h"
//#import <MWPhotoBrowser.h>

@interface NotiDetailViewController ()
{
    NSMutableArray *_photosArr;
}
@property (nonatomic,retain)UILabel *titleLabel;

@property (nonatomic,retain)UILabel *timeLabel;

@property (nonatomic,retain)UILabel *contentLabel;

@property (nonatomic,retain)UIScrollView *scrollView;

@end

@implementation NotiDetailViewController
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
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.timeLabel];
    [self.scrollView addSubview:self.contentLabel];
    [self.view addSubview:self.scrollView];
    
    if (_if_havePic)
    {
        UIButton *attachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        attachBtn.frame = CGRectMake(0, 0, 22, 22);
        [attachBtn setImage:[UIImage imageNamed:@"attach_white"] forState:UIControlStateNormal];
        [attachBtn addTarget:self action:@selector(attachBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:attachBtn];
        
    }
    
    //请求通知详情数据
    [self requestNotiDetailData];
}

//#pragma mark 跳转附件列表
-(void)attachBtnAction
{
    
    ZLPhotoPickerBrowserViewController *browser = [[ZLPhotoPickerBrowserViewController alloc] init];
    browser.photos = _photosArr;
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = FONT(15);
    [saveBtn sizeToFit];
    [saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    browser.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    [browser showPushPickerVc:self];
    
}

- (void)saveBtnAction {
    ZLPhotoPickerBrowserViewController *browser  = [self.navigationController.viewControllers lastObject];
    ZLPhotoPickerBrowserPhoto *photo = browser.photos[browser.currentIndex];
    UIActivityViewController *shareVC = [[UIActivityViewController alloc] initWithActivityItems:@[photo.photoImage] applicationActivities:nil];
    shareVC.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:shareVC animated:YES completion:NULL];
}
-(void)jumpToImageVC
{
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
//    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
//    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
//    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
//    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
//    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
//    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
//    browser.autoPlayOnAppear = NO; // Auto-play first video
//    [browser setCurrentPhotoIndex:1];
//    [self.navigationController pushViewController:browser animated:YES];
//    [browser showNextPhotoAnimated:YES];
//    [browser showPreviousPhotoAnimated:YES];
}

#pragma mark 请求通知详情数据

-(void)requestNotiDetailData
{
    
    [WebClient getNoticeDetailWithParams:@{@"notice_code":_notice_code,@"userCode":[ProjectUtil getLoginUserCode]} Success:^(WebNoticeDetailResponse *response) {
        [self.view dismissProgress];
        if (response.code==ResponseCodeSuceess) {
            _titleLabel.text = response.data.notice_title;
            _contentLabel.text = response.data.notice_content;
            _timeLabel.text = response.data.create_time;
            [_contentLabel sizeToFit];
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _contentLabel.bottom+10.0);
            _photosArr = [NSMutableArray array];
            
            for (WebNoticeImgInfo *imgInfo in response.data.noticeImg_list) {
                ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[NSString stringWithFormat:@"%@%@",REQUEST_NOTIIMG_URL,imgInfo.notice_img_addr]];
                [_photosArr addObject:photo];
            }
            
        }
        else {
            [self.view showToastWith:response.codeInfo];
        }

    }];
//    WebClient *webClient = [WebClient shareClient];
//    [self.view showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:@"正在加载通知详情..."];
//    [webClient getNoticeDetailWithParameters:@{@"NoticeId":_notiId} Success:^(id data) {
//        [self.view hiddenLoadingView];
//        if ([data[@"code"]intValue]==0)
//        {
//            NSDictionary *resultDic = data[@"result"][0];
//            _titleLabel.text = resultDic[@"title"];
//            _timeLabel.text = [resultDic[@"times"]substringToIndex:8];
//            NSString *contentStr = resultDic[@"content"];
//            _contentLabel.height = [contentStr getSizeWithFont:_contentLabel.font Width:_contentLabel.width].height;
//            _contentLabel.text = contentStr;
//            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _contentLabel.bottom);
//        }
//        else
//        {
//            [self.view makeToast:data[@"message"]];
//        }
//    } Fail:^(NSError *error) {
//        [self.view showLoadingImageWithStatus:LoadingStatusOnLoading StatusStr:HintWithNetError];
//    }];
}

//#pragma mark MWPhotoBrowserDelegate
//-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
//{
//    return _photosArr.count;
//}
//
//-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
//{
//    if (index < _photosArr.count) {
//        return [_photosArr objectAtIndex:index];
//    }
//    return nil;
//}

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
