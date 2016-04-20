//
//  PostWorkTimeChooseView.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostWorkTimeChooseView.h"
static NSInteger ContentViewTag = 1000;


@interface PostWorkTimeChooseView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    GetDicSelectedResultBlock _selectedResult;
}

@property (nonatomic,strong) UIPickerView *startTimePickView;///<开始时间选择

@property (nonatomic,strong) UIPickerView *endTimePickView;///<结束时间选择

@end

@implementation PostWorkTimeChooseView

#pragma mark startTimePickView
-(UIPickerView *)startTimePickView {
    if (!_startTimePickView) {
        _startTimePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50.0, SCREEN_WIDTH/2.0, 140)];
        _startTimePickView.backgroundColor = HEXCOLOR(0xe0e0e0);
        _startTimePickView.delegate = self;
        _startTimePickView.dataSource = self;
        _startTimePickView.showsSelectionIndicator = YES;
        [_startTimePickView selectRow:8 inComponent:0 animated:YES];
        [_startTimePickView selectRow:0 inComponent:1 animated:YES];
    }
    return _startTimePickView;
}

#pragma mark endTimePickView
-(UIPickerView *)endTimePickView {
    if (!_endTimePickView) {
        _endTimePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 50.0, SCREEN_WIDTH/2.0, 140)];
        _endTimePickView.delegate = self;
        _endTimePickView.dataSource = self;
        _endTimePickView.backgroundColor = HEXCOLOR(0xe0e0e0);
        _endTimePickView.showsSelectionIndicator = YES;
        [_endTimePickView selectRow:17 inComponent:0 animated:YES];
        [_endTimePickView selectRow:0 inComponent:1 animated:YES];

    }
    return _endTimePickView;
}

#pragma mark 获取选择结果
-(void)getSelectedResult:(GetDicSelectedResultBlock)result {
    _selectedResult = result;
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
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, SCREEN_WIDTH, 190)];
        contentView.tag = ContentViewTag;
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 30.0)];
        headerView.backgroundColor = RGBCOLOR(238, 238, 238);
        
        UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dismissBtn.frame = CGRectMake((headerView.width-40.0)/2.0, 0,40.0, 30.0);
        [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [dismissBtn setImage:[UIImage imageNamed:@"fbzw_aJ"] forState:UIControlStateNormal];
        [headerView addSubview:dismissBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(headerView.width-50.0, 0, 50.0, headerView.height);
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = FONT(15);
        [confirmBtn setTitleColor:DefaultOrangeColor forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:confirmBtn];
        
        [contentView addSubview:headerView];
        [contentView addSubview:self.startTimePickView];
        [contentView addSubview:self.endTimePickView];
        
        UILabel *startLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30.0, SCREEN_WIDTH/2.0, 20.0)];
        startLabel.text = @"开始";
        startLabel.textAlignment = NSTextAlignmentCenter;
        startLabel.font = FONT(15);
        startLabel.textColor = DefaultGrayTextColor;
        startLabel.backgroundColor = _startTimePickView.backgroundColor;
        [contentView addSubview:startLabel];
        
        UILabel *endLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 30.0, SCREEN_WIDTH/2.0, 20.0)];
        endLabel.text = @"结束";
        endLabel.textColor = DefaultGrayTextColor;
        endLabel.textAlignment = NSTextAlignmentCenter;
        endLabel.font = FONT(15);
        endLabel.backgroundColor = _endTimePickView.backgroundColor;
        [contentView addSubview:endLabel];

        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 30.0, 1, 160)];
        lineView.backgroundColor = HEXCOLOR(0xcccccc);
        [contentView addSubview:lineView];

        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 30.0, self.width, 1)];
        lineView1.backgroundColor = HEXCOLOR(0xcccccc);
        [contentView addSubview:lineView1];
        [self addSubview:contentView];
    }
    return self;
}

#pragma mark 确认按钮
-(void)confirmBtnAction {
    if (_selectedResult) {
        NSInteger startHour = [_startTimePickView selectedRowInComponent:0];
        NSInteger endHour = [_endTimePickView selectedRowInComponent:0];
        NSInteger startMinute = [_startTimePickView selectedRowInComponent:1];
        NSInteger endMinute = [_endTimePickView selectedRowInComponent:1];
        if (startHour*60+startMinute>=endHour*60+endMinute) {
            [self.superview showFailHintWith:@"开始时间需小于结束时间"];
        }
        else {
            NSString *startTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)[_startTimePickView selectedRowInComponent:0],(long)[_startTimePickView selectedRowInComponent:1]];
            NSString *endTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)[_endTimePickView selectedRowInComponent:0],(long)[_endTimePickView selectedRowInComponent:1]];
            _selectedResult (@{@"start":startTimeStr,@"end":endTimeStr});
            [self dismiss];
        }
    }
}

#pragma mark 消失
-(void)dismiss {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        UIView *contentView = [self viewWithTag:ContentViewTag];
        contentView.top = SCREEN_HEIGHT;
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
        UIView *contentView = [self viewWithTag:ContentViewTag];
        contentView.top = self.height-contentView.height;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    } completion:nil];
}

#pragma mark UIPickerViewDataSource,UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component==0) {
        return 24;
    }
    else {
        return 60;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"%02ld",(long)row];
    label.font = FONT(15);
    [label sizeToFit];
    return label;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc {
    [ProjectUtil showLog:NSStringFromClass([self class])];
}

@end
