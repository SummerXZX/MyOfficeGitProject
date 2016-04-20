//
//  MyPhotoBrowserViewController.m
//  ZLAssetsPickerDemo
//
//  Created by Summer on 16/4/17.
//  Copyright © 2016年 com.zixue101.www. All rights reserved.
//

#import "MyPhotoBrowserViewController.h"

@interface MyPhotoBrowserViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MyPhotoBrowserViewController

#pragma mark scrollView
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.0;
    }
    return _scrollView;
}

#pragma mark imageView
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTap:)];
        tap.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0));
    }];
    
    self.imageView.image = [UIImage imageNamed:self.imageUrl.relativePath];
    [self.scrollView addSubview:self.imageView];
    _scrollView.contentSize = self.imageView.image.size;
    _imageView.size = CGSizeMake(self.scrollView.contentSize.width>SCREEN_WIDTH?SCREEN_WIDTH:self.scrollView.contentSize.width, self.scrollView.contentSize.height>SCREEN_HEIGHT?SCREEN_HEIGHT:self.scrollView.contentSize.height);
    _imageView.center = self.view.center;
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = RGBCOLOR(37, 37, 37);

    NSMutableArray *viewsArr = [NSMutableArray array];
    NSArray *contentsArr = @[@{@"image":@"save_download",@"title":@"Save"},
                             @{@"image":@"save_share",@"title":@"Share"},
                             @{@"image":@"save_delete",@"title":@"Delete"},
                             @{@"image":@"save_more",@"title":@"More"},
                             ];
    NSInteger btnTag = 0;
    for (NSDictionary *contentDic in contentsArr) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.tag = 0;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"save_download"]];
        imageView.image = [UIImage imageNamed:contentDic[@"image"]];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = contentDic[@"title"];
        [titleLabel sizeToFit];
        [backBtn addSubview:imageView];
        [backBtn addSubview:titleLabel];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(21, 21));
            make.centerX.mas_equalTo(backBtn).mas_offset(0.0);
            make.centerY.mas_equalTo(backBtn).mas_offset(-10.0);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0.0);
            make.right.mas_equalTo(0.0);
            make.centerY.mas_equalTo(backBtn).mas_offset(10.0);
        }];
        [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:backBtn];
        [viewsArr addObject:backBtn];
        btnTag++;
    }
    
    [viewsArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0.0 leadSpacing:0.0 tailSpacing:0.0];
    [viewsArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.0);
        make.bottom.mas_equalTo(0.0);
    }];
    
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0.0);
        make.height.mas_equalTo(60.0);
        make.left.mas_equalTo(0.0);
        make.right.mas_equalTo(0.0);
    }];
}

- (void)backBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            //保存到本地相册
            
        }
            break;
        case 1:
        {
            //分享
            UIActivityViewController *shareVC = [[UIActivityViewController alloc] initWithActivityItems:@[[UIImage imageNamed:@"auhpic"]] applicationActivities:nil];
            shareVC.excludedActivityTypes = @[UIActivityTypeAirDrop];
            [self presentViewController:shareVC animated:YES completion:NULL];
        }
            break;
        case 2:
        {
            //删除
        }
            break;
        case 3:
        {
            //更多
            
        }
        default:
            break;
    }
    UIActivityViewController *shareVC = [[UIActivityViewController alloc] initWithActivityItems:@[[UIImage imageNamed:@"auhpic"]] applicationActivities:nil];
    shareVC.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:shareVC animated:YES completion:NULL];
}

#pragma mark 图片双击手势
- (void)imageViewDoubleTap:(UITapGestureRecognizer *)sender {
    if (self.scrollView.zoomScale!=self.scrollView.maximumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }
    else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height-64.0 > scrollView.contentSize.height)?
    (scrollView.bounds.size.height-64.0 - scrollView.contentSize.height) * 0.5 : 0.0;
   
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
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
