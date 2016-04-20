//
//  JobHistoryView.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/25.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "JobHistoryView.h"

@interface JobHistoryView ()<UITableViewDelegate,UITableViewDataSource>
{
    JobHistoryChooseJobBlock _chooseJobBlock;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *headerView;
@end

@implementation JobHistoryView

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeFullSeparator];
        _tableView.top = SCREEN_HEIGHT+30.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark headerView
-(UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, _tableView.top-30.0, self.width, 30.0)];
        _headerView.backgroundColor = RGBCOLOR(238, 238, 238);
        UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dismissBtn.frame = CGRectMake((_headerView.width-40.0)/2.0, 0,40.0, 30.0);
        [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [dismissBtn setImage:[UIImage imageNamed:@"fbzw_aJ"] forState:UIControlStateNormal];
        [_headerView addSubview:dismissBtn];
    }
    return _headerView;
}

#pragma mark itemArr
-(void)setItemArr:(NSArray *)itemArr {
    _itemArr = itemArr;
    CGFloat tableViewHeight = _itemArr.count*40.0;
    _tableView.height = tableViewHeight>=200?200:tableViewHeight;
    [_tableView reloadData];
    
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
        [self addSubview:self.tableView];
        [self addSubview:self.headerView];
    }
    return self;
}

#pragma mark 消失
-(void)dismiss {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _tableView.top = self.height+30.0;
        _headerView.top = _tableView.top-30.0;
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
        _tableView.top = self.height-_tableView.height;
        _headerView.top = _tableView.top-30.0;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    } completion:nil];
}


#pragma mark 选择某个职位
-(void)chooseJob:(JobHistoryChooseJobBlock)chooseJobBlock {
    _chooseJobBlock = chooseJobBlock;
}


#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = FONT(15);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    YMHistoryJobInfo *info = _itemArr[indexPath.row];
    cell.textLabel.text = info.name;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_chooseJobBlock) {
        
        YMHistoryJobInfo *info = _itemArr[indexPath.row];
        _chooseJobBlock(info.id);
        [self dismiss];
    }
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
