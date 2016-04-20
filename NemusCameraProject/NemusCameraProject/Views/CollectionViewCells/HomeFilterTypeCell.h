//
//  HomeFilterTypeCell.h
//  NemusCameraProject
//
//  Created by Summer on 16/4/15.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *HomeFilterTypeCellIdentifier = @"HomeFilterTypeCell";

@interface HomeFilterTypeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *filterImageView;///<滤镜view

@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;///<滤镜名称label

@end
