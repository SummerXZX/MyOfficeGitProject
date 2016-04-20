//
//  PostOtherRequireChooseAgeView.m
//  NewYMOCCorpProject
//
//  Created by test on 16/1/23.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "PostOtherRequireChooseAgeView.h"

static NSInteger ContentViewTag = 1000;

@interface PostOtherRequireChooseAgeView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    PostOtherRequreAgeViewConfirmAction _confirmAction;
}

@property (nonatomic,strong) UIPickerView *agePickView;///<年龄选择


@end

@implementation PostOtherRequireChooseAgeView

#pragma mark agePickView
-(UIPickerView *)agePickView {
    if (!_agePickView) {
        _agePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50.0, SCREEN_WIDTH, 140)];
        _agePickView.backgroundColor = HEXCOLOR(0xe0e0e0);
        _agePickView.delegate = self;
        _agePickView.dataSource = self;
        _agePickView.showsSelectionIndicator = YES;
       
           }
    return _agePickView;
}

-(void)setMinAge:(NSInteger)minAge {
    _minAge = minAge;
    if (_minAge==0) {
        [_agePickView selectRow:3 inComponent:0 animated:YES];
    }
    else {
        [_agePickView selectRow:_minAge-18 inComponent:0 animated:YES];
    }
}

-(void)setMaxAge:(NSInteger)maxAge {
    _maxAge = maxAge;
    if (_maxAge==0) {
        [_agePickView selectRow:6 inComponent:1 animated:YES];
    }
    else {
        [_agePickView selectRow:_maxAge-18 inComponent:1 animated:YES];
    }
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
        
        UIButton *unlimitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        unlimitBtn.frame = CGRectMake(0, 0, 50.0, headerView.height);
        [unlimitBtn setTitle:@"不限" forState:UIControlStateNormal];
        unlimitBtn.titleLabel.font = FONT(15);
        [unlimitBtn setTitleColor:DefaultOrangeColor forState:UIControlStateNormal];
        [unlimitBtn addTarget:self action:@selector(unlimitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:unlimitBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(headerView.width-50.0, 0, 50.0, headerView.height);
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = FONT(15);
        [confirmBtn setTitleColor:DefaultOrangeColor forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:confirmBtn];
        [contentView addSubview:headerView];
        [contentView addSubview:self.agePickView];
        UILabel *startLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headerView.bottom, SCREEN_WIDTH/2.0, 20.0)];
        startLabel.text = @"最小年龄";
        startLabel.textAlignment = NSTextAlignmentCenter;
        startLabel.font = FONT(15);
        startLabel.textColor = DefaultGrayTextColor;
        startLabel.backgroundColor = _agePickView.backgroundColor;
        [contentView addSubview:startLabel];
        
        UILabel *endLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, headerView.bottom, SCREEN_WIDTH/2.0, 20.0)];
        endLabel.text = @"最大年龄";
        endLabel.textColor = DefaultGrayTextColor;
        endLabel.textAlignment = NSTextAlignmentCenter;
        endLabel.font = FONT(15);
        endLabel.backgroundColor = _agePickView.backgroundColor;
        [contentView addSubview:endLabel];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 30, 1, 160)];
        lineView.backgroundColor = HEXCOLOR(0xcccccc);
        [contentView addSubview:lineView];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0,30, self.width, 1)];
        lineView1.backgroundColor = HEXCOLOR(0xcccccc);
        [contentView addSubview:lineView1];
        
        [self addSubview:contentView];
        
    }
    return self;
    
}

#pragma mark 确认动作
-(void)confirmAction:(PostOtherRequreAgeViewConfirmAction)confirmAction {
    _confirmAction = confirmAction;
}

#pragma mark 不限按钮动作
-(void)unlimitBtnAction {
    _minAge = 0;
    _maxAge = 0;
    if (_confirmAction) {
        _confirmAction ();
    }
    [self dismiss];
}

#pragma mark 确认按钮动作
-(void)confirmBtnAction {
    _minAge = [_agePickView selectedRowInComponent:0]+18;
    _maxAge = [_agePickView selectedRowInComponent:1]+18;
    if (_minAge>=_maxAge) {
        [self.superview showFailHintWith:@"最小年龄需小于最大年龄"];
    }
    else {
        if (_confirmAction) {
            _confirmAction ();
        }
        [self dismiss];
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
    return 23;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"%02ld",(long)row+18];
    label.font = FONT(15);
    [label sizeToFit];
    return label;
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
