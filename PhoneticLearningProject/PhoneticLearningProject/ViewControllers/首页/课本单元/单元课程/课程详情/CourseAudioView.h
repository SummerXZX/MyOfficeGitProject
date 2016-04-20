//
//  CourseAudioView.h
//  PhoneticLearningProject
//
//  Created by test on 15/11/17.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseAudioView : UIView

-(instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url;

-(instancetype)initWithFrame:(CGRect)frame AudioURL:(NSURL *)audioURL LrcURL:(NSURL *)lrcURL;

@end
