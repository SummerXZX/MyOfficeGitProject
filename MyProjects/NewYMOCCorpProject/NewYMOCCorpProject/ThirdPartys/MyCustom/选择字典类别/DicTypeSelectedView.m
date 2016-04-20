//
//  DicTypeSelectedView.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/13.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "DicTypeSelectedView.h"
#import "DicTypeHeaderView.h"
#import "DicTypeCell.h"

static CGFloat DicTypeCellHeight = 35.0;

@interface DicTypeSelectedView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    GetDicSelectedResultBlock _selectedResult;
}
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation DicTypeSelectedView

#pragma mark collectionView
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-40.0)/3.0, DicTypeCellHeight);
        layout.headerReferenceSize = CGSizeMake(0, 30);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RGBCOLOR(224, 224, 224);
        [_collectionView registerNib:[UINib nibWithNibName:@"DicTypeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DicTypeCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"DicTypeHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DicTypeHeaderView"];
    }
    return _collectionView;
}

-(instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        UIView* backView = [[UIView alloc] initWithFrame:self.bounds];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(dismiss)]];
        backView.userInteractionEnabled = YES;
        [self addSubview:backView];
        [self addSubview:self.collectionView];
    }
    return self;
}

-(void)setItemArr:(NSArray *)itemArr {
    _itemArr = itemArr;
    NSInteger rowCount = itemArr.count/3;
    if (itemArr.count%3!=0) {
        rowCount+=1;
    }
    CGFloat collectionViewHeight = 30.0+10+(10+DicTypeCellHeight)*rowCount;
    _collectionView.height = collectionViewHeight>=SCREEN_HEIGHT-30.0?SCREEN_HEIGHT-30.0:collectionViewHeight;
    _collectionView.top = self.height;
}


#pragma mark 消失
-(void)dismiss {
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _collectionView.top = SCREEN_HEIGHT;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark 显示
-(void)show {
    UIWindow *window = [ProjectUtil getCurrentWindow];
    [window addSubview:self];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _collectionView.top = self.height-_collectionView.height;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    } completion:nil];
    
}

#pragma mark 获取选择结果
-(void)getSelectedResult:(GetDicSelectedResultBlock)result {
    _selectedResult = result;
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
        cell.itemLabel.textColor = [UIColor whiteColor];
        cell.itemLabel.backgroundColor = DefaultOrangeColor;
    }
    else {
        cell.itemLabel.textColor = [UIColor blackColor];
        cell.itemLabel.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DicTypeCell *cell = (DicTypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.itemLabel.textColor = [UIColor whiteColor];
    cell.itemLabel.backgroundColor = DefaultOrangeColor;
    if (_selectedResult) {
        _selectedResult (_itemArr[indexPath.row]);
    }
    [self dismiss];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    DicTypeCell *cell = (DicTypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.itemLabel.textColor = [UIColor blackColor];
    cell.itemLabel.backgroundColor = [UIColor whiteColor];
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind==UICollectionElementKindSectionHeader) {
        DicTypeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DicTypeHeaderView" forIndexPath:indexPath];
        [headerView.topBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        return headerView;
    }
    return nil;
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
