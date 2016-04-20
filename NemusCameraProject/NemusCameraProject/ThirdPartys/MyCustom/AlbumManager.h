//
//  AlbumManager.h
//  NemusCameraProject
//
//  Created by Summer on 16/4/16.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumManager : NSObject

/**
 *  保存图片
 */
+ (BOOL)saveImageWithImageData:(NSData *)data ImageName:(NSString *)imageName;

/**
 *  获取所有原始图片url
 */
+ (NSArray *)getAllImageURLs;

/**
 *  获取所有缩略图图片url
 */
+ (NSArray *)getAllThumbnailImageURLs;

@end
