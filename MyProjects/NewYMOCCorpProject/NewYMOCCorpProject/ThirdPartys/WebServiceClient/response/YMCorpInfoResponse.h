//
//  YMCorpInfoResponse.h
//  NewYMOCCorpProject
//
//  Created by test on 16/1/4.
//  Copyright © 2016年 yimi. All rights reserved.
//

#import "YMResponse.h"

@interface YMCorpInfo : NSObject

/**商家名*/
@property (nonatomic,copy) NSString *name;
/**企业地址*/
@property (nonatomic,copy) NSString *address;//企业地址
/**城市id*/
@property (nonatomic,assign) NSInteger cityId;
/**联系人*/
@property (nonatomic,copy) NSString *contact;
/**商家类别Id*/
@property (nonatomic,assign) NSInteger ctypeId;
/**商家所属行业*/
@property (nonatomic,assign) NSInteger industryId;
/**商家介绍*/
@property (nonatomic,copy) NSString *intro;
/**商家属性*/
@property (nonatomic,assign) NSInteger propertyId;
/**商家规模*/
@property (nonatomic,assign) NSInteger sizeId;
/**商家电话*/
@property (nonatomic,copy) NSString *tel;

@property (nonatomic,assign) NSInteger areaId;///<区域id

@end


@interface YMCorpInfoResponse : YMResponse
/**商家信息*/
@property (nonatomic,strong) YMCorpInfo *data;

@end
