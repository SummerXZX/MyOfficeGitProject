//
//  ProjectUtil.m
//  AnJieWealth
//
//  Created by zhipu on 14-8-28.
//  Copyright (c) 2014年 deayou. All rights reserved.
//
// 是否输出日志

#import "ProjectUtil.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "sys/utsname.h"
#import "MBProgressHUD.h"

@implementation ProjectUtil

static NSString *LOGINDATAKEY = @"LOGINDATAKEY";
static NSString *USERINFOKEY = @"USERINFOKEY";
static NSString *LOGINNAMEKEY = @"LOGINNAMEKEY";


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

#pragma mark 根据日期获取时间戳
+ (NSInteger)getTimeSpWithDate:(NSDate*)date
{
    return [date timeIntervalSince1970];
}

#pragma mark 根据时间错获取日期
+ (NSDate*)getDateWithTimeSp:(NSInteger)sp
{
    return [NSDate dateWithTimeIntervalSince1970:sp];
}

#pragma mark 根据时间戳和格式将字符串转换成日期
+ (NSString*)changeToDateWithSp:(NSInteger)sp Format:(NSString*)format
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:sp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

#pragma mark 将字符串转换成默认日期格式：yyyy-MM-dd
+ (NSString*)changeToDefaultDateStrWithSp:(NSInteger)sp
{
    return [ProjectUtil changeToDateWithSp:sp Format:@"yyyy-MM-dd"];
}

#pragma mark 将字符串转换成默认日期格式：自定义分隔符
+ (NSString*)changeToDefaultDateStrWithSp:(NSInteger)sp
                              SegmentSign:(NSString*)segmentSign
{
    return [ProjectUtil
        changeToDateWithSp:sp
                    Format:[NSString stringWithFormat:@"yyyy%@MM%@dd",
                                     segmentSign, segmentSign]];
}

#pragma mark 将字符串转换成标准的日期格式
+ (NSString*)changeStandardDateStrWithSp:(NSInteger)sp
{
    return [ProjectUtil changeToDateWithSp:sp Format:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark 将字符串转换成中国日期
+ (NSString*)changeToChineseDateStrWithSp:(NSInteger)sp
{
    return [ProjectUtil changeToDateWithSp:sp Format:@"yyyy年MM月dd日"];
}

#pragma mark 根据字符串数组获取Label应加的高度
+ (CGFloat)getAddHeightWithStrArr:(NSArray*)strArr
                             Font:(UIFont*)font
                      LabelHeight:(CGFloat)height
                       LabelWidth:(CGFloat)width
{
    CGFloat addHeight = 0.0;
    for (int i = 0; i < strArr.count; i++) {
        CGFloat strHeight = 0.0;
        if ([strArr[i] isKindOfClass:[NSAttributedString class]]) {
            NSAttributedString* str = strArr[i];
            strHeight =
                [str boundingRectWithSize:CGSizeMake(width, 2000)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                                  context:nil]
                    .size.height;
        }
        else if ([strArr[i] isKindOfClass:[NSString class]]) {
            NSString* str = strArr[i];
            strHeight = [str getSizeWithFont:font Width:width].height;
        }
        if (strHeight > height) {
            addHeight += strHeight - height;
        }
    }

    return addHeight;
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


#pragma mark 获取设备唯一标识
+ (NSString*)getDeviceId
{
    NSString* deviceId =
        [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return deviceId;
}

#pragma mark 获取当前设备类型
+ (NSString*)getDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* deviceString = [NSString stringWithCString:systemInfo.machine
                                                encoding:NSUTF8StringEncoding];

    return deviceString;
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

#pragma mark 保存登陆数据
+(void)saveLoginData:(WebLoginData *)loginData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults rm_setCustomObject:loginData forKey:LOGINDATAKEY];
    [userDefaults synchronize];
}

#pragma mark 获取登陆数据
+(WebLoginData *)getLoginData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults rm_customObjectForKey:LOGINDATAKEY];
}

#pragma mark 清空登陆信息
+(void)removeLoginData {
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:LOGINDATAKEY];
    [userDefaults synchronize];
}

#pragma mark 保存登陆名
+(void)saveLoginName:(NSString *)loginName {
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:loginName forKey:LOGINNAMEKEY];
    [userDefaults synchronize];
}

#pragma mark 获取登陆名
+(NSString *)getLoginName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:LOGINNAMEKEY];
}

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

#pragma mark 给当前字符串加下划线
- (NSMutableAttributedString*)addUnderline
{
    NSMutableAttributedString* attributedString =
    [[NSMutableAttributedString alloc] initWithString:self];
    NSRange attributedRange = { 0, [attributedString length] };
    [attributedString
     addAttribute:NSUnderlineStyleAttributeName
     value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
     range:attributedRange];
    return attributedString;
}

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

#pragma mark 转换成MD5字符串
- (NSString*)changeToStringToMd5String
{
    const char* cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned)strlen(cStr), result);
    return [NSString
            stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5],
            result[6], result[7], result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

@end


CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x - CGRectGetMidX(rect);
    newrect.origin.y = center.y - CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (ViewGeometry)

// Retrieve and set the origin
- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

// Retrieve and set the size
- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

// Query other frame locations
- (CGPoint)bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

// Retrieve and set height, width, top, bottom, left, right
- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta;
    self.frame = newframe;
}

// Move via offset
- (void)moveBy:(CGPoint)delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

// Scaling
- (void)scaleBy:(CGFloat)scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void)fitInSize:(CGSize)aSize
{
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height)) {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width)) {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}
@end

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat CSToastMaxWidth = 0.8; // 80% of parent view width
static const CGFloat CSToastMaxHeight = 0.8; // 80% of parent view height
static const CGFloat CSToastHorizontalPadding = 10.0;
static const CGFloat CSToastVerticalPadding = 10.0;
static const CGFloat CSToastCornerRadius = 5.0;
static const CGFloat CSToastOpacity = 0.8;
static const CGFloat CSToastFontSize = 13.0;
static const CGFloat CSToastMaxTitleLines = 0;
static const CGFloat CSToastMaxMessageLines = 0;
static const CGFloat CSToastFadeDuration = 0.2;

// shadow appearance
static const CGFloat CSToastShadowOpacity = 0.8;
static const CGFloat CSToastShadowRadius = 2.0;
static const CGSize CSToastShadowOffset = { 2.0, 2.0 };
static const BOOL CSToastDisplayShadow = YES;

// display duration and position
static const CGFloat CSToastDefaultDuration = 0.5;
static const NSString* CSToastDefaultPosition = @"bottom";

// image view size
static const CGFloat CSToastImageViewWidth = 50.0;
static const CGFloat CSToastImageViewHeight = 50.0;

// activity
static const NSString* CSToastActivityDefaultPosition = @"center";

@interface UIView (ToastPrivate)

- (CGPoint)centerPointForPosition:(id)position withToast:(UIView*)toast;
- (UIView*)viewForMessage:(NSString*)message
                    title:(NSString*)title
                    image:(UIImage*)image;

@end

@implementation UIView (Toast)

- (void)makeProgress:(NSString*)progress
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.text = progress;
}

- (void)hiddenProgress
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

#pragma mark - Toast Methods

- (void)makeToast:(NSString*)message
{
    [self makeToast:message
           duration:CSToastDefaultDuration
           position:CSToastActivityDefaultPosition];
}

- (void)makeToast:(NSString*)message
         duration:(CGFloat)interval
         position:(id)position
{
    UIView* toast = [self viewForMessage:message title:nil image:nil];
    [self showToast:toast duration:interval position:position];
}

- (void)makeToast:(NSString*)message
         duration:(CGFloat)interval
         position:(id)position
            title:(NSString*)title
{
    UIView* toast = [self viewForMessage:message title:title image:nil];
    [self showToast:toast duration:interval position:position];
}

- (void)makeToast:(NSString*)message
         duration:(CGFloat)interval
         position:(id)position
            image:(UIImage*)image
{
    UIView* toast = [self viewForMessage:message title:nil image:image];
    [self showToast:toast duration:interval position:position];
}

- (void)makeToast:(NSString*)message
         duration:(CGFloat)interval
         position:(id)position
            title:(NSString*)title
            image:(UIImage*)image
{
    UIView* toast = [self viewForMessage:message title:title image:image];
    [self showToast:toast duration:interval position:position];
}

- (void)showToast:(UIView*)toast
{
    [self showToast:toast
           duration:CSToastDefaultDuration
           position:CSToastDefaultPosition];
}

- (void)showToast:(UIView*)toast duration:(CGFloat)interval position:(id)point
{
    CATransition* animation = [CATransition animation];
    animation.duration = 0.5;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    toast.center = [self centerPointForPosition:point withToast:toast];
    toast.alpha = 0.0;
    [self addSubview:toast];
    [toast.layer addAnimation:animation forKey:@"tips"];
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:CSToastFadeDuration
                                               delay:interval
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toast.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished) {
                                              [toast removeFromSuperview];
                                          }];
                     }];
}

#pragma mark - Private Methods

- (CGPoint)centerPointForPosition:(id)point withToast:(UIView*)toast
{
    if ([point isKindOfClass:[NSString class]]) {
        // convert string literals @"top", @"bottom", @"center", or any point
        // wrapped in an NSValue object into a CGPoint
        if ([point caseInsensitiveCompare:@"top"] == NSOrderedSame) {
            return CGPointMake(
                               self.bounds.size.width / 2,
                               (toast.frame.size.height / 2) + CSToastVerticalPadding);
        }
        else if ([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame) {
            return CGPointMake(
                               self.bounds.size.width / 2,
                               (self.bounds.size.height - (toast.frame.size.height / 2)) - CSToastVerticalPadding);
        }
        else if ([point caseInsensitiveCompare:@"center"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2,
                               self.bounds.size.height / 2);
        }
    }
    else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    return [self centerPointForPosition:CSToastDefaultPosition withToast:toast];
}

- (UIView*)viewForMessage:(NSString*)message
                    title:(NSString*)title
                    image:(UIImage*)image
{
    // sanity
    if ((message == nil) && (title == nil) && (image == nil))
        return nil;
    
    // dynamically build a toast view with any combination of message, title, &
    // image.
    UILabel* messageLabel = nil;
    UILabel* titleLabel = nil;
    UIImageView* imageView = nil;
    
    // create the parent view
    UIView* wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = CSToastShadowOpacity;
        wrapperView.layer.shadowRadius = CSToastShadowRadius;
        wrapperView.layer.shadowOffset = CSToastShadowOffset;
    }
    
    wrapperView.backgroundColor =
    [[UIColor blackColor] colorWithAlphaComponent:CSToastOpacity];
    
    if (image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(CSToastHorizontalPadding, CSToastVerticalPadding,
                                     CSToastImageViewWidth, CSToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if (imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = CSToastHorizontalPadding;
    }
    else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = CSToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:CSToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth,
                                         self.bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeTitle =
        [title getSizeWithFont:titleLabel.font
                         Width:maxSizeTitle.width];
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = CSToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:CSToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth,
                                           self.bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeMessage =
        [message getSizeWithFont:messageLabel.font
                           Width:maxSizeMessage.width];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width,
                                        expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if (titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = CSToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
    }
    else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if (messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
        messageTop = titleTop + titleHeight + CSToastVerticalPadding;
    }
    else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger.
    // same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (CSToastHorizontalPadding * 2)),
                               (longerLeft + longerWidth + CSToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + CSToastVerticalPadding),
                                (imageHeight + (CSToastVerticalPadding * 2)));
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if (titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if (messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if (imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    
    return wrapperView;
}

@end

@implementation UITextField (RecycleBtn)

#pragma mark 添加"完成"按钮，回收键盘
-(void)addRecycleBtn {
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    [doneButton setTitleTextAttributes:@{NSForegroundColorAttributeName:DefaultBlueTextColor} forState:UIControlStateNormal];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [self setInputAccessoryView:topView];
}

#pragma mark dismissKeyBoard
-(void)dismissKeyBoard {
    [self resignFirstResponder];
}

@end


