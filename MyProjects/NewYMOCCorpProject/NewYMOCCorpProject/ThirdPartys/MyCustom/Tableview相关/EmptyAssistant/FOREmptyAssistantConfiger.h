//
//  FOREmptyAssistantConfiger.h
//  51offer
//
//  Created by XcodeYang on 12/10/15.
//  Copyright © 2015 51offer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FOREmptyAssistantConfiger : NSObject

@property (nonatomic, strong)   UIImage *emptyImage;

// default @""
@property (nonatomic, copy)     NSString *emptyTitle;
// default systemFontOfSize:17.0f
@property (nonatomic, strong)   UIFont *emptyTitleFont;
// default darkGrayColor
@property (nonatomic, strong)   UIColor *emptyTitleColor;


// default @""
@property (nonatomic, copy)     NSString *emptySubtitle;
// default systemFontOfSize:15.0f
@property (nonatomic, strong)   UIFont *emptySubtitleFont;
// default lightGrayColor
@property (nonatomic, strong)   UIColor *emptySubtitleColor;

// default systemFontOfSize:15.0f
@property (nonatomic, strong)   UIFont *emptyBtntitleFont;
// default whiteColor
@property (nonatomic, strong)   UIColor *emptyBtntitleColor;
// default ""
@property (nonatomic, strong)   UIImage *emptyBtnImage;

@property (nonatomic, assign) CGFloat emptyBtnCornerRadius;

@property (nonatomic, assign) CGFloat emptyBtnBorderWidth;

@property (nonatomic, strong) UIColor *emptyBtnBorderColor;

@property (nonatomic, strong) UIColor *emptyBtnBackgroundColor;

@property (nonatomic, assign) CGSize emptyBtnSize;

// default CGPointZero
//空白页整体位置默认是在tableView居中显示
@property (nonatomic)   CGPoint emptyCenterOffset;

// default (x:0, y:-30)
//空白页的图片、按钮、文案之间的间距大小
@property (nonatomic)   CGFloat emptySpaceHeight;

// default YES
//添加空白页后ScrollView是否可以继续拖拽
@property (nonatomic)   BOOL allowScroll;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com