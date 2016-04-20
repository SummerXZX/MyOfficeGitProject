//
//  CALayer+borderColor.m
//  MyCloud
//
//  Created by test on 15/7/25.
//  Copyright (c) 2015年 xinyue. All rights reserved.
//

#import "CALayer+borderColor.h"

@implementation CALayer (borderColor)

-(void)setBorderUIColor:(UIColor *)borderUIColor
{
    self.borderColor = borderUIColor.CGColor;
}

-(UIColor *)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
