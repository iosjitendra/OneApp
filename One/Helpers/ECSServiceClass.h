//
//  ECSServiceClass.h
//  Ag Mobile App
//
//  Created by Shreesh Garg on 03/03/13.
//  Copyright (c) 2013 eComStreet. All rights reserved.
//

#define CONTENT_TYPE_VAL       @"application/x-www-form-urlencoded"
#define CONTENT_TYPE_KEY       @"Content-Type"
#define AUTH_KEY               @"X-Auth-Key"
#define SERVERURLPATH          @"http://www.buckworm.com/laravel/index.php/api/"
//http://uljalul.com/uljalul-api/index.php/api/
#define AUTH_TOKEN             @"X-AUTH-TOKEN"
#define APP_KEY                @"X-APP-KEY"
#define DEVICE_ID              @"X-DEVICE-ID"
#define DEVICE_ID_VAL          @"12345"
#define APP_KEY_VAL            @"sasefyweadfkdhadsdakshasystemssiowedaflsdfjs"






typedef enum
{
    GET =0,POST = 1, PUT = 2, DELETE = 3, IMAGE = 4, IMAGEPUT = 5

}ServiceMethod;


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ECSResponse : NSObject



@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSError *error;
@property int statusCode;
@property BOOL isValid;
@property (nonatomic, retain) NSDictionary * extraDictionary;
@property (nonatomic, retain) NSMutableURLRequest *urlRequest;
@property (nonatomic, retain) NSString *stringValue;

@end

@interface ECSServiceClass : NSObject

@property ServiceMethod serviceMethod;
@property SEL callback;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) NSString *serviceURL;


-(void)addParam:(NSString *)value forKey:(NSString *)key;
-(void)addHeader:(NSString *)value forKey:(NSString *)key;
-(void)addImageData:(NSData *)data withName:(NSString *)name forKey:(NSString *)key;
-(void)addExtraParam:(NSString *)value forKey:(NSString *)key;
-(void)addJson:(NSString *)stringData;
-(void)runService;





@end
