//
//  WebLoginResponse.h
//  MyNewCloudProject
//
//  Created by Summer on 16/4/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "WebNomalResponse.h"

@interface LoginUserInfo : NSObject

@property (nonatomic, copy) NSString *gaCall;///<政务通短号

@property (nonatomic, assign) NSInteger userGender;///<

@property (nonatomic, assign) NSInteger userStatus;///<用户状态

@property (nonatomic, copy) NSString *userPhone;///<手机号

@property (nonatomic, copy) NSString *departmentCall;///<

@property (nonatomic, copy) NSString *departmentCode;///<部门编号

@property (nonatomic, assign) NSInteger userLock;///<是否锁定

@property (nonatomic, copy) NSString *workCall;///<工作电话

@property (nonatomic, copy) NSString *userAlias;///<

@property (nonatomic, copy) NSString *departmentFullName;///<部门名称

@property (nonatomic, copy) NSString *officeCall;///<办公室电话

@property (nonatomic, copy) NSString *userIcon;///<用户头像

@property (nonatomic, copy) NSString *userLoginPassword;///<登录密码

@property (nonatomic, copy) NSString *originPassword;///<初始密码

@property (nonatomic, copy) NSString *companyFullName;///<单位名称

@property (nonatomic, copy) NSString *appJoinTime;///<

@property (nonatomic, assign) NSInteger isExist;///<是否存在

@property (nonatomic, copy) NSString *userCode;///<用户编号

@property (nonatomic, copy) NSString *backupsUserPhone;///<备用手机号码

@property (nonatomic, copy) NSString *role;///<权限

@property (nonatomic, copy) NSString *postCode;///<职务编号

@property (nonatomic, copy) NSString *userLogin;///<登录帐号

@property (nonatomic, copy) NSString *userName;///<姓名

@property (nonatomic, copy) NSString *backupsGaCall;///<备用政务通短号

@property (nonatomic, copy) NSString *companyCode;///<单位编号

@property (nonatomic, copy) NSString *roleCode;///<权限编号

@property (nonatomic, copy) NSString *postName;///<职务名称

@end

@interface WebLoginResponse : WebNomalResponse

@property (nonatomic, strong) LoginUserInfo *data;

@end
