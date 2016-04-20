//
//  HomeBookCell.h
//  PhoneticLearningProject
//
//  Created by test on 15/11/12.
//  Copyright © 2015年 yimi. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat HomeBookCellHeight = 180.0;

@interface HomeBookCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;///<书的图片

@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;///<书的名字label

@property (weak, nonatomic) IBOutlet UIImageView *itemBgImageView;///<item背景图片


@end
