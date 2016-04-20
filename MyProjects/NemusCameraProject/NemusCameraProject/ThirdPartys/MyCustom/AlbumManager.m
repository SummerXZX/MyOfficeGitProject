//
//  AlbumManager.m
//  NemusCameraProject
//
//  Created by Summer on 16/4/16.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "AlbumManager.h"

static NSString *OriginalAlbumName = @"Original";
static NSString *ThumbnailAlbumName = @"Thumbnail";

@implementation AlbumManager

#pragma mark 保存图片
+ (BOOL)saveImageWithImageData:(NSData *)data ImageName:(NSString *)imageName {
    
    NSString *originalPath = [AlbumManager getOriginalAlbumPath];
    [ProjectUtil showLog:@"originalPath:%@",originalPath];
    NSString *thumPath = [AlbumManager getThumbnailAlbumPath];
    [ProjectUtil showLog:@"thumPath:%@",thumPath];
    [data writeToFile:[originalPath stringByAppendingPathComponent:imageName] atomically:YES];
    UIImage *thumbnailImage = [AlbumManager generatePhotoThumbnail:[UIImage imageWithData:[data copy]]];
    NSData *thumbnailData = UIImageJPEGRepresentation(thumbnailImage, 1.0);
   return [thumbnailData writeToFile:[thumPath stringByAppendingPathComponent:imageName] atomically:YES];
}

#pragma mark 获取相册总路径
+ (NSString *)getRootAlbumPath {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"Album"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
    return path;
}

#pragma mark 获取原始图相册路径
+ (NSString *)getOriginalAlbumPath {
    NSString *path = [[AlbumManager getRootAlbumPath]stringByAppendingPathComponent:OriginalAlbumName];
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
   return path;
}

#pragma mark 获取缩略图相册路径
+ (NSString *)getThumbnailAlbumPath {
    NSString *path = [[AlbumManager getRootAlbumPath]stringByAppendingPathComponent:ThumbnailAlbumName];
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
    return path;
}

#pragma mark 获取所有原始图片url
+ (NSArray *)getAllImageURLs {
    
    return [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[AlbumManager getOriginalAlbumPath]] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil] ;
}

#pragma mark 获取所有缩略图图片url
+ (NSArray *)getAllThumbnailImageURLs {
     return [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[AlbumManager getThumbnailAlbumPath]] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil] ;
}

+ (UIImage *)generatePhotoThumbnail:(UIImage *)image {
    // Create a thumbnail version of the image for the event object.
    CGSize size = image.size;
    CGSize croppedSize;
    CGFloat ratio = 64.0;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping
    
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    
    return thumbnail;
}


@end
