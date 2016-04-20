//
//  ModelWebViewController.h
//  FunnyPie
//
//  Created by summer on 14-10-14.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelViewController.h"

@interface ModelWebViewController : ModelViewController<UIWebViewDelegate>

/**
 *打开URL初始化方法
 */
-(id)initWithURL:(NSURL *)url;

/**
 *显示的webView
 */
@property (nonatomic,retain) UIWebView *webView;
@end
