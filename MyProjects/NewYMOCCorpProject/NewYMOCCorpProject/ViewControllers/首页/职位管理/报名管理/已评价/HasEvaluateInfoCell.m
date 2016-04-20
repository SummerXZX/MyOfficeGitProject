//
//  HasEvaluateInfoCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/2/26.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "HasEvaluateInfoCell.h"
#import "DicTypeCell.h"
#import "MyCollectionViewFlowLayout.h"

static CGFloat ItemInterSpace = 10.0;//内间距
static CGFloat ItemLineSpace = 10.0;//行间距
static CGFloat SectionInsertTopSpace = 10.0;//距离顶部的距离
static CGFloat SectionInsertLeftpSpace = 10.0;//距离顶部的距离
static CGFloat ItemHeight = 25.0;//cell的高度


@interface HasEvaluateInfoCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    BOOL _isMyEvaluate;
}

@property (nonatomic,strong) UICollectionView *collectionView;///<UICollectionView


@end

@implementation HasEvaluateInfoCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark UICollectionView的懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //定义 FlowLayout
        MyCollectionViewFlowLayout *flowLayout = [[MyCollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = ItemLineSpace;
        flowLayout.minimumInteritemSpacing = ItemInterSpace;
        flowLayout.sectionInset = UIEdgeInsetsMake(SectionInsertTopSpace, SectionInsertLeftpSpace, SectionInsertTopSpace, SectionInsertLeftpSpace);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"DicTypeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DicTypeCell"];
        
        //代理者
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}


#pragma mark evaluateArr
-(void)setEvaluateArr:(NSArray *)evaluateArr {
    _evaluateArr = evaluateArr;
    _collectionView.height = [HasEvaluateInfoCell getCellHeightWithEvaluateArr:evaluateArr];
    [_collectionView reloadData];
}

#pragma mark 初始化方法
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier IsMyEvaluate:(BOOL)isMyEvaluate {
    _isMyEvaluate = isMyEvaluate;
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

#pragma mark 获取tableViewCell的高度
+(CGFloat)getCellHeightWithEvaluateArr:(NSArray *)evaluateArr {
    if (evaluateArr.count==0) {
        return 0;
    }
    CGFloat collectionViewHeight = 0;
    CGFloat lineWidth = 0;
    //行数
    NSInteger lineNumber = 1;
    for (NSString *string in evaluateArr) {
        CGSize size = CGSizeMake([string getSizeWithFont:FONT(14)].width + 30, 25);
        lineWidth += size.width;
        if (lineWidth >  (SCREEN_WIDTH - SectionInsertLeftpSpace * 2)) {
            lineWidth = 0;
            lineNumber ++;
        }else {
            lineWidth += ItemInterSpace;
        }
    }
    collectionViewHeight = ItemHeight * lineNumber + (lineNumber - 1)*ItemLineSpace + SectionInsertTopSpace * 2;
    
    return collectionViewHeight;
}



#pragma mark 获取每个Item 的大小
- (CGSize)getSizeOfItemWithString:(NSString *)string {
    CGSize size = CGSizeMake([string getSizeWithFont:FONT(14)].width + 30, ItemHeight);
    return size;
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _evaluateArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = [self getSizeOfItemWithString:_evaluateArr[indexPath.row]];
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DicTypeCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"DicTypeCell" forIndexPath:indexPath];
    cell.itemLabel.text = _evaluateArr[indexPath.row];
    if (_isMyEvaluate) {
        cell.itemLabel.backgroundColor = RGBCOLOR(248, 143, 10);
    }
    else {
        cell.itemLabel.backgroundColor = RGBCOLOR(23, 168, 254);
    }
    cell.itemLabel.textColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 5;
    return cell;
}
-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
