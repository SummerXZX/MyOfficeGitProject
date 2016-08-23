//
//  WebUploadImageParamsInfo.h
//  WeiYuanQuan
//
//  Created by Summer on 16/4/9.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebUploadPhotoInfo : NSObject

@property (nonatomic,strong) NSData *imageData;///<图片

@property (nonatomic,strong) NSString *name;///<图片名称

@property (nonatomic,strong) NSString *fileName;///<文件名称

@property (nonatomic,strong) NSString *mimeType;///<文件类型

@end

@interface WebUploadPhotoParams : NSObject

@property (nonatomic,strong) NSDictionary *params;///<普通参数

@property (nonatomic,strong) NSArray *photos;///<图片数组

@end
