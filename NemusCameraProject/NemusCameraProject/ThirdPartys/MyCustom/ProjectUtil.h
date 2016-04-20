//
//  ProjectUtil.h
//  AnJieWealth
//
//  Created by zhipu on 14-8-28.
//  Copyright (c) 2014年 deayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProjectUtil : NSObject

/*****************--------公共方法------*********************/
/**
 * 打印log日志
 */
+ (void)showLog:(NSString*)log, ...;

/**
 *显示弹出框
 */
+ (void)showAlert:(NSString*)title message:(NSString*)msg;

/**
 * 获取当前APP版本信息
 */
+ (NSString*)getCurrentAppVersion;


/**
 *  获取当前window
 */
+ (UIWindow *)getCurrentWindow;


/**
 *使用颜色创建图片
 */
+ (UIImage*)creatUIImageWithColor:(UIColor*)color;

//-----------------------特有方法-------------------------/

@end
//-----------------------自定义扩展、类别---------------------/

@interface UIView (CustomHint)

/**
 *  显示等待层
 *
 *  @param progress 显示内容
 */
-(void)showProgressHintWith:(NSString *)hint;

/**
 *  显示吐司
 *
 *  @param hint 显示内容
 */
-(void)showToastWith:(NSString *)hint;

/**
 *  消失方法
 */
-(void)dismissProgress;

@end

@interface CALayer (borderColor)

@property (nonatomic, strong) UIColor* borderUIColor; ///<边框颜色

@end

@interface NSString (MyStringCategory)

/**
 *根据字体大小获取字符串size
 */
- (CGSize)getSizeWithFont:(UIFont*)font;

/**
 *根据字体大小和展示宽度获取字符串size
 */
- (CGSize)getSizeWithFont:(UIFont*)font Width:(CGFloat)width;

@end

@interface UIView (CommonExtension)

/**
 * Shortcut for CGRectGetWidth(self.frame)
 *
 * Sets frame.size.width = width
 */
@property (nonatomic,assign) CGFloat width;

/**
 * Shortcut for CGRectGetHeight(self.frame)
 *
 * Sets frame.size.height = height
 */
@property (nonatomic,assign) CGFloat height;

/**
 * Shortcut for self.frame.size
 *
 * Sets frame.size.height = size
 */
@property (nonatomic,assign) CGSize size;

/**
 * Shortcut for CGRectGetMinX(self.frame)
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic,assign) CGFloat left;

/**
 * Shortcut for CGRectGetMinY(self.frame)
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic,assign) CGFloat top;

/**
 * Shortcut for CGRectGetMaxX(self.frame)
 *
 * Sets frame.origin.x = right - CGRectGetWidth(frame);
 */
@property (nonatomic,assign) CGFloat right;

/**
 * Shortcut for CGRectGetMaxY(self.frame)
 *
 * Sets frame.origin.y = bottom - CGRectGetHeight(frame)
 */
@property (nonatomic,assign) CGFloat bottom;

/**
 * Shortcut for self.frame.origin
 *
 * Sets frame.origin.x = leftTop.x,frame.origin.y = leftTop.y
 */
@property (nonatomic,assign) CGPoint origin;

/**
 * Shortcut for CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))
 *
 * Sets frame.origin.x = rightTop.x-CGRectGetWidth(frame),frame.origin.y = rightTop.y
 */
@property (nonatomic,assign) CGPoint rightTop;

/**
 * Shortcut for CGPointMake(CGRectGetMinX(frame),CGRectGetMinY(frame))
 *
 * Sets rame.origin.x = leftBottom.x,frame.origin.y = leftBottom.y + CGRectGetHeight(frame)
 */
@property (nonatomic,assign) CGPoint leftBottom;

/**
 * Shortcut for CGPointMake(self.right, self.top)
 *
 * Sets frame.origin.x = rightBottom.x,rightBottom.y + CGRectGetHeight(frame)
 */
@property (nonatomic,assign) CGPoint rightBottom;



@end
