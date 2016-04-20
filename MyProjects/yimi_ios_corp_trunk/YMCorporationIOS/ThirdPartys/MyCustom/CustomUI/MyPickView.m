//
//  MyPickView.m
//  YMCorporationIOS
//
//  Created by test on 15/6/26.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "MyPickView.h"
#import "CityDataBaseManager.h"


static CGFloat PickRowHeight = 40.0;
static CGFloat PickTitleHeight = 40.0;
static CGFloat PickFootHeight = 50.0;


@interface MyPickView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_itemsArr;
    MyPickHandleBlock _handleConfirm;
    MyPickDateHandleBlock _dateConfirm;
    MyPickWorkTimeHandleBlock _workTimeConfirm;
}
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *pickFootView;
@property (nonatomic,strong) UIView *workTimeView;
@end

@implementation MyPickView

#pragma mark 创建普通的pickview
-(instancetype)initWithTitle:(NSString *)title Items:(NSArray *)items
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self)
    {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
        _itemsArr = items;
        [self addSubview:self.pickView];
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom, self.width, 1)];
        lineView.backgroundColor = DefaultBackGroundColor;
        [self addSubview:lineView];
        [self addSubview:self.pickFootView];
        
    }
    return self;
}

#pragma mark 创建时间pickview
-(instancetype)initDatePickerWithTitle:(NSString *)title
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self)
    {
         self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
        [self addSubview:self.datePicker];
        self.titleLabel.text = title;
        self.titleLabel.top = _datePicker.top-PickTitleHeight;
        [self addSubview:self.titleLabel];
        self.pickFootView.top = _datePicker.bottom;
        [self addSubview:self.pickFootView];
    }
    return self;
}

#pragma mark 创建兼职时间的pickview
-(instancetype)initWorkTimePickerWithTitle:(NSString *)title
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self)
    {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
        [self addSubview:self.workTimeView];
        self.titleLabel.text = title;
        self.titleLabel.top = _workTimeView.top-PickTitleHeight;
        [self addSubview:self.titleLabel];
        self.pickFootView.top = _workTimeView.bottom;
        [self addSubview:self.pickFootView];
    }
    return self;
}

#pragma mark 兼职时间选中项目
-(void)workTimeSeletedTimeStr:(NSString *)timeStr
{
    NSArray *timeArr = [timeStr componentsSeparatedByString:@"|"];
    int count = 100;
    for (NSString *str in timeArr)
    {
        NSArray *detailArr = [str componentsSeparatedByString:@","];
        for (NSString *detailStr in detailArr)
        {
            UIButton *btn = (UIButton *)[_workTimeView viewWithTag:count];
            if ([detailStr intValue]==0)
            {
                btn.selected = NO;
            }
            else if ([detailStr intValue]==1)
            {
                btn.selected = YES;
            }
            count++;
        }
    }
}

#pragma mark 根据时间字符串获取信息字符串
+(NSString *)getTimeInfoStrWithTimeStr:(NSString *)timeStr
{
    NSArray *timeArr = [timeStr componentsSeparatedByString:@"|"];
    NSString *timeInfoStr = @"";
    NSArray *weekArr = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    int count = 0;
    for (NSString *str in timeArr)
    {
        NSArray *detailArr = [str componentsSeparatedByString:@","];
        BOOL isWork = NO;
        for (NSString *detailStr in detailArr)
        {
            if ([detailStr intValue]==1)
            {
                isWork = YES;
            }
        }
        if (isWork)
        {
            timeInfoStr = [timeInfoStr stringByAppendingFormat:@"%@,",weekArr[count]];
        }
        count++;
    }
    if (timeInfoStr.length>0) {
        return [timeInfoStr substringToIndex:timeInfoStr.length-1];
    }
    else {
        return @"";
    }
}

#pragma mark 创建nomalBtn
-(UIButton *)creatNomalBtnWithFrame:(CGRect)frame Title:(NSString *)title BackColor:(UIColor *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = color;
    btn.layer.cornerRadius = 2.0;
    return btn;
}

#pragma mark 显示
-(void)show
{
    UIWindow *window = [self getCurrentWindow];
    [window addSubview:self];
    CATransition *transtiton = [CATransition animation];
    transtiton.duration = 0.3f;
    transtiton.type = @"moveIn";
    transtiton.subtype = kCATransitionFromTop;
    [self.layer addAnimation:transtiton forKey:nil];
}

#pragma mark 处理确认动作
-(void)handleConfirm:(MyPickHandleBlock)confirm
{
    _handleConfirm = confirm;
}

#pragma mark 日期处理确认动作
-(void)handleDateConfirm:(MyPickDateHandleBlock)dateConfirm
{
    _dateConfirm = dateConfirm;
}

#pragma mark 兼职时间处理确认动作
-(void)handleWorkTimeConfirm:(MyPickWorkTimeHandleBlock)workTimeConfirm
{
    _workTimeConfirm = workTimeConfirm;
}

#pragma mark 取消动作
-(void)cancelBtnAction
{
    [self removeFromSuperview];
}
#pragma mark 确认动作
-(void)confirmBtnAction
{
    if (_handleConfirm)
    {
        NSMutableArray *selectedArr = [NSMutableArray array];
        for (int i=0; i<_pickView.numberOfComponents; i++)
        {
            NSInteger selectedRow = [_pickView selectedRowInComponent:i];
            [selectedArr addObject:_itemsArr[i][selectedRow][@"id"]];
        }
        _handleConfirm([NSArray arrayWithArray:selectedArr]);
    }
    else if (_dateConfirm)
    {
        _dateConfirm(_datePicker.date);
    }
    else if (_workTimeConfirm)
    {
        NSString *timeStr = @"";
        NSInteger btnTag = 100;
        for (int i=0; i<7; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *btn = (UIButton *)[_workTimeView viewWithTag:btnTag];
                if (btn.selected)
                {
                    timeStr = [timeStr stringByAppendingString:@"1"];
                }
                else
                {
                    timeStr = [timeStr stringByAppendingString:@"0"];
                }
                if (j<2)
                {
                    timeStr = [timeStr stringByAppendingString:@","];
                }
                btnTag++;
            }
            
            if (i<6)
            {
                 timeStr = [timeStr stringByAppendingString:@"|"];
            }
            
        }
        _workTimeConfirm(timeStr);
    }
    [self removeFromSuperview];

}


#pragma mark 获取当前window
-(UIWindow *)getCurrentWindow
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}


#pragma mark pickView
-(UIPickerView *)pickView
{
    if (!_pickView)
    {
        NSArray *itemArr = _itemsArr[0];
       CGFloat pickViewHeight = MIN(itemArr.count*PickRowHeight, 160);
        _pickView= [[UIPickerView alloc]initWithFrame:CGRectMake(0, (self.height-pickViewHeight)/2.0, SCREEN_WIDTH, pickViewHeight)];
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.showsSelectionIndicator = YES;
        
    }
    return _pickView;
}

#pragma mark datePicker
-(UIDatePicker *)datePicker
{
    if (!_datePicker)
    {    
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.top = (self.height-_datePicker.height)/2.0;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        _datePicker.minimumDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        _datePicker.maximumDate = [formatter dateFromString:@"2099-01-01 00:00:00"];
        
        _datePicker.backgroundColor = [UIColor whiteColor];
       
    }
    return _datePicker;
}

#pragma mark titleLabel
-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,_pickView.top-PickTitleHeight, SCREEN_WIDTH, PickTitleHeight)];
        _titleLabel.font = Default_Font_15;
        _titleLabel.textColor = DefaultGrayTextColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _titleLabel;
}

#pragma mark pickFootView
-(UIView *)pickFootView
{
    if (!_pickFootView)
    {
        _pickFootView = [[UIView alloc]initWithFrame:CGRectMake(0, self.pickView.bottom, self.width, PickFootHeight)];
        _pickFootView.backgroundColor = [UIColor whiteColor];
        CGFloat btnWidth = (self.width-100-20)/2.0;
        CGFloat btnHeight = 35.0;
        UIButton *cancelBtn = [self creatNomalBtnWithFrame:CGRectMake(50,(_pickFootView.height-btnHeight)/2.0, btnWidth, btnHeight) Title:@"取消" BackColor:RGBCOLOR(121, 122, 123)];
        [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_pickFootView addSubview:cancelBtn];

        UIButton *confirmBtn = [self creatNomalBtnWithFrame:CGRectMake(cancelBtn.right+20, cancelBtn.top, btnWidth, btnHeight) Title:@"确认" BackColor:RGBCOLOR(250, 142, 36)];
        [confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_pickFootView addSubview:confirmBtn];
    }
    return _pickFootView;
}

#pragma mark workTimeView
-(UIView *)workTimeView
{
    if (!_workTimeView)
    {
        CGFloat btnHeight = 30.0;
        CGFloat btnLeft = 10+1.75;
        CGFloat btnWidth = (SCREEN_WIDTH-btnLeft*2)/8.0;
        CGFloat footHeight = 40.0;
        CGFloat workViewHeight = btnHeight*4+footHeight;
        _workTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, (self.height-workViewHeight)/2.0, self.width, workViewHeight)];
        _workTimeView.backgroundColor = [UIColor whiteColor];
        NSArray *arr = @[@"",@"上午",@"下午",@"晚上"];
        NSArray *weekArr = @[@"",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
        int btnCount = 100;
        for (int i=0; i<weekArr.count; i++)
        {
            for (int j=0; j<arr.count; j++)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(btnLeft+(btnWidth-0.5)*i, (btnHeight-0.5)*j, btnWidth, btnHeight);
                btn.layer.borderColor = [UIColor blackColor].CGColor;
                btn.layer.borderWidth = 0.5;
                btn.titleLabel.font = Default_Font_14;
                if (i==0)
                {
                    [btn setTitle:arr[j] forState:UIControlStateNormal];
                    btn.backgroundColor = RGBCOLOR(209, 209, 209);
                    [btn setTitleColor:RGBCOLOR(59, 59, 59) forState:UIControlStateNormal];
                }
                else if (j==0)
                {
                    [btn setTitle:weekArr[i] forState:UIControlStateNormal];
                    btn.backgroundColor = RGBCOLOR(209, 209, 209);
                    [btn setTitleColor:RGBCOLOR(59, 59, 59) forState:UIControlStateNormal];
                }
                else
                {
                    [btn setTitle:@"√" forState:UIControlStateSelected];
                    [btn setTitleColor:RGBCOLOR(71, 164, 85) forState:UIControlStateSelected];
                    [btn addTarget:self action:@selector(workTimeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag = btnCount;
                    btnCount++;
                }
                [_workTimeView addSubview:btn];
            }
        }
    
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(btnLeft,workViewHeight-footHeight-2,SCREEN_WIDTH-btnLeft*2-3.5, footHeight)];
        footView.backgroundColor = [UIColor whiteColor];
        footView.layer.borderWidth = 0.5;
        footView.layer.borderColor = [UIColor blackColor].CGColor;
        [_workTimeView addSubview:footView];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((footView.width-100)/2.0+footView.left, footView.top+5, 100, 30);
        [btn setImage:[UIImage imageNamed:@"wt_unselected"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"wt_selected"] forState:UIControlStateSelected];
        btn.titleLabel.font = Default_Font_14;
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        [btn setTitle:@"全选" forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 1111;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(workTimeSelectedAllBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_workTimeView addSubview:btn];
    }
    return _workTimeView;
}

#pragma mark 时间选择按钮方法
-(void)workTimeBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected==NO)
    {
        UIButton *btn = (UIButton *)[_workTimeView viewWithTag:1111];
        btn.selected = NO;
    }
    else
    {
        BOOL isSelected = YES;
        for (int i=0; i<21; i++)
        {
            UIButton *btn = (UIButton *)[_workTimeView viewWithTag:100+i];
            if (btn.selected == NO)
            {
                isSelected = NO;
            }
        }
        UIButton *btn = (UIButton *)[_workTimeView viewWithTag:1111];
        btn.selected = isSelected;
    }
}

#pragma mark 时间选择全选按钮
-(void)workTimeSelectedAllBtnAction:(UIButton *)sender
{
        sender.selected = !sender.selected;
        for (int i=0; i<21; i++)
        {
            UIButton *btn = (UIButton *)[_workTimeView viewWithTag:100+i];
            btn.selected = sender.selected;
        }
}



#pragma mark UIPickerViewDataSource,UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _itemsArr.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return PickRowHeight;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *itemArr = _itemsArr[component];
    return itemArr.count;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = _itemsArr[component][row][@"name"];
    label.font = Default_Font_15;
    [label sizeToFit];
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isAreaPicker)
    {
        if (component==0)
        {
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_itemsArr];
            int cityId = [_itemsArr[component][row][@"id"]intValue];
            NSArray *countyArr = [CityDataBaseManager getCountyWithParentId:cityId];
            [tempArr replaceObjectAtIndex:component+1 withObject:countyArr];
            _itemsArr = [NSArray arrayWithArray:tempArr];
            [pickerView reloadComponent:component+1];
            [pickerView selectRow:0 inComponent:component+1 animated:YES];
    }
   }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
