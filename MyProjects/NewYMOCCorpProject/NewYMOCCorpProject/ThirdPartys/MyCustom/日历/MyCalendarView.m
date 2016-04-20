//
//  MyCalendarView.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/20.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "MyCalendarView.h"
#import "MyCalendarHeaderView.h"
#import "MyCalendarCell.h"
#import "MyCalendarFooterView.h"

static NSInteger MyCalendarHeaderViewTag = 1000;
static NSInteger MyCalendarFooterViewTag = 1001;

@interface MyCalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_itemArr;
    NSMutableDictionary *_selectedIndexDic;
    NSInteger _lastTouchCellRow;
    MyCalendarViewConfirmActionBlock _confirmAction;
}

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSCalendar* calendar; //日历工具 注：用于日期转换和计算


@end


@implementation MyCalendarView

#pragma mark calendar
- (NSCalendar*)calendar
{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc]
                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

#pragma mark collectionView
-(UICollectionView *)collectionView {
    if (!_collectionView) {
         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        CGFloat collectionViewHeight = 30.0*5;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-collectionViewHeight, SCREEN_WIDTH, collectionViewHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.userInteractionEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"MyCalendarCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyCalendarCell"];
    }
    return _collectionView;
}



-(instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        _jobDates = [NSMutableArray array];
        _selectedIndexDic = [NSMutableDictionary dictionary];
        //获取数据数组
       [self getDateCompentsArrWithCurrentDate:[NSDate date]];
        
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        
        UIView* backView = [[UIView alloc] initWithFrame:self.bounds];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(dismiss)]];
        backView.userInteractionEnabled = YES;
        [self addSubview:backView];


        MyCalendarHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"MyCalendarHeaderView" owner:nil options:nil]lastObject];
        [headerView.dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [headerView.confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        headerView.width = SCREEN_WIDTH;
        headerView.tag = MyCalendarHeaderViewTag;
        [self addSubview:headerView];
        [self addSubview:self.collectionView];
     
        backView.height = self.height - _collectionView.height;
        
        MyCalendarFooterView *footView = [[[NSBundle mainBundle]loadNibNamed:@"MyCalendarFooterView" owner:nil options:nil]lastObject];
        footView.width = SCREEN_WIDTH;
        [footView.pageBtn addTarget:self action:@selector(pageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        footView.tag = MyCalendarFooterViewTag;
        [self addSubview:footView];
        //设置当前日期
        [self changeHeaderViewWithPage:0];
        //设置viewFrame
        CGFloat totalHeight = headerView.height+_collectionView.height+footView.height;
        headerView.top = self.height;
        _collectionView.top = headerView.bottom;
        footView.top = _collectionView.bottom;
        backView.height = self.height-totalHeight;
        
    }
    return self;
}

#pragma mark 确认动作
-(void)calenderConfirmAction:(MyCalendarViewConfirmActionBlock)confirmAction {
    _confirmAction = confirmAction;
}

#pragma mark 确认按钮动作
-(void)confirmBtnAction {
    if (_confirmAction) {
        [_jobDates sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            YMJobDateInfo *info1 = (YMJobDateInfo *)obj1;
            YMJobDateInfo *info2 = (YMJobDateInfo *)obj2;
            if (info1.workDate>info2.workDate) {
                return NSOrderedDescending;
            }
            else if (info1.workDate==info2.workDate) {
                return NSOrderedSame;
            }
            else {
                return NSOrderedAscending;
            }
        }];
        
        _confirmAction();
        [self dismiss];
    }
}

#pragma mark 选中的时间数组
-(void)setJobDates:(NSMutableArray *)jobDates {
    _jobDates = jobDates;
    //选中当前cell
    if (_jobDates.count!=0) {
        
        NSDateComponents *firstDateComponents = _itemArr[0][@"date"];
        NSDateComponents *currentMonthComponents = _itemArr[7][@"date"];
        NSDateComponents *lastDateComponents = [_itemArr lastObject][@"date"];
        
        NSInteger count = 0;
        for (YMJobDateInfo *dateInfo in _jobDates) {
            NSInteger rowCount=0;
            NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[ProjectUtil getDateWithTimeSp:dateInfo.workDate]];
            if (dateComponents.month==firstDateComponents.month) {
                rowCount = dateComponents.day-firstDateComponents.day;
            }
            else if (dateComponents.month==currentMonthComponents.month) {
                rowCount = dateComponents.day-currentMonthComponents.day+7;
            }
            else if (dateComponents.month==lastDateComponents.month) {
                rowCount = _itemArr.count-1-lastDateComponents.day+dateComponents.day;
            }
            //获取cell的选中状态
            MyCalendarCellType cellType = [_itemArr[rowCount][@"type"] integerValue];
            MyCalendarCellType leftCellType = MyCalendarCellTypeNone;
            if (rowCount-1>=0) {
                leftCellType = [_itemArr[rowCount-1][@"type"] integerValue];
            }
            MyCalendarCellType rightCellType = MyCalendarCellTypeNone;
            if (rowCount+1<=_itemArr.count-1) {
                rightCellType = [_itemArr[rowCount+1][@"type"] integerValue];
            }
            NSArray *cellTypesArr = [self getCellTypesWithCurrentCellType:cellType LeftCellType:leftCellType RightCellType:rightCellType];
            [self setcurrentDataWithRowCount:rowCount Type:[cellTypesArr[1] integerValue]];
            if (rowCount-1>=0) {
                [self setcurrentDataWithRowCount:rowCount-1 Type:[cellTypesArr[0] integerValue]];
            }
            if (rowCount+1<=_itemArr.count-1) {
                [self setcurrentDataWithRowCount:rowCount+1 Type:[cellTypesArr[2] integerValue]];
            }
            [_selectedIndexDic setObject:dateInfo forKey:@(rowCount)];
            count++;
        }
    }
}

#pragma mark 根据日期获取本月显示的日期
-(void)getDateCompentsArrWithCurrentDate:(NSDate *)date {
    //根据日期获取当前DateCompontents
    NSDateComponents *currentDateCompontents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSInteger currentDay = currentDateCompontents.day;
    //获取当前月份天数
    NSInteger monthLength = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    currentDateCompontents.day = monthLength;
    //获取当前月份的第一天和最后一天
    NSDate *lateDate = [self.calendar dateFromComponents:currentDateCompontents];
    currentDateCompontents.day = 1;
    NSDate *firstDate = [self.calendar dateFromComponents:currentDateCompontents];
    
    NSInteger firstDateWeekDay = [self.calendar components:NSCalendarUnitWeekday fromDate:firstDate].weekday;
    //获取上个月的最后一天和下一个月的第一天
    NSDate *lastMonthLastDate = [NSDate dateWithTimeInterval:-24*3600 sinceDate:firstDate];
    NSDate *nextMonthFirstDate = [NSDate dateWithTimeInterval:24*3600 sinceDate:lateDate];
    
    NSDateComponents *lastMonthLastDateComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:lastMonthLastDate];
    //获取日历中应加入的上一个月的日期
    _itemArr = [NSMutableArray array];
    for (NSInteger i=0; i<firstDateWeekDay-1; i++) {
        NSDateComponents *dateComponents = [lastMonthLastDateComponents copy];
        [_itemArr insertObject:@{@"date":dateComponents,@"type":@(MyCalendarCellTypeUnTouch)} atIndex:0];
        lastMonthLastDateComponents.day--;
    }
    //获取日历中应加入的本月的日期
    for (NSInteger i=0; i<monthLength; i++) {
        NSDateComponents *dateComponents = [currentDateCompontents copy];
        dateComponents.day = i+1;
        if (dateComponents.day<currentDay) {
            [_itemArr addObject:@{@"date":dateComponents,@"type":@(MyCalendarCellTypeUnTouch)}];
        }
        else {
            [_itemArr addObject:@{@"date":dateComponents,@"type":@(MyCalendarCellTypeNone)}];
        }
    }
    NSDateComponents *nextMonthFirstDateComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nextMonthFirstDate];
    NSInteger nextMonthLength = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:nextMonthFirstDate].length;
    //获取日历中应加入的下月的日期
    for (NSInteger i=0; i<nextMonthLength; i++) {
        NSDateComponents *dateComponents = [nextMonthFirstDateComponents copy];
        dateComponents.day = i+1;
        [_itemArr addObject:@{@"date":dateComponents,@"type":@(MyCalendarCellTypeNone)}];
    }
}


#pragma mark 消失
-(void)dismiss {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        MyCalendarHeaderView *headerView = (MyCalendarHeaderView *)[self viewWithTag:MyCalendarHeaderViewTag];
        MyCalendarFooterView *footView = (MyCalendarFooterView *)[self viewWithTag:MyCalendarFooterViewTag];
        headerView.top = self.height;
        _collectionView.top = headerView.bottom;
        footView.top = _collectionView.bottom;
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
        MyCalendarHeaderView *headerView = (MyCalendarHeaderView *)[self viewWithTag:MyCalendarHeaderViewTag];
        MyCalendarFooterView *footView = (MyCalendarFooterView *)[self viewWithTag:MyCalendarFooterViewTag];
        CGFloat totalHeight = headerView.height+_collectionView.height+footView.height;
        headerView.top = self.height-totalHeight;
        _collectionView.top = headerView.bottom;
        footView.top = _collectionView.bottom;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    } completion:nil];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCalendarCell" forIndexPath:indexPath];
    
    NSDictionary *dataDic = _itemArr[indexPath.row];
    NSDateComponents *dateComponents = dataDic[@"date"];
    cell.type = (MyCalendarCellType)[dataDic[@"type"] integerValue];
    cell.itemLabel.text = [NSString stringWithFormat:@"%ld",(long)dateComponents.day];
  
    return cell;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger remainCount = (NSInteger)SCREEN_WIDTH%7;
    CGFloat cellWidth = floorf(SCREEN_WIDTH/7.0);
    if ((indexPath.row%7)<=remainCount-1) {
        cellWidth += 1;
    }
    return CGSizeMake(cellWidth, 30.0);
}

#pragma mark pageControlChangeAction
-(void)pageBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self changeHeaderViewWithPage:1];
        [_collectionView setContentOffset:CGPointMake(0, _collectionView.height) animated:YES];
    }
    else {
        [self changeHeaderViewWithPage:0];
          [_collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark 根据页数改变footView日期
-(void)changeHeaderViewWithPage:(NSInteger)page {
    MyCalendarHeaderView *headerView = [self viewWithTag:MyCalendarHeaderViewTag];
    NSDate *date = [NSDate date];
    if (page!=0) {
        NSDateComponents *dateComponents = [_itemArr lastObject][@"date"];
        
        date = [self.calendar dateFromComponents:dateComponents];
        
    }
    NSString *dateStr = [ProjectUtil changeToDateWithSp:[[ProjectUtil getTimeSpWithDate:date]integerValue] Format:@"yyyy年MM月"];
    headerView.yearLabel.text = dateStr;

    
}

#pragma mark 触摸开始
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_collectionView];
    NSInteger rowCount = [self getRowCountWithPoint:point];

    _lastTouchCellRow = [self getRowCountWithPoint:point];
    [self changeCellWithRowCount:rowCount];
}
#pragma mark 触摸中
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_collectionView];
    NSInteger currentRow = [self getRowCountWithPoint:point];
    if (_lastTouchCellRow!=currentRow) {
        [self changeCellWithRowCount:currentRow];
        _lastTouchCellRow = currentRow;
    }
}

#pragma mark 根据触摸位置获取当前cell
-(MyCalendarCell *)getCellWithCGPoint:(CGPoint)point {
    
    MyCalendarCell *cell = (MyCalendarCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self getRowCountWithPoint:point] inSection:0]];
    return cell;
}

#pragma mark 根据触摸位置获取当前rowCount

-(NSInteger)getRowCountWithPoint:(CGPoint)point {
    NSInteger rowIndex = (NSInteger)floorf(point.y/30.0);
    NSInteger rankIndex = (NSInteger)floorf(point.x/(SCREEN_WIDTH/7.0));
    
    //获取当前页数
    MyCalendarHeaderView *headerView = (MyCalendarHeaderView *)[self viewWithTag:MyCalendarHeaderViewTag];
    NSInteger page = 0;
    if (headerView.confirmBtn.selected) {
        page = 1;
    }
    return rowIndex*7+rankIndex+page*35;
}

#pragma mark 根据触摸位置改变当前cell状态
-(void)changeCellWithRowCount:(NSInteger)rowCount {
    //当前cell
    
    MyCalendarCell *cell = (MyCalendarCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:rowCount inSection:0]];
    MyCalendarCell *leftCell = (MyCalendarCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:rowCount-1 inSection:0]];
    MyCalendarCell *rightCell = (MyCalendarCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:rowCount+1 inSection:0]];
    if (cell) {
        if (cell.type!=MyCalendarCellTypeUnTouch) {
            //判断是保存选中数据还是删除数据
            BOOL save = NO;
            if (cell.type==MyCalendarCellTypeNone) {
                save = YES;
            }
            
            NSArray *cellTypes = [self getCellTypesWithCurrentCellType:cell.type LeftCellType:leftCell.type RightCellType:rightCell.type];
            leftCell.type = [cellTypes[0] integerValue];
            cell.type = [cellTypes[1] integerValue];
            rightCell.type = [cellTypes[2] integerValue];
            
            if (save) {
                YMJobDateInfo *dateInfo = [[YMJobDateInfo alloc]init];
                dateInfo.total = _defaultCount;
                NSDateComponents *selectedDateComponents = _itemArr[rowCount][@"date"];
                dateInfo.workDate = [[self.calendar dateFromComponents:selectedDateComponents] timeIntervalSince1970];
                [_jobDates addObject:dateInfo];
                [_selectedIndexDic setObject:dateInfo forKey:@(rowCount)];
            }
            else {
                //获取要删除的数组索引
                YMJobDateInfo *dateInfo = _selectedIndexDic[@(rowCount)] ;
                [_selectedIndexDic removeObjectForKey:@(rowCount)];
                [_jobDates removeObject:dateInfo];
            }
            
            //储存当前cell的状态
            [self setcurrentDataWithRowCount:rowCount Type:cell.type];
            
            if (leftCell) {
                [self setcurrentDataWithRowCount:rowCount-1 Type:leftCell.type];
            }
            if (rightCell) {
                [self setcurrentDataWithRowCount:rowCount+1 Type:rightCell.type];
            }
            
        }
    }
}

#pragma mark 获取Cell选中状态
-(NSArray *)getCellTypesWithCurrentCellType:(MyCalendarCellType)cellType LeftCellType:(MyCalendarCellType)leftCellType RightCellType:(MyCalendarCellType)rightCellType {
    if (cellType==MyCalendarCellTypeNone) {
        if (leftCellType==MyCalendarCellTypeSemiCircle) {
            leftCellType = MyCalendarCellTypeLeftSide;
        }
        else if (leftCellType==MyCalendarCellTypeRightSide) {
            leftCellType = MyCalendarCellTypeRectangle;
        }
        if (rightCellType==MyCalendarCellTypeSemiCircle) {
            rightCellType = MyCalendarCellTypeRightSide;
        }
        else if (rightCellType==MyCalendarCellTypeLeftSide) {
            rightCellType = MyCalendarCellTypeRectangle;
        }
        
        if (leftCellType==MyCalendarCellTypeUnTouch) {
            if (rightCellType!=MyCalendarCellTypeNone) {
                cellType = MyCalendarCellTypeLeftSide;
            }
            else {
                cellType = MyCalendarCellTypeSemiCircle;
            }
        }
        else if (leftCellType==MyCalendarCellTypeNone&&rightCellType==MyCalendarCellTypeNone) {
            cellType = MyCalendarCellTypeSemiCircle;
        }
        else if (leftCellType!=MyCalendarCellTypeNone&&rightCellType!=MyCalendarCellTypeNone) {
            cellType = MyCalendarCellTypeRectangle;
        }
        else if (leftCellType==MyCalendarCellTypeNone) {
            cellType = MyCalendarCellTypeLeftSide;
        }
        else if (rightCellType==MyCalendarCellTypeNone) {
            cellType = MyCalendarCellTypeRightSide;
        }
    }
    else {
        cellType = MyCalendarCellTypeNone;
        if (rightCellType==MyCalendarCellTypeRightSide) {
            rightCellType = MyCalendarCellTypeSemiCircle;
        }
        else if (rightCellType==MyCalendarCellTypeRectangle) {
            rightCellType = MyCalendarCellTypeLeftSide;
        }
        
        if (leftCellType==MyCalendarCellTypeLeftSide) {
            leftCellType = MyCalendarCellTypeSemiCircle;
        }
        else if (leftCellType==MyCalendarCellTypeRectangle) {
            leftCellType = MyCalendarCellTypeRightSide;
        }
    }
    return @[@(leftCellType),@(cellType),@(rightCellType)];
}

#pragma mark 设置当前数据状态
-(void)setcurrentDataWithRowCount:(NSInteger)rowCount Type:(MyCalendarCellType)type {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:_itemArr[rowCount]];
    [dataDic setObject:@(type) forKey:@"type"];
    [_itemArr replaceObjectAtIndex:rowCount withObject:[NSDictionary dictionaryWithDictionary:dataDic]];
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
