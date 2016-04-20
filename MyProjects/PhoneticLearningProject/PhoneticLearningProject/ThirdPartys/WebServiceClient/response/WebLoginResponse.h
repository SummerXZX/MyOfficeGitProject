//
//  WebLoginResponse.h
//  PhoneticLearningProject
//
//  Created by test on 15/11/12.
//  Copyright © 2015年 ;. All rights reserved.
//

#import "WebResponse.h"


@interface WebLoginData : NSObject

@property (nonatomic,strong) NSString *address1;

@property (nonatomic,strong) NSString *address2;

@property (nonatomic,strong) NSString *city;

@property (nonatomic,strong) NSString *email;

@property (nonatomic,strong) NSString *firstName;

@property (nonatomic,strong) NSString *grade;

@property (nonatomic,strong) NSString *isGolden;

@property (nonatomic,strong) NSString *isvalid;

@property (nonatomic,strong) NSString *lastAccessDate;

@property (nonatomic,strong) NSString *lastName;

@property (nonatomic,assign) BOOL loginaccount;

@property (nonatomic,strong) NSString *middleInitial;

@property (nonatomic,strong) NSString *msgID;

@property (nonatomic,strong) NSString *nativeLanguage;

@property (nonatomic,strong) NSString *password;

@property (nonatomic,strong) NSString *phone;

@property (nonatomic,strong) NSString *referrer;

@property (nonatomic,strong) NSString *registerDate;

@property (nonatomic,strong) NSString *school;

@property (nonatomic,strong) NSString *secretanswer;

@property (nonatomic,strong) NSString *secretquestion;

@property (nonatomic,strong) NSString *showMsg;

@property (nonatomic,strong) NSString *spellOn;

@property (nonatomic,strong) NSString *state;

@property (nonatomic,strong) NSString *tutor;

@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *userType;

@property (nonatomic,strong) NSString *userstate;

@property (nonatomic,strong) NSString *zipcode;

@end

@interface WebLoginResponse : WebResponse

@property (nonatomic,strong) WebLoginData *data;

@end
