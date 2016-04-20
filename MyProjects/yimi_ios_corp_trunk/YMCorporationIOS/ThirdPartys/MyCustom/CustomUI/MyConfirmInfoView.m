//
//  MyConfirmInfoView.m
//  YimiJob
//
//  Created by test on 15/4/20.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "MyConfirmInfoView.h"

static const CGFloat confirmCellHeight = 28.0;
static const CGFloat confirmFootHeight = 40.0;
static const CGFloat confirmHeadHeight = 40.0;

//颜色值
#define TitleColor [UIColor whiteColor]
#define ContentColor RGBCOLOR(150, 150, 150)
#define FootBtnTitleColor RGBCOLOR(180, 180, 180)
#define LineViewColor RGBCOLOR(235, 235, 235)

#define TitleFont Default_Font_15
#define ContentFont Default_Font_13
#define FootBtnTitleFont Default_Font_15


static

@interface MyConfirmInfoView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *confirmTableView;
@property (nonatomic,retain) UILabel *titleLabel;

@end


@implementation MyConfirmInfoView

#pragma mark 初始化方法
-(instancetype)initWithBound:(CGFloat)bound Title:(NSString *)title
{
    _title = title;
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    CGFloat headHeight = (confirmHeadHeight*SCREEN_WIDTH)/320.0;
    CGFloat footHeight = (confirmFootHeight*SCREEN_WIDTH)/320.0;
    CGFloat contentWidth = self.width-bound*2;
    
    if (self)
    {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
        
        //头部标题
        self.confirmTableView.width = contentWidth;
        self.titleLabel.height = headHeight;
        
        UIView *titleLineView  = [[UIView alloc]initWithFrame:CGRectMake(0, _titleLabel.height-1, _titleLabel.width, 1)];
        titleLineView.backgroundColor = LineViewColor;
        [_titleLabel addSubview:titleLineView];
        
        
        self.confirmTableView.left = bound;
        self.confirmTableView.tableHeaderView = self.titleLabel;
        
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, contentWidth, footHeight)];
        footView.backgroundColor = [UIColor whiteColor];
    
        //取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:FootBtnTitleColor forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 0, footView.width/2.0, footView.height);
        cancelBtn.titleLabel.font = FootBtnTitleFont;
        [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:cancelBtn];
        
        //确认按钮
        UIButton *affirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [affirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [affirmBtn setTitleColor:FootBtnTitleColor forState:UIControlStateNormal];
        affirmBtn.titleLabel.font = FootBtnTitleFont;
        affirmBtn.frame = CGRectMake(cancelBtn.right, 0, cancelBtn.width, footView.height);
        [affirmBtn addTarget:self action:@selector(affirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:affirmBtn];
        
        UIView *toplineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, footView.width, 1)];
        toplineView.backgroundColor = LineViewColor;
        [footView addSubview:toplineView];
        
        UIView *middleLineView = [[UIView alloc]initWithFrame:CGRectMake(cancelBtn.right, 0, 1, footView.height)];
        middleLineView.backgroundColor = LineViewColor;
        [footView addSubview:middleLineView];
        self.confirmTableView.tableFooterView = footView;
        
        //隐藏手势
        UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:hideTap];
    }
    return self;
}

#pragma mark 显示confirmView
-(void)showFromView:(UIView *)view WithContentArr:(NSArray *)contentArr
{
    self.userInteractionEnabled = YES;;
    if (self.superview!=nil)
    {
        [self removeFromSuperview];
    }
    [view addSubview:self];
    _contentArr = contentArr;
    _confirmTableView.height = contentArr.count*confirmCellHeight+_titleLabel.height+_confirmTableView.tableFooterView.height;
    _confirmTableView.top = (view.height-_confirmTableView.height)/2.0;
    [_confirmTableView reloadData];
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [_confirmTableView flashScrollIndicators];
    }];
    [self.layer addAnimation:showAnimation() forKey:nil];
}

#pragma mark 隐藏View
-(void)hide
{
    self.userInteractionEnabled = NO;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self.layer removeAnimationForKey:@"transform"];
        [self.layer removeAnimationForKey:@"opacity"];
        [self removeFromSuperview];
    }];
//    [self.layer addAnimation:hideAnimation() forKey:nil];
    [CATransaction commit];
    
}


#pragma mark confirmTableView
-(UITableView *)confirmTableView
{
    if (!_confirmTableView)
    {
        _confirmTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _confirmTableView.backgroundColor = [UIColor whiteColor];
        _confirmTableView.delegate = self;
        _confirmTableView.dataSource = self;
        _confirmTableView.scrollEnabled = NO;
        _confirmTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _confirmTableView.layer.cornerRadius = 5.0;
        [self addSubview:_confirmTableView];
    }
    return _confirmTableView;
}

#pragma mark titleLabel
-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _confirmTableView.width,0)];
        _titleLabel.text = _title;
        _titleLabel.font = TitleFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark title
-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(void)handleWithCancel:(ConfirmCancel)cancel Affirm:(ConfirmAffirm)affirm
{
    _cancel = cancel;
    _affirm = affirm;
}

#pragma mark 取消按钮动作
-(void)cancelBtnAction
{
    [self hide];
    if (_cancel)
    {
        _cancel();
    }
    
}

#pragma mark 确认按钮动作
-(void)affirmBtnAction
{
    [self hide];
    if (_affirm)
    {
        _affirm();
    }
}


#pragma mark - Private Animation Methods

static CAAnimation* showAnimation()
{
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    transform.values = values;
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacity setFromValue:@0.0];
    [opacity setToValue:@1.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setAnimations:@[transform, opacity]];
    return group;
}

//static CAAnimation* hideAnimation()
//{
//    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
//    transform.values = values;
//    
//    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    [opacity setFromValue:@1.0];
//    [opacity setToValue:@0.0];
//    
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.duration = 0.2;
//    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [group setAnimations:@[transform, opacity]];
//    return group;
//}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return confirmCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier =@"confirmCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = ContentFont;
        cell.textLabel.textColor = ContentColor;
    cell.textLabel.text = _contentArr[indexPath.row];
    
    
    return cell;
}

@end
