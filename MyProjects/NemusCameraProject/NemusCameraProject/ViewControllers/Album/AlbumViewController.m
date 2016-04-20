//
//  AlbumViewController.m
//  NemusCameraProject
//
//  Created by Summer on 16/4/16.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumPhotoCell.h"
#import "AlbumManager.h"
#import "MyPhotoBrowserViewController.h"

static CGFloat InsetMargin = 15.0;
static CGFloat ItemSpace = 10.0;

@interface AlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *photosArr;
@property (strong, nonatomic) NSArray *thumbArr;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation AlbumViewController

#pragma mark collectionView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemSize = (SCREEN_WIDTH-InsetMargin*2-ItemSpace*2)/3.0;
        flowLayout.itemSize = CGSizeMake(itemSize, itemSize);
        flowLayout.sectionInset = UIEdgeInsetsMake(InsetMargin, InsetMargin, InsetMargin, InsetMargin);
        flowLayout.minimumLineSpacing = ItemSpace;
        flowLayout.minimumInteritemSpacing = ItemSpace;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[AlbumPhotoCell class] forCellWithReuseIdentifier:AlbumPhotoCellIdentifier];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBasicProperty];
    _thumbArr = [AlbumManager getAllImageURLs];
    _photosArr = [AlbumManager getAllImageURLs];
    [self.view addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(64.0, 0, 0, 0));
    }];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _thumbArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AlbumPhotoCellIdentifier forIndexPath:indexPath];
    NSURL *imageUrl = _thumbArr[indexPath.row];
    cell.photoImageView.image = [UIImage imageNamed:imageUrl.relativePath];
//    __weak typeof(cell) weakCell = cell;
//    __block UIImage *image;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        image = [UIImage imageNamed:imageUrl.relativePath];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakCell.photoImageView.image = image;
//        });
//    });

           return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MyPhotoBrowserViewController *nextVC = [[MyPhotoBrowserViewController alloc] init];
    nextVC.title = [NSString stringWithFormat:@"%ld/%ld",(long)indexPath.row+1,(long)_photosArr.count];
    nextVC.imageUrl = _photosArr[indexPath.row];
    [self.navigationController pushViewController:nextVC animated:YES];
}


-(void)dealloc {
    NSLog(@"释放%@",NSStringFromClass([self class]));
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
