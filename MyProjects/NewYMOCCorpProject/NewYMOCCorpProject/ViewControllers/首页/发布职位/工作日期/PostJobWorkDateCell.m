//
//  PostJobWorkDateCell.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/22.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostJobWorkDateCell.h"
#import "PostJobWorkDateItemCell.h"
#import "PostJobWorkDateFootCell.h"
#import "PostJobBottomAddCell.h"
#import "PostJobRightChooseCell.h"
#import "MyCalendarView.h"

@interface PostJobWorkDateCell ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    PostJobWorkDateDidChangeBlock _changeBlock;
}

@property (nonatomic,assign) PostJobStatus postJobStatus;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UILabel *titleLabel;


@end

@implementation PostJobWorkDateCell

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


#pragma mark titleLabel
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 70, 20)];
        _titleLabel.font = FONT(15);
        _titleLabel.textColor = DefaultGrayTextColor;
        _titleLabel.text = @"工作日期";
    }
    return _titleLabel;
}

#pragma mark jobDates
-(void)setJobDates:(NSMutableArray *)jobDates {
    _jobDates = jobDates;
    _tableView.height = [PostJobWorkDateCell getCellHeightWithDataCount:jobDates.count PostJobStatus:_postJobStatus];
    [_tableView reloadData];
}

-(instancetype)initWithJobStatus:(PostJobStatus)jobStatus reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _postJobStatus = jobStatus;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.tableView];
    }
    return self;
}

#pragma mark 获取改变的日期数组
-(void)postJobWorkDateChanged:(PostJobWorkDateDidChangeBlock)changeBlock {
    _changeBlock = changeBlock;
}

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark 根据数据数量获取cell应展示高度
+(CGFloat)getCellHeightWithDataCount:(NSInteger)dataCount PostJobStatus:(PostJobStatus)jobStatus {
    
    if (dataCount==0) {
        return 44.0;
    }
    else {
        if (jobStatus!=PostJobStatusDetail) {
            return 55.0+(dataCount+1)*30.0;
        }
        else {
            return (dataCount+1)*30.0;
        }
        
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_postJobStatus!=PostJobStatusDetail) {
         return 2+_jobDates.count;
    }
    return 1+_jobDates.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_jobDates.count==0) {
        return 44.0;
    }
    else {
        if (_jobDates.count+1==indexPath.row) {
            return 55.0;
        }
        return 30.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_jobDates.count==0) {

        static NSString *identifier = @"ChooseCell";
        PostJobRightChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PostJobRightChooseCell" owner:nil options:nil]lastObject];
            [cell.chooseBtn addTarget:self action:@selector(chooseWorkDateAction) forControlEvents:UIControlEventTouchUpInside];
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                cell.layoutMargins = UIEdgeInsetsZero;
            }
        }
        [cell.chooseBtn setTitle:@"选择工作日期" forState:UIControlStateNormal];
        return cell;
    }
    else {
        if (indexPath.row==_jobDates.count+1) {
            static NSString *identifier = @"PostJobBottomAddCell";
            PostJobBottomAddCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"PostJobBottomAddCell" owner:nil options:nil]lastObject];
                [cell.addBtn addTarget:self action:@selector(addWorkDateAction) forControlEvents:UIControlEventTouchUpInside];
                if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    cell.layoutMargins = UIEdgeInsetsZero;
                }
            }
            [cell.addBtn setTitle:@"+增加工作日期" forState:UIControlStateNormal];
            return cell;
        }
        else if (_jobDates.count==indexPath.row) {
            static NSString *identifier = @"PostJobWorkDateFootCell";
            PostJobWorkDateFootCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"PostJobWorkDateFootCell" owner:nil options:nil]lastObject];
                if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    cell.layoutMargins = UIEdgeInsetsZero;
                }
            }
            cell.workDayLabel.text = [NSString stringWithFormat:@"共%ld天",(long)_jobDates.count];
            cell.countLabel.text = [NSString stringWithFormat:@"共%ld人",(long)_total];
            return cell;
        }
        else {
            PostJobWorkDateItemCellType cellType = PostJobWorkDateItemCellTypeDelete;
            if (_postJobStatus==PostJobStatusDetail) {
                cellType = PostJobWorkDateItemCellTypeDetail;
            }
            PostJobWorkDateItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[PostJobWorkDateItemCell getReuserIdentifierWithType:cellType]];
            if (!cell) {
                cell = [[PostJobWorkDateItemCell alloc]initWithType:cellType];
                if (cellType==PostJobWorkDateItemCellTypeDelete) {
                    [cell.deleteCellBtn addTarget:self action:@selector(deleteWorkDateAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                else {
                    cell.countField.enabled = NO;
                }
                if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    cell.layoutMargins = UIEdgeInsetsZero;
                }
                cell.countField.delegate = self;
            }
            if (cellType==PostJobWorkDateItemCellTypeDelete) {
                cell.deleteCellBtn.tag = indexPath.row;
            }
            YMJobDateInfo *info = _jobDates[indexPath.row];
            cell.dateLabel.text = [ProjectUtil changeToDateWithSp:info.workDate Format:@"MM月dd日"];
            cell.countField.text = [NSString stringWithFormat:@"%ld",(long)info.total];
            cell.countField.tag = indexPath.row+1000;
            return cell;
        }
    }
}

#pragma mark 选择招聘日期
-(void)chooseWorkDateAction {
    [self.superview.superview endEditing:YES];
    MyCalendarView *calenderView = [[MyCalendarView alloc]init];
    calenderView.defaultCount = _defaultCount;
    PostJobWorkDateCell *__weak weakVC = self;
    MyCalendarView *__weak weakView = calenderView;
    [calenderView calenderConfirmAction:^{
        PostJobWorkDateCell *blockVC = weakVC;
        if (weakView.jobDates.count!=0) {
            //给时间数组赋值并改变数据
            blockVC.total = blockVC->_total + (weakView.jobDates.count-blockVC.jobDates.count)*blockVC.defaultCount;
           blockVC.jobDates = weakView.jobDates;
            if (blockVC->_changeBlock) {
                blockVC->_changeBlock();
            }
        }
    }];
    [calenderView show];
}

#pragma mark 增加工作日期 
-(void)addWorkDateAction {
    [self.superview.superview endEditing:YES];
    MyCalendarView *calenderView = [[MyCalendarView alloc]init];
    calenderView.defaultCount = _defaultCount;
    calenderView.jobDates = [NSMutableArray arrayWithArray:_jobDates];
    PostJobWorkDateCell *__weak weakVC = self;
    MyCalendarView *__weak weakView = calenderView;
    [calenderView calenderConfirmAction:^{
        PostJobWorkDateCell *blockVC = weakVC;
        if (weakView.jobDates.count!=0) {
            //给时间数组赋值并改变数据
            blockVC.total = blockVC->_total + (weakView.jobDates.count-blockVC.jobDates.count)*blockVC.defaultCount;
            blockVC.jobDates = weakView.jobDates;
            if (blockVC->_changeBlock) {
                blockVC->_changeBlock();
            }
        }
    }];
    [calenderView show];
}

#pragma mark 删除工作日期 
-(void)deleteWorkDateAction:(UIButton *)sender {
    YMJobDateInfo *info = [_jobDates objectAtIndex:sender.tag];
    _total = _total - info.total;
    [_jobDates removeObjectAtIndex:sender.tag];
    if (_changeBlock) {
        _changeBlock();
    }
}


#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger currentCount = [[textField.text stringByReplacingCharactersInRange:range withString:string] integerValue];
  
    if (currentCount>1000) {
        return NO;
    }
    else {
        NSInteger lastCount = [textField.text integerValue];
        _total = _total+currentCount-lastCount;
        //修改数组中的元素数据
        YMJobDateInfo *dateInfo = _jobDates[textField.tag-1000];
        dateInfo.total = currentCount;
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_jobDates.count inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        return YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (_changeBlock) {
        _changeBlock();
    }
}

-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
