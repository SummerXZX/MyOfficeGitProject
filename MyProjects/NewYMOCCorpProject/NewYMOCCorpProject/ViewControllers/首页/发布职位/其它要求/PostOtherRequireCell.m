//
//  PostOtherRequireCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostOtherRequireCell.h"
#import "DicTypeCell.h"

static CGFloat OtherRequireCellWidth = 60.0;
static CGFloat OtherRequireCellHeight = 25.0;

@interface PostOtherRequireCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    RequireChangedBlock _changeBlock;
}


@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation PostOtherRequireCell

#pragma mark titleLabel
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 70, 20)];
        _titleLabel.font = FONT(15);
        _titleLabel.textColor = DefaultGrayTextColor;
    }
    return _titleLabel;
}

#pragma mark collectionView
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.itemSize = CGSizeMake(OtherRequireCellWidth, OtherRequireCellHeight);
        layout.minimumInteritemSpacing = 10.0;
        layout.minimumLineSpacing = 20.0;
        layout.sectionInset = UIEdgeInsetsZero;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(100.0, 10,OtherRequireCellWidth*3+20.0,0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor =[UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"DicTypeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DicTypeCell"];
    }
    return _collectionView;
}

#pragma mark itemArr
-(void)setItemArr:(NSArray *)itemArr {
    _itemArr = itemArr;
    _collectionView.height = [PostOtherRequireCell getCellHeightWithDataCount:itemArr.count]-20.0;
}

#pragma mark 获取选择结果
-(void)requireChanged:(RequireChangedBlock)changeBlock {
    _changeBlock = changeBlock;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

#pragma mark 根据项目数目获取高度
+(CGFloat)getCellHeightWithDataCount:(NSInteger)dataCount {
    NSInteger rowCount = dataCount/3;
    if (dataCount%3!=0) {
        rowCount += 1;
    }
    return rowCount*OtherRequireCellHeight+(rowCount-1)*20.0+20.0;
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
    NSDictionary *dic = _itemArr[indexPath.row];
    cell.itemLabel.text = dic[@"name"];
    
    if ([dic[@"id"] integerValue]==_selectedDicId) {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        cell.itemLabel.textColor = DefaultOrangeColor;
        cell.itemLabel.layer.borderWidth = 1.0;
        cell.itemLabel.layer.borderColor = DefaultOrangeColor.CGColor;
    }
    else {
        cell.itemLabel.textColor = HEXCOLOR(0xb5b5b5);
        cell.itemLabel.layer.borderWidth = 1.0;
        cell.itemLabel.layer.borderColor = HEXCOLOR(0xb5b5b5).CGColor;
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DicTypeCell *cell = (DicTypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.itemLabel.textColor = DefaultOrangeColor;
    cell.itemLabel.layer.borderWidth = 1.0;
    cell.itemLabel.layer.borderColor = DefaultOrangeColor.CGColor;
    _selectedDicId = [_itemArr[indexPath.row][@"id"] integerValue];
    if (_changeBlock) {
        _changeBlock();
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    DicTypeCell *cell = (DicTypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.itemLabel.textColor = HEXCOLOR(0xb5b5b5);
    cell.itemLabel.layer.borderWidth = 1.0;
    cell.itemLabel.layer.borderColor = HEXCOLOR(0xb5b5b5).CGColor;
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
