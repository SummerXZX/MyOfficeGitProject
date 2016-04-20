//
//  StaffDetailCollectionCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/31.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "StaffDetailCollectionCell.h"
#import "DicTypeCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "LocalDicDataBaseManager.h"

static CGFloat StaffDetailCollectionCellHeight = 30.0;

@interface StaffDetailCollectionCell () <UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation StaffDetailCollectionCell

#pragma mark collectionView
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-45.0)/2.0, StaffDetailCollectionCellHeight);
        layout.minimumInteritemSpacing = 15.0;
        layout.minimumLineSpacing = 15.0;
        layout.sectionInset = UIEdgeInsetsZero;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15.0, 10,SCREEN_WIDTH-30.0,0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.backgroundColor =[UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"DicTypeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DicTypeCell"];
    }
    return _collectionView;
}

#pragma mark itemArr 
-(void)setItemArr:(NSArray *)itemArr {
    _itemArr = itemArr;
    _collectionView.height = [StaffDetailCollectionCell getCellHeightWithDataCount:itemArr.count]-20.0;
    [_collectionView reloadData];
}

#pragma mark 获取cell高度
+(CGFloat)getCellHeightWithDataCount:(NSInteger)dataCount {
    if (dataCount==0) {
        return 160.0;
    }
    NSInteger rowCount = dataCount/2;
    if (dataCount%2!=0) {
        rowCount += 1;
    }
    return rowCount*StaffDetailCollectionCellHeight+(rowCount-1)*15.0+20.0;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DicTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DicTypeCell" forIndexPath:indexPath];
    cell.itemLabel.layer.borderColor = DefaultPlaceholderColor.CGColor;
    cell.itemLabel.layer.borderWidth = 1.0;
    if ([_itemArr[indexPath.row]isKindOfClass:[YMEvaluateInfo class]]) {
        YMEvaluateInfo *info = _itemArr[indexPath.row];
        cell.itemLabel.text = [NSString stringWithFormat:@"%@%ld次",info.describe,(long)info.count];
    }
    if ([_itemArr[indexPath.row]isKindOfClass:[YMStaffDetailExperienceInfo class]]) {
        YMStaffDetailExperienceInfo *info = _itemArr[indexPath.row];
        cell.itemLabel.text = [NSString stringWithFormat:@"%@%ld次",[LocalDicDataBaseManager getNameWithType:LocalDicTypeJobType VersionId:info.jobTypeId],(long)info.workCount];
    }
    return cell;
}

#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ygxq_wjl"];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"";
    if (_isExperience) {
        title = @"该同学还没兼职经历哦";
    }
    else {
        title = @"还没有人对该同学评价哦";
    }
    return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:DefaultFailTitleTextColor}];
}


- (void)awakeFromNib {
    // Initialization code
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
