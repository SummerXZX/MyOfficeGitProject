//
//  ChooseCityHeaderView.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/13.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) UILabel *titleLabel;

/**
 *  初始化方法
 */
-(instancetype)initAddLineViewWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
