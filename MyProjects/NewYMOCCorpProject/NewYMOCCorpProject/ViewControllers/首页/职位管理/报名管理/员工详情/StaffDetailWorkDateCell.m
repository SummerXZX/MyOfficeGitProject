//
//  StaffDetailWorkDateCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/28.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "StaffDetailWorkDateCell.h"
#import "DicTypeCell.h"

@interface StaffDetailWorkDateCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation StaffDetailWorkDateCell

#pragma mark collectionView
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(65.0, 30.0);
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 10.0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(30, 7, SCREEN_WIDTH-30.0-65.0, 30.0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"DicTypeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DicTypeCell"];
    }
    return _collectionView;
}

-(void)setWorkDates:(NSArray *)workDates {
    _workDates = workDates;
    _collectionView.height = [StaffDetailWorkDateCell getStaffDetailWorkDateCellHeightWithDataCount:workDates.count];
    if (_collectionView.height<=30.0) {
        _moreBtn.hidden = YES;
        _moreBtn = nil;
    }
    [_collectionView reloadData];
}

- (void)awakeFromNib {
    if (!_collectionView) {
        [self.contentView addSubview:self.collectionView];
    }
    // Initialization code
}

#pragma mark 获取cell高度
+(CGFloat)getStaffDetailWorkDateCellHeightWithDataCount:(NSInteger)count {
    //获取一行显示几个日期
    NSInteger row = 0;
    CGFloat collectionViewWidth = SCREEN_WIDTH-90.0;
    CGFloat currentWidth = 70.0+10.0;
    for (NSInteger i=0; i<count; i++) {
        currentWidth +=80.0;
        row++;
        if (currentWidth>=collectionViewWidth) {
            NSInteger rowCount = count/row;
            if (count%row!=0) {
                rowCount++;
            }
            if (rowCount==1) {
                return 30.0;
            }
            else {
                CGFloat height = 40.0*rowCount+10.0;
                return height;
            }
        }
        else {
            return 30.0;
        }
       
    }
    return 0.0;
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _workDates.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DicTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DicTypeCell" forIndexPath:indexPath];
    cell.itemLabel.text = [ProjectUtil changeToDateWithSp:[_workDates[indexPath.row] integerValue] Format:@"MM月dd日"];
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

@end
