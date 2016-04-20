//
//  CourseLRCView.h
//  PhoneticLearningProject
//
//  Created by test on 15/11/17.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseLRCView : UIView

-(instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url;

-(void)scrollWithTime:(NSTimeInterval)time;

@property (nonatomic,assign) NSTimeInterval totalTime;


@end
