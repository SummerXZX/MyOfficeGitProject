//
//  EvaluateEditCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/31.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "EvaluateEditCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "DicTypeCell.h"
#import "EvaluateEditCollectionViewCell.h"
#import "MyCollectionViewFlowLayout.h"

static CGFloat EvaluateEditCellCollectionCellHeight = 30.0;


@interface EvaluateEditCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    EvaluateEditCellAddBlock _addBlock;
    
}
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation EvaluateEditCell
#pragma mark collectionView
- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        MyCollectionViewFlowLayout* flowLayout =
        [[MyCollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(10, 10,
                                                    self.width - 20.0, 0)
                           collectionViewLayout:flowLayout];
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"DicTypeCell"
                                                    bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"DicTypeCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"EvaluateEditCollectionViewCell"
                                                    bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"EvaluateEditCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}


#pragma mark evaluateData
-(void)setEvaluateInfo:(YMMyEvaluateInfo *)evaluateInfo {
    _evaluateInfo = evaluateInfo;
    _collectionView.height = [EvaluateEditCell getCellHeightWithMyEvaluateInfo:evaluateInfo]-20.0;
    [_collectionView reloadData];
}

#pragma mark 获取cell高度
+(CGFloat)getCellHeightWithMyEvaluateInfo:(YMMyEvaluateInfo *)evaluateInfo{
    if (evaluateInfo.evaluateArr.count==0) {
        return 140.0;
    }
    else {
        //计算collectionview高度
        CGFloat collectionViewWidth = 0.0;
        CGFloat collectionViewHeight = EvaluateEditCellCollectionCellHeight;
        CGFloat itemSpace = 10.0;
        for (NSInteger i=0; i<evaluateInfo.evaluateArr.count+1; i++) {
            if (i<=evaluateInfo.evaluateArr.count-1) {
                YMEvaluateInfo *info = evaluateInfo.evaluateArr[i];
                collectionViewWidth += [EvaluateEditCell getCollectionItemWidthWithEvaluateInfo:info];
            }
            else {
                if (evaluateInfo.myEvaluateCount<3) {
                     collectionViewWidth +=120.0;
                }
            }
            if (i != 0) {
                collectionViewWidth += itemSpace;
            }
            if (collectionViewWidth >= (SCREEN_WIDTH-20.0)) {
                collectionViewHeight += (itemSpace + EvaluateEditCellCollectionCellHeight);
                if (i<=evaluateInfo.evaluateArr.count-1) {
                    YMEvaluateInfo *info = evaluateInfo.evaluateArr[i];
                     collectionViewWidth = [EvaluateEditCell getCollectionItemWidthWithEvaluateInfo:info];
                }
                else {
                    if (evaluateInfo.myEvaluateCount<3) {
                        collectionViewWidth = 120.0;
                    }
                }
            }
        }
        return collectionViewHeight+20.0;
    }

}

#pragma mark 增加点评
-(void)evaluateEditCellAddEvaluate:(EvaluateEditCellAddBlock)addBlock {
    _addBlock = addBlock;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}


#pragma mark 获取collectionviewItemWidth
+ (CGFloat)getCollectionItemWidthWithEvaluateInfo:(YMEvaluateInfo *)info
{
    CGFloat titleWidth = [info.describe getSizeWithFont:FONT(14)].width;
    if (info.isMyEvaluate) {
        return titleWidth +20.0;
    }
    return titleWidth + 20 + 35.0;
}


#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_evaluateInfo.evaluateArr.count==0) {
        return 0;
    }
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_evaluateInfo.myEvaluateCount>=3) {
        return _evaluateInfo.evaluateArr.count;
    }
    return _evaluateInfo.evaluateArr.count+1;
}

- (CGSize)collectionView:(UICollectionView*)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat cellWidth = 0.0;
    if (indexPath.row==_evaluateInfo.evaluateArr.count) {
        cellWidth = 120.0;
    }
    else {
        YMEvaluateInfo *info = _evaluateInfo.evaluateArr[indexPath.row];
        cellWidth = [EvaluateEditCell getCollectionItemWidthWithEvaluateInfo:info];
    }
    return CGSizeMake(MIN(self.width - 20, cellWidth),EvaluateEditCellCollectionCellHeight);
}

- (CGFloat)collectionView:(UICollectionView*)collectionView
                   layout:(UICollectionViewLayout*)
collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView
                   layout:(UICollectionViewLayout*)
collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==_evaluateInfo.evaluateArr.count) {
        DicTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DicTypeCell" forIndexPath:indexPath];
        cell.itemLabel.layer.borderColor = DefaultPlaceholderColor.CGColor;
        cell.itemLabel.layer.borderWidth = 1.0;
        cell.itemLabel.text = @"给他点评   +";
        cell.itemLabel.textColor = DefaultGrayTextColor;
        cell.itemLabel.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else {
        YMEvaluateInfo *info = _evaluateInfo.evaluateArr[indexPath.row];
        if (info.isMyEvaluate) {
            DicTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DicTypeCell" forIndexPath:indexPath];
            cell.itemLabel.text = info.describe;
            cell.itemLabel.textColor = [UIColor whiteColor];
            cell.itemLabel.layer.borderWidth  = 0.0;
            cell.itemLabel.backgroundColor = DefaultOrangeColor;
            return cell;
        }
        else {
            EvaluateEditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EvaluateEditCollectionViewCell" forIndexPath:indexPath];
            cell.countLabel.text = [NSString stringWithFormat:@"%ld",(long)info.count];
            cell.countLabel.backgroundColor = HEXCOLOR(0x82dbfe);
            cell.titleLabel.text= info.describe;
            cell.titleLabel.backgroundColor = HEXCOLOR(0x0bb8ff);
            cell.layer.masksToBounds = YES;
            cell.layer.cornerRadius = 5.0;
            return cell;
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row!=_evaluateInfo.evaluateArr.count) {
        YMEvaluateInfo *info = _evaluateInfo.evaluateArr[indexPath.row];
        if (!info.isAdded) {
            info.isAdded = YES;
            info.count+=1;
            [collectionView reloadData];
        }
    }
    else {
        if (_addBlock) {
            _addBlock();
        }
    }
}

#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *attach = [[NSTextAttachment alloc]init];
    attach.image = [UIImage imageNamed:@"pj_wpj"];
    attach.bounds = CGRectMake(0, -20, 60, 50);
    [attStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"还没有人对该同学评价哦" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:DefaultFailTitleTextColor}]];
    return attStr;
}

-(NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [[NSAttributedString alloc] initWithString:@"给他点评   +" attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:DefaultGrayTextColor}];
}

-(CGSize)buttonSizeForEmptyDataSet:(UIScrollView *)scrollView {
    return CGSizeMake(120, 30.0);
}

-(UIColor *)buttonBorderColorForEmptyDataSet:(UIScrollView *)scrollView {
    return DefaultPlaceholderColor;
}

-(CGFloat)buttonBorderWidthForEmptyDataSet:(UIScrollView *)scrollView {
    return 1.0;
}

-(CGFloat)buttonCornerRadiusForEmptyDataSet:(UIScrollView *)scrollView {
    return 5.0;
}

-(void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    if (_addBlock) {
        _addBlock();
    }
}

- (void)awakeFromNib {
    // Initialization code
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

@end
