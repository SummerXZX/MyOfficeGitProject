//
//  UIButton+Custom.m
//  YMCorporationIOS
//
//  Created by test on 15/7/2.
//  Copyright (c) 2015年 yimi. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)

-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    
    [self setTitle:title forState:UIControlStateNormal];
}
@end
