//
//  ProjectUtil.m
//  AnJieWealth
//
//  Created by zhipu on 14-8-28.
//  Copyright (c) 2014年 deayou. All rights reserved.
//
// 是否输出日志

#import "ProjectUtil.h"
#import "MBProgressHUD.h"

@implementation ProjectUtil

#pragma mark 输出日志
+ (void)showLog:(NSString*)log, ...
{
#ifdef DEBUG
    va_list args;
    va_start(args, log);
    NSString* str = [[NSString alloc] initWithFormat:log arguments:args];
    va_end(args);
    NSLog(@" %@ ", str);
#endif
}

#pragma mark 显示弹出框
+ (void)showAlert:(NSString*)title message:(NSString*)msg
{
    NSString* strAlertOK = NSLocalizedString(@"确定", nil);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:strAlertOK
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark 使用颜色创建图片
+ (UIImage*)creatUIImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark 获取当前APP版本信息
+ (NSString*)getCurrentAppVersion
{
    NSDictionary* infoDic = [[NSBundle mainBundle] infoDictionary];
    return infoDic[@"CFBundleShortVersionString"];
}

#pragma mark 获取当前window
+ (UIWindow*)getCurrentWindow
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray* windows = [[UIApplication sharedApplication] windows];
        for (UIWindow* tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

/*------------------------特有方法-------------------------*/

@end

//-----------------------自定义扩展、类别---------------------/
@implementation CALayer (borderColor)

- (void)setBorderUIColor:(UIColor*)borderUIColor
{
    self.borderColor = borderUIColor.CGColor;
}

- (UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end


@implementation NSString (MyStringCategory)

#pragma mark 根据字体大小获取字符串size
- (CGSize)getSizeWithFont:(UIFont*)font
{
    CGSize size;
    UILabel* label = [[UILabel alloc] init];
    label.text = self;
    label.font = font;
    [label sizeToFit];
    size = label.size;
    return size;
}

#pragma mark 根据字体大小和展示宽度获取字符串size
- (CGSize)getSizeWithFont:(UIFont*)font Width:(CGFloat)width
{
    CGSize size;
    CGSize constrainSize = CGSizeMake(width, 2000);
    size = [self boundingRectWithSize:constrainSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{
                                        NSFontAttributeName : font
                                        } context:nil]
    .size;
    return size;
}

@end

@implementation UIView (CustomHint)

#pragma mark 显示等待层
-(void)showProgressHintWith:(NSString *)hint {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.label.text = hint;
}

#pragma mark 显示吐司
-(void)showToastWith:(NSString *)hint {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    hud.label.text = hint;
    [hud hideAnimated:YES afterDelay:1.5f];
}

#pragma mark 消失
-(void)dismissProgress {
    [MBProgressHUD hideHUDForView:self animated:YES];
}


@end




@implementation UIView (CommonExtension)

#pragma mark get width
- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

#pragma mark set width
- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

#pragma mark get height
- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

#pragma mark set height
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark get size
-(CGSize)size {
    return self.frame.size;
}

#pragma mark set size
-(void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark get left
- (CGFloat)left {
    return CGRectGetMinX(self.frame);
}

#pragma mark set left
- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

#pragma mark get top
- (CGFloat)top {
    return CGRectGetMinY(self.frame);
}

#pragma mark set top
- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

#pragma mark get right
- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}

#pragma mark set right
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right-CGRectGetWidth(frame);
    self.frame = frame;
}

#pragma mark get bottom
- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

#pragma mark set bottom
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - CGRectGetHeight(frame);
    self.frame = frame;
}

#pragma mark get origin
- (CGPoint)origin {
    return self.frame.origin;
}

#pragma mark set origin
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

#pragma mark get rightTop
- (CGPoint)rightTop {
    CGRect frame = self.frame;
    return CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame));
}

#pragma mark set rightTop
- (void)setRightTop:(CGPoint)rightTop {
    CGRect frame = self.frame;
    frame.origin.x = rightTop.x-CGRectGetWidth(frame);
    frame.origin.y = rightTop.y;
    self.frame = frame;
}

#pragma mark get leftBottom
- (CGPoint)leftBottom {
    CGRect frame = self.frame;
    return CGPointMake(CGRectGetMinX(frame),CGRectGetMaxY(frame));
}

#pragma mark set leftBottom
- (void)setLeftBottom:(CGPoint)leftBottom {
    CGRect frame = self.frame;
    frame.origin.x = leftBottom.x;
    frame.origin.y = leftBottom.y - CGRectGetHeight(frame);
    self.frame = frame;
}

#pragma mark get rightBottom
- (CGPoint)rightBottom {
    CGRect frame = self.frame;
    return CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame));
}

#pragma mark set rightBottom
- (void)setRightBottom:(CGPoint)rightBottom {
    CGRect frame = self.frame;
    frame.origin.x = rightBottom.x - CGRectGetWidth(frame);
    frame.origin.y = rightBottom.y - CGRectGetHeight(frame);
    self.frame = frame;
}

@end




