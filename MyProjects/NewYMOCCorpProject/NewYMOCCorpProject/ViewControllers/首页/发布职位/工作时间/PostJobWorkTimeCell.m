//
//  PostJobWorkTimeCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/22.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostJobWorkTimeCell.h"
#import "PostJobRightChooseCell.h"
#import "PostJobBottomAddCell.h"
#import "PostJobWorkTimeItemCell.h"
#import "PostWorkTimeChooseView.h"

@interface PostJobWorkTimeCell ()<UITableViewDelegate,UITableViewDataSource>
{
    PostJobWorkTimeChangeBlock _changeBlock;
}

@property (nonatomic,assign) PostJobStatus postJobStatus;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UILabel *titleLabel;


@end

@implementation PostJobWorkTimeCell

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [ProjectUtil getDefaultTableViewWithType:TableViewTypeFullSeparator];
        _tableView.left = 100.0;
        _tableView.width = PostJobRightContentWidth;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource =self;
    }
    return _tableView;
}

-(UIButton *)unLimitBtn {
    if (!_unLimitBtn) {
        _unLimitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _unLimitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_unLimitBtn setImage:[UIImage imageNamed:@"fbzw_Bx"] forState:UIControlStateNormal];
        [_unLimitBtn setImage:[UIImage imageNamed:@"fszw_gou"] forState:UIControlStateSelected];
        [_unLimitBtn setTitle:@"不限工作时间" forState:UIControlStateNormal];
        [_unLimitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_unLimitBtn setTitle:@"不限工作时间" forState:UIControlStateSelected];
        [_unLimitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_unLimitBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        _unLimitBtn.titleLabel.font = FONT(14);
        [_unLimitBtn addTarget:self action:@selector(unLimitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unLimitBtn;
}

#pragma mark titleLabel
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 70, 20)];
        _titleLabel.font = FONT(15);
        _titleLabel.textColor = DefaultGrayTextColor;
        _titleLabel.text = @"工作时间";
    }
    return _titleLabel;
}

#pragma mark workTime
-(void)setWorkTimes:(NSMutableArray *)workTimes {
    _workTimes = workTimes;
    
    _tableView.height = [PostJobWorkTimeCell getCellHeightWithDataCount:workTimes.count PostJobStatus:_postJobStatus];
    
    [_tableView reloadData];
}

-(instancetype)initWithJobStatus:(PostJobStatus)jobStatus reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    _postJobStatus = jobStatus;
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.tableView];
        if (_postJobStatus!=PostJobStatusDetail) {
            //创建tableview的footView
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, 40.0)];
            footView.backgroundColor = [UIColor whiteColor];
            self.unLimitBtn.frame = CGRectMake(0, 0, footView.width, footView.height);
            [footView addSubview:self.unLimitBtn];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, footView.width, 0.5)];
            lineView.backgroundColor = DefaultBackGroundColor;
            [footView addSubview:lineView];
            _tableView.tableFooterView = footView;
        }
    }
    return self;
}

#pragma mark 不限工作时间按钮
-(void)unLimitBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _workTimes = [NSMutableArray array];
    if (_changeBlock) {
        _changeBlock();
    }
}

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark 根据数据数量获取cell应展示高度
+(CGFloat)getCellHeightWithDataCount:(NSInteger)dataCount PostJobStatus:(PostJobStatus)jobStatus {
    
    if (jobStatus!=PostJobStatusDetail) {
        if (dataCount==0) {
            return 44.0+40.0;
        }
        else {
            if (dataCount<3) {
                return 40.0+dataCount*30.0+55.0;
            }
            else {
                return dataCount*30.0+40.0;
            }
        }
    }
    else {
        if (dataCount==0) {
            return 44.0;
        }
        
        else {
            return dataCount*30.0;
        }
    }
    
}

#pragma mark 获取选择后的时间字符串
-(void)postWorkTimeChanged:(PostJobWorkTimeChangeBlock)changeBlock {
    _changeBlock = changeBlock;
}


#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_postJobStatus==PostJobStatusDetail) {
        if (_workTimes.count==0) {
            return 1;
        }
        return _workTimes.count;
    }
    else if (_workTimes.count>=3) {
        return _workTimes.count;
    }
    return _workTimes.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_workTimes.count==0&&indexPath.row==0) {
         return 44.0;
    }
    else if (_workTimes.count!=0&&indexPath.row==_workTimes.count)
    {
        return 55.0;
    }
    return 30.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_workTimes.count==0&&indexPath.row==0) {
        static NSString *identifier = @"ChooseCell";
        PostJobRightChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PostJobRightChooseCell" owner:nil options:nil]lastObject];
            if (_postJobStatus!=PostJobStatusDetail) {
                [cell.chooseBtn addTarget:self action:@selector(chooseWorkTimeAction) forControlEvents:UIControlEventTouchUpInside]; 
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                cell.layoutMargins = UIEdgeInsetsZero;
            }
        }
        if (_unLimitBtn.selected) {
            [cell.chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.chooseBtn setTitle:@"不限" forState:UIControlStateNormal];
        }
        else {
            [cell.chooseBtn setTitleColor:DefaultPlaceholderColor forState:UIControlStateNormal];
            [cell.chooseBtn setTitle:@"选择工作时间" forState:UIControlStateNormal];
        }
        return cell;
    }
    else if (_workTimes.count!=0&&indexPath.row==_workTimes.count) {
        static NSString *identifier = @"PostJobBottomAddCell";
        PostJobBottomAddCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PostJobBottomAddCell" owner:nil options:nil]lastObject];
            [cell.addBtn addTarget:self action:@selector(addWorkTimeAction) forControlEvents:UIControlEventTouchUpInside];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                cell.layoutMargins = UIEdgeInsetsZero;
            }
        }
        [cell.addBtn setTitle:@"+增加工作时间" forState:UIControlStateNormal];
        return cell;
    }
    else {
        PostJobWorkTimeItemCellType cellType = PostJobWorkTimeItemCellTypeDelete;
        if (_postJobStatus==PostJobStatusDetail) {
            cellType = PostJobWorkTimeItemCellTypeDetail;
        }
        PostJobWorkTimeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[PostJobWorkTimeItemCell getReuserIdentifierWithType:cellType]];
        if (!cell) {
            cell = [[PostJobWorkTimeItemCell alloc]initWithType:cellType];
            if (cellType==PostJobWorkTimeItemCellTypeDelete) {
                 [cell.deleteCellBtn addTarget:self action:@selector(deleteWorkTimeAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                cell.layoutMargins = UIEdgeInsetsZero;
            }
        }
        if (cellType==PostJobWorkTimeItemCellTypeDelete) {
            cell.deleteCellBtn.tag = indexPath.row;
        }
        cell.timeLabel.text = _workTimes[indexPath.row];
        return cell;
    }
}


#pragma mark 选择工作时间
-(void)chooseWorkTimeAction {
    [self.superview.superview endEditing:YES];
    PostWorkTimeChooseView *chooseView = [[PostWorkTimeChooseView alloc]init];
    PostJobWorkTimeCell *__weak weakCell = self;
    [chooseView getSelectedResult:^(NSDictionary *selectedDic) {
        [weakCell.workTimes addObject:[NSString stringWithFormat:@"%@-%@",selectedDic[@"start"],selectedDic[@"end"]]];
        weakCell.unLimitBtn.selected = NO;
        PostJobWorkTimeCell *blockCell = weakCell;
        if (blockCell->_changeBlock) {
            blockCell->_changeBlock();
        }
    }];
    [chooseView show];
}

#pragma mark 增加工作时间 
-(void)addWorkTimeAction {
    [self.superview.superview endEditing:YES];
    
    PostWorkTimeChooseView *chooseView = [[PostWorkTimeChooseView alloc]init];
    PostJobWorkTimeCell *__weak weakCell = self;
    [chooseView getSelectedResult:^(NSDictionary *selectedDic) {
        [weakCell.workTimes addObject:[NSString stringWithFormat:@"%@-%@",selectedDic[@"start"],selectedDic[@"end"]]];
        PostJobWorkTimeCell *blockCell = weakCell;
        weakCell.unLimitBtn.selected = NO;
        if (blockCell->_changeBlock) {
            blockCell->_changeBlock();
        }
    }];
    [chooseView show];
}

#pragma mark 删除工作时间 
-(void)deleteWorkTimeAction:(UIButton *)sender {
    [_workTimes removeObjectAtIndex:sender.tag];
    if (_changeBlock) {
        _changeBlock();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

@end
