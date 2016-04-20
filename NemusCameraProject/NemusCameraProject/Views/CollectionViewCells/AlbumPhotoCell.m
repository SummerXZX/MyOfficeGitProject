//
//  AlbumPhotoCell.m
//  NemusCameraProject
//
//  Created by Summer on 16/4/16.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "AlbumPhotoCell.h"

@implementation AlbumPhotoCell

#pragma mark photoImageView
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.layer.borderWidth = 2.0;
        _photoImageView.layer.borderUIColor = [UIColor whiteColor];
    }
    return _photoImageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addSubview:self.photoImageView];
    
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

@end
