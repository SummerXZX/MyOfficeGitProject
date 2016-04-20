//
//  WebServiceHelper.h
//  Love7Ke
//
//  Created by mac on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define my_web_address @"http://180.97.31.16:8081/"
#define my_web_service @"service.asmx"
#ifndef my_web_namespace
#define my_web_namespace @"http://northcloud.org/"
#endif
@class WebServiceHelper;
@protocol WebServiceDelegate <NSObject>
@optional
-(void)requestFinished:(WebServiceHelper*)helper;
-(void)requestFailed:(WebServiceHelper*)helper;  
@end
@interface WebServiceHelper : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property(readonly) BOOL isRequesting;
@property(retain,nonatomic) NSString* funName;
@property(retain,nonatomic) NSMutableString* funpars;
@property(retain,nonatomic)id<WebServiceDelegate> delegate;
@property(retain,nonatomic)NSError* error;
@property(retain,nonatomic) NSMutableData* responseData;
+(NSString *)getWSDLURL;
+(NSString*)getUploadURL;
+(NSMutableURLRequest*) getRequest:(NSString*)funcationName  parameter:(NSString*) pars;

-(id)initWebService:(NSString*)funcationName;

-(void)uploadWithPath:(NSString*)filepath;
-(void)uploadWithImage:(UIImage*)image;

-(void)addParameterForString:(NSString*) name value:(NSString*)value;
-(void)addParameterForInt:(NSString *)name value:(NSInteger)value;
-(void)addParameterForFloat:(NSString *)name value:(CGFloat)value;
-(void)addParameterForBool:(NSString *)name value:(BOOL)value;
-(void)addParameterWithDictionary:(NSDictionary *)dic;
-(void)startSynchronous;
-(void)startASynchronous;
-(NSString*)getSimpleResult;
-(NSString*)getArrayResult;
@end
@interface UploadNSRequest : NSObject

+(NSMutableURLRequest*)uploading:(UIImage*)image message:(NSString*)mes;

@end
