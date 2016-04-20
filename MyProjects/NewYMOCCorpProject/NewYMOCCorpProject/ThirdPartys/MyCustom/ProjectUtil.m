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
#import <MJExtension.h>
#import "MyHintView.h"

@implementation ProjectUtil

#pragma mark 输出日志
+(void)showLog:(NSString *)log,...
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
+(void)showAlert:(NSString *)title message:(NSString *)msg {
    NSString *strAlertOK = NSLocalizedString(@"确定",nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:strAlertOK
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark 根据日期获取时间戳
+(NSString *)getTimeSpWithDate:(NSDate *)date
{
    return [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
}

#pragma mark 根据时间错获取日期
+(NSDate *)getDateWithTimeSp:(NSInteger)sp
{
    return [NSDate dateWithTimeIntervalSince1970:sp];
}

#pragma mark 将字符串转换成默认日期格式：yyyy-MM-dd
+(NSString *)changeToDefaultDateStrWithSp:(NSInteger)sp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
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


#pragma mark 将字符串转换成默认日期格式：自定义分隔符
+(NSString *)changeToSpDefaultDateStrWithSp:(NSInteger)sp SegmentSign:(NSString *)segmentSign
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",segmentSign,segmentSign]];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

#pragma mark 将字符串转换成标准的日期格式
+(NSString *)changeStandardDateStrWithSp:(NSInteger)sp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

#pragma mark 将字符串转换成中国日期
+(NSString *)changeToChineseDateStrWithSp:(NSInteger)sp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

#pragma mark 根据字符串数组获取Label应加的高度
+(CGFloat)getAddHeightWithStrArr:(NSArray *)strArr Font:(UIFont *)font LabelHeight:(CGFloat)height LabelWidth:(CGFloat)width
{
    CGFloat addHeight = 0.0;
    for (int i = 0; i < strArr.count; i++) {
        CGFloat strHeight = 0.0;
        if ([strArr[i] isKindOfClass:[NSAttributedString class]]) {
            NSAttributedString* str = strArr[i];
            strHeight =
            [str boundingRectWithSize:CGSizeMake(width, 4000)
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

#pragma mark 获取当前APP版本信息
+(NSString *)getCurrentAppVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
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

#pragma mark 使用颜色创建图片
+ (UIImage*)creatUIImageWithColor:(UIColor*)color Size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark 获取默认的TableView
+(UITableView *)getDefaultTableViewWithType:(TableViewType)type {
    UITableView *tableView =
    [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    tableView.backgroundColor = DefaultBackGroundColor;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = DefaultBackGroundColor;
    tableView.showsVerticalScrollIndicator = NO;
    if (type==TableViewTypeFullSeparator) {
        //注：真正实现需在代理中实现setLayoutMargins方法
        // cell线到头
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        } // ios8SDK 兼容6 和 7 cell下划线
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return tableView;
}

#pragma mark 插入默认橙色渐变背景
+(void)insertOrangeGradientBackColorWithLayer:(CALayer *)layer Frame:(CGRect)frame {
    //添加渐变背景
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    gradient.colors = @[(id)RGBCOLOR(255, 122, 1).CGColor,(id)RGBCOLOR(255, 133, 0).CGColor,(id)RGBCOLOR(255, 151, 0).CGColor];
    [layer insertSublayer:gradient atIndex:0];
}

#pragma mark 获取签到类型字符串
+(NSString *)getSignTypeStringWithSignType:(NSInteger)signType {
    switch (signType) {
        case 0:
            return @"未签到";
            break;
        case 1:
            return @"手动签到";
            break;
        case 2:
            return @"已签到";
            break;
        default:
            return @"";
            break;
    }
}


/*------------------特有方法---------------------*/

static NSString *LoginInfoPhoneKey = @"loginPhone";//登录手机号保存key
static NSString* LoginInfoKey = @"loginInfo";//登录信息保存key
static NSString* DeviceTokenKey = @"deviceToken";//友盟推送token保存key

#pragma mark 保存友盟推送deviceToken
+ (void)saveUMengDeviceToken:(NSString*)deviceToken
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceToken forKey:DeviceTokenKey];
}

#pragma mark 获取友盟deviceToken
+ (NSString*)getUMengDeviceToken
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:DeviceTokenKey] == nil ? @"" : [userDefaults objectForKey:DeviceTokenKey];
}

#pragma mark 保存登录信息
+(void)saveLoginInfo:(YMLoginInfo *)data {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data.mj_keyValues forKey:LoginInfoKey];
    [userDefaults synchronize];
}

#pragma mark 获取登录信息
+(YMLoginInfo *)getLoginInfo {
    return [YMLoginInfo mj_objectWithKeyValues:[[NSUserDefaults standardUserDefaults]objectForKey:LoginInfoKey]];
}

#pragma mark 获取当前用户token
+(NSString *)getToken {
    YMLoginInfo *loginInfo = [ProjectUtil getLoginInfo];
    return loginInfo.token;
}

#pragma mark 删除登录信息
+(void)removeLoginInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:LoginInfoKey];
    [userDefaults synchronize];
}

#pragma mark 获取当前设备上一次登录的手机号
+ (NSString *)getLoginPhone {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:LoginInfoPhoneKey];
}

#pragma mark 储存登录的手机号
+(void)saveLoginPhone:(NSString *)phone {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:phone forKey:LoginInfoPhoneKey];
    [userDefaults synchronize];
}


#pragma mark 获取完整的图片下载地址
+(NSString *)getWholeImageUrlWithResponseUrl:(NSString *)url {
    return [NSString stringWithFormat:@"%@%@",REQUEST_IMAGE_URL,url];
}


@end

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

#pragma mark 判断是否是特殊字符串格式
- (BOOL)isType:(SpecialStringType)stringType
{
    NSString* regex;
    if (stringType == SpecialStringTypePhone) {
        regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    }
    else if (stringType == SpecialStringTypePhoneNumber) {
        regex = @"^[0-9]\\d*$";
    }
    else if (stringType == SpecialStringTypePassword) {
        regex = @"^[A-Za-z0-9]+$";
    }
    else if (stringType == SpecialStringTypeEmail) {
        regex =
        @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";
    }
    else if (stringType == SpecialStringTypePayCount) {
        regex = @"[-\\+]?\\d{1,4}+\\.$|[-\\+]?\\d{1,4}|[-\\+]?\\d{1,4}+(.[0-9]{1,2})?$";
    }
    
    NSPredicate* predicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}


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


@implementation UIView (CustomHint)

#pragma mark 显示等待层
-(void)showProgressHintWith:(NSString *)hint {
    
    [MyHintView showProgressHintWithTitle:hint];
}

#pragma mark 显示成功提示层
-(void)showSuccessHintWith:(NSString *)hint {
    [MyHintView showSuccessHintAddedTo:self title:hint];
    
}

-(void)showFailHintWith:(NSString *)hint {
    [MyHintView showFailHintAddedTo:self title:hint];
}

#pragma mark 消失
-(void)dismissProgress {
    [MyHintView dismissProgressHintForView:self];
}
@end



