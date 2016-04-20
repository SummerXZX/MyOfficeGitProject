//
//  HomeViewController.m
//  NemusCameraProject
//
//  Created by Summer on 16/4/15.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "HomeViewController.h"
#import <GPUImage.h>
#import "HomeFilterTypeCell.h"
#import "AlbumManager.h"
#import "AlbumViewController.h"

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *lastPhotoBtn;///<最新的一张图片

@property (strong, nonatomic) GPUImageStillCamera *stillCamera;///<相机
@property (strong, nonatomic) GPUImageOutput<GPUImageInput> *filter;///<过滤器
@property (strong, nonatomic) GPUImageView *filterView;///<过滤view

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIButton *dismissBtn;///<消失按钮

@property (assign, nonatomic) NSInteger currentFilterType;///<当前类型

@property (strong, nonatomic) NSArray *filterTypeArr;///<滤镜类型数组

@property (strong, nonatomic) UIImageView *focusView;///<自动对焦view

@end

@implementation HomeViewController

#pragma mark stillCamera
- (GPUImageStillCamera *)stillCamera {
    if (!_stillCamera) {
        _stillCamera = [[GPUImageStillCamera alloc] init];
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _stillCamera.shouldSmoothlyScaleOutput = YES;
    }
    return _stillCamera;
}

#pragma mark filter
- (GPUImageOutput *)filter {
    if (!_filter) {
        _filter = [[GPUImageFilter alloc] init];
        _filter.shouldSmoothlyScaleOutput = YES;
    }
    return _filter;
}

#pragma mark filterView
- (GPUImageView *)filterView {
    if (!_filterView) {
        _filterView = [[GPUImageView alloc] init];
        _filterView.fillMode = kGPUImageFillModeStretch;
    }
    return _filterView;
}

#pragma mark collectionView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(80, 90);
        CGFloat space = 10.0;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, space, 5, space);
        flowLayout.minimumLineSpacing = space;
        flowLayout.minimumInteritemSpacing = space;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 100) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeFilterTypeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:HomeFilterTypeCellIdentifier];
        _collectionView.backgroundColor = RGBCOLOR(37, 37, 37);
    }
    return _collectionView;
}

#pragma mark dismissBtn
- (UIButton *)dismissBtn {
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissBtn.frame = CGRectMake(0, _collectionView.bottom, SCREEN_WIDTH, 20.0);
        [_dismissBtn setImage:[UIImage imageNamed:@"home_down"] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismissBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

#pragma mark focusView
- (UIImageView *)focusView {
    if (!_focusView) {
        _focusView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_focusing"]];
        CGFloat focusViewSize = 80.0;
        _focusView.frame = CGRectMake((SCREEN_WIDTH-focusViewSize)/2.0, (SCREEN_HEIGHT-64.0-_collectionView.height-_dismissBtn.height)/2.0,focusViewSize,focusViewSize);
        _focusView.hidden = YES;
    }
    return _focusView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self setEmptyBackButtonTitle];
    _filterTypeArr = @[@"None",@"Cold",@"Emboss",@"Gray",@"Mono",@"Pink",@"SobelEdge",@"Swirl",@"ToneCurve",@"Bulgeout"];
    _currentFilterType = 1;
    UIButton *changeCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeCamera setImage:[UIImage imageNamed:@"home_cameraflip"] forState:UIControlStateNormal];
    changeCamera.frame = CGRectMake(0, 0, 45.0, 32.0);
    [changeCamera addTarget:self action:@selector(changeCameraAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changeCamera];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)]];
    [self.view addSubview:self.filterView];
    
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.stillCamera addTarget:self.filter];
    [self.filter addTarget:self.filterView];
    [self.stillCamera startCameraCapture];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.dismissBtn];
    [self.view addSubview:self.focusView];
    
    [self.view sendSubviewToBack:self.filterView];
    [self updateCurrentImage];
}

#pragma mark 切换摄像头
- (void)changeCameraAction {

    CATransition *animation = [CATransition animation];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    animation.duration = 1.0f;
    [_filterView.layer addAnimation:animation forKey:@"oglFlipAnimation"];
    [_stillCamera rotateCamera];

}

#pragma mark 对焦手势动作
- (void)viewTapAction:(UITapGestureRecognizer *)tap {
    
    if(_stillCamera.inputCamera.position==AVCaptureDevicePositionFront)
        return;
    if(tap.state==UIGestureRecognizerStateRecognized)
    {
        //对焦
        CGPoint location=[tap locationInView:self.view];
        //对焦
        __weak typeof(self) weakSelf=self;
        [self focusOnPoint:location completionHandler:^{
            weakSelf.focusView.center=location;
            weakSelf.focusView.alpha=0.0;
            weakSelf.focusView.hidden=NO;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.focusView.alpha=1.0;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.focusView.alpha=0.0;
                }];
            }];
        }];
    }
}

#pragma mark 调整焦距
- (IBAction)adjustFocusDistance:(UISlider *)slider {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    _filterView.transform = CGAffineTransformMakeScale(slider.value, slider.value);
    [CATransaction commit];
}

#pragma mark 对某一点对焦
-(void)focusOnPoint:(CGPoint)point completionHandler:(void(^)())completionHandler
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];;
    CGPoint pointOfInterest = CGPointZero;
    CGSize frameSize = self.view.bounds.size;
    pointOfInterest = CGPointMake(point.y / frameSize.height, 1.f - (point.x / frameSize.width));
    
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        
        NSError *error;
        if ([device lockForConfiguration:&error])
        {
            
            if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance])
            {
                [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
            }
            
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            {
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                [device setFocusPointOfInterest:pointOfInterest];
            }
            
            if([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [device setExposurePointOfInterest:pointOfInterest];
                [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            
            [device unlockForConfiguration];
            if(completionHandler)
                completionHandler();
        }
    }
    else
    {
        if(completionHandler)
            completionHandler();
    }
}


#pragma mark 查看相册
- (IBAction)checkPhotoAlbum {
    AlbumViewController *nextVC = [[AlbumViewController alloc] init];
    nextVC.title = @"Album";
    [self.navigationController pushViewController:nextVC animated:YES];
}


#pragma mark 拍照
- (IBAction)playAction {
    
    //保存图片
    typeof(self) __weak weakSelf = self;
    [self.stillCamera capturePhotoAsJPEGProcessedUpToFilter:self.filter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
        NSDate *date = [NSDate date];
        
        BOOL saveSuccess = [AlbumManager saveImageWithImageData:processedJPEG ImageName:[NSString stringWithFormat:@"%ld%@.jpg",(long)[date timeIntervalSince1970],weakSelf.filterTypeArr[self.currentFilterType]]];
        if (saveSuccess) {
            [weakSelf updateCurrentImage];
        }
        else {
            [weakSelf.view showToastWith:@"保存图片失败！"];
        }
    }];
    
}

#pragma mark 更新当前图片
- (void) updateCurrentImage {
    NSURL *url = [[AlbumManager getAllThumbnailImageURLs] lastObject];
    if (url) {
        _lastPhotoBtn.hidden = NO;
        UIImage *image = [UIImage imageWithContentsOfFile:url.path];
        [_lastPhotoBtn setImage:image forState:UIControlStateNormal];
    }
    else {
        _lastPhotoBtn.hidden = YES;
    }
}

#pragma mark 添加过滤器
- (IBAction)changeFilter {
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.top = SCREEN_HEIGHT-self.collectionView.height-self.self.dismissBtn.height;
        self.dismissBtn.top = self.collectionView.bottom;
    }];
}

- (GPUImageOutput<GPUImageInput> *)getFilterWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return [[GPUImageFilter alloc] init];
            break;
        case 1:
        {
            GPUImageWhiteBalanceFilter *filter = [[GPUImageWhiteBalanceFilter alloc] init];
            filter.temperature = 4000.0;
            return filter;
        }
            break;
        case 2:
        {
            GPUImageEmbossFilter *filter = [[GPUImageEmbossFilter alloc] init];
            filter.intensity = 4.0f;
            return filter;
        }
            break;
        case 3:
        {
            return [[GPUImageGrayscaleFilter alloc] init];
        }
            break;
        case 4:
        {
            return [[GPUImageMonochromeFilter alloc] init];
        }
            break;
        case 5:
        {
            GPUImageRGBFilter *filter = [[GPUImageRGBFilter alloc] init];
            filter.red = 1.0f;
            filter.green = 0.7304685f;
            filter.blue = 0.890625f;
            return filter;
        }
            break;
        case 6:
        {
            GPUImageSobelEdgeDetectionFilter *filter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
            filter.edgeStrength = 5.0f;
            return filter;
        }
            break;
        case 7:
        {
            GPUImageSwirlFilter *filter = [[GPUImageSwirlFilter alloc] init];
            filter.radius = 0.4f;
            filter.angle = 0.2f;
            filter.center = CGPointMake(0.5f, 0.5f);
            return filter;
        }
            break;
        case 8:
        {
            GPUImageToneCurveFilter *filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"tonecurve"];
            return filter;
        }
            break;
        case 9:
        {
            GPUImageBulgeDistortionFilter *filter = [[GPUImageBulgeDistortionFilter alloc] init];
            filter.radius = 0.4f;
            filter.scale = -0.3;
            filter.center = CGPointMake(0.5f, 0.5f);
            return filter;
        }
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _filterTypeArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeFilterTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeFilterTypeCellIdentifier forIndexPath:indexPath];
    cell.filterImageView.image = [UIImage imageNamed:@"home_photo"];
    cell.filterNameLabel.text = _filterTypeArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentFilterType = indexPath.row;
    [self.stillCamera removeAllTargets];
    [self.filter removeAllTargets];
    self.filter = [self getFilterWithIndex:indexPath.row];
    [self.stillCamera addTarget:self.filter];
    [self.filter addTarget:self.filterView];
}

#pragma mark 选择滤镜消失
- (void)dismissBtnAction {
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.top = SCREEN_HEIGHT;
        self.dismissBtn.top = self.collectionView.bottom;
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
