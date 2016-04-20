//
//  MyHintView.m
//  YIMIDemo
//
//  Created by test on 16/1/19.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "MyHintView.h"



typedef enum : NSUInteger {
    HintTypeProgress,
    HintTypeSuccess,
    HintTypeFail,
} HintType;

@interface MyHintView ()
{
    NSInteger _currentOffset;
}

@property (nonatomic,strong) UIView *contentView;///<内容view

@property (nonatomic,strong) UIImageView *hintImageView;///<错误或者成功图片imageview

@property (nonatomic,assign) HintType hintType;///<提示类型
@end

@implementation MyHintView

#pragma mark contentLabel
-(UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont boldSystemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentLabel;
}

#pragma mark hintImageView
-(UIImageView *)hintImageView {
    if (!_hintImageView) {
        _hintImageView = [[UIImageView alloc]init];
        _hintImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _hintImageView;
}

#pragma mark circleView
-(MyHintCircleView *)circleView {
    if (!_circleView) {
        _circleView = [[MyHintCircleView alloc]init];
        _circleView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _circleView;
}

#pragma mark contentView
-(UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.layer.cornerRadius = 5.0;
        _contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
        
    }
    return _contentView;
}

#pragma mark 初始化
-(instancetype)initWithHintType:(HintType)hintType {
    self = [super init];
    if (self) {
        _hintType = hintType;
        [self addSubview:self.contentView];
        [_contentView addSubview:self.contentLabel];
        if (hintType==HintTypeProgress) {
             _currentOffset = 0;
            [_contentView addSubview:self.circleView];
        }
        else {
            [_contentView addSubview:self.contentLabel];
            _contentLabel.textAlignment = NSTextAlignmentCenter;
            [_contentView addSubview:self.hintImageView];
            if (hintType==HintTypeSuccess) {
                _hintImageView.image = [UIImage imageNamed:@"load_success"];
            }
            else if (hintType==HintTypeFail) {
                _hintImageView.image = [UIImage imageNamed:@"load_fail"];
            }
        }
    }
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    return self;
}

#pragma mark 添加约束
-(void)steupConstraint {
    //添加约束
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    if (_hintType==HintTypeProgress) {
        
        CGFloat hintViewWidth = [_contentLabel.text getSizeWithFont:_contentLabel.font].width + 55;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:35.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:hintViewWidth]];
        NSDictionary *subViewsDic = @{@"contentLabel":_contentLabel,@"circleView":_circleView};
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[circleView(20)]-5-[contentLabel(>=0)]" options:0 metrics:nil views:subViewsDic]];
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_circleView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_circleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:20.0]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentLabel]-0-|" options:0 metrics:nil views:subViewsDic]];
    }
    else {
        
        CGSize contentStrSize = [_contentLabel.text getSizeWithFont:_contentLabel.font Width:SCREEN_WIDTH-30.0];
        CGFloat contentHeight = 10+50.0+20+contentStrSize.height;
        CGFloat contentWidth = contentStrSize.width+30.0;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:contentHeight]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:contentWidth]];
        
        NSDictionary *subViewsDic = @{@"contentLabel":_contentLabel,@"hintImageView":_hintImageView};
        
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hintImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hintImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:50.0]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[hintImageView(50)]-10-[contentLabel]-10-|" options:0 metrics:nil views:subViewsDic]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[contentLabel]-10-|" options:0 metrics:nil views:subViewsDic]];
    }
    

}

#pragma mark 开始...动画
-(void)startContentAnimation {
    [self performSelector:@selector(changeContent) withObject:nil afterDelay:0.0];
}

#pragma mark 改变...的数量
-(void)changeContent {
    
    if (_currentOffset>=3) {
        _currentOffset = 0;
        _contentLabel.text = [_contentLabel.text substringToIndex:_contentLabel.text.length-3];
    }
    else {
        _contentLabel.text = [_contentLabel.text stringByAppendingString:@"."];
        _currentOffset ++;
    }
    [self performSelector:@selector(changeContent) withObject:nil afterDelay:0.3];
}

#pragma mark 自动消失
-(void)autoDismiss {
    [self performSelector:@selector(dismissFormSuperView) withObject:nil afterDelay:1.0];
}

-(void)dismissFormSuperView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
       
       
        if (_hintType==HintTypeProgress) {
             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeContent) object:nil];
        }
        else {
             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissFormSuperView) object:nil];
        }
        [self removeFromSuperview];
    }];
    
}

#pragma mark 显示进度的提示框,注：无需加“...”默认有“...”的动画
+(instancetype)showProgressHintWithTitle:(NSString *)title {
    
    MyHintView *hintView = [[MyHintView alloc]initWithHintType:HintTypeProgress];
    hintView.contentLabel.text = title;
    hintView.translatesAutoresizingMaskIntoConstraints = NO;
    UIWindow *window = [ProjectUtil getCurrentWindow];
    [window addSubview:hintView];
    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[hintView]-0-|" options:0 metrics:nil views:@{@"hintView":hintView}]];
    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[hintView]-0-|" options:0 metrics:nil views:@{@"hintView":hintView}]];
    

    //添加约束
    [hintView steupConstraint];
    //添加动画
    [hintView.contentView.layer addAnimation:[MyHintView getShowAnimation] forKey:@"Show"];
    //开启圆圈动画和...动画
    [hintView.circleView startAnimating];
    [hintView startContentAnimation];
    return hintView;
}

#pragma mark 显示成功提示框
+(instancetype)showSuccessHintAddedTo:(UIView *)view title:(NSString *)title {
    MyHintView *hintView = [[MyHintView alloc]initWithHintType:HintTypeSuccess];
    hintView.contentLabel.text = title;
    hintView.frame = view.bounds;
    [view addSubview:hintView];
    //添加约束
    [hintView steupConstraint];
    [hintView.contentView.layer addAnimation:[MyHintView getShowAnimation] forKey:@"Show"];
    [hintView autoDismiss];

    return hintView;
}

#pragma mark 显示失败提示框
+(instancetype)showFailHintAddedTo:(UIView *)view title:(NSString *)title {
    MyHintView *hintView = [[MyHintView alloc]initWithHintType:HintTypeFail];
    hintView.frame = view.bounds;
    hintView.contentLabel.text = title;
    [view addSubview:hintView];
    
    //添加约束
    [hintView steupConstraint];
    [hintView.contentView.layer addAnimation:[MyHintView getShowAnimation] forKey:@"Show"];
    [hintView autoDismiss];
    return hintView;
}

#pragma mark 移除进度提示框
+(void)dismissProgressHintForView:(UIView *)view {

    UIWindow *window = [ProjectUtil getCurrentWindow];
    NSEnumerator *subviewsEnum = window.subviews.reverseObjectEnumerator;
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {

            [UIView animateWithDuration:0.3 animations:^{
                subview.alpha = 0.0;
            } completion:^(BOOL finished) {
                MyHintView *hintView = (MyHintView *)subview;
                [hintView dismissFormSuperView];
            }];
            return;
        }
    }
    
}

#pragma mark 获取显示动画
+(CAAnimationGroup *)getShowAnimation {
    //添加动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.fromValue = @0.0f;
    animation1.toValue = @1.0f;
    
    CAAnimationGroup *groupAnimation  = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation,animation1];
    groupAnimation.duration = 0.3f;
    return groupAnimation;
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
