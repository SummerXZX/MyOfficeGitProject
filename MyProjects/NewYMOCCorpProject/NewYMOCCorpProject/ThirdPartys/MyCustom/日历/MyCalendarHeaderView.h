//
//  MyCalenderHeaderView.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/20.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCalendarHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end
