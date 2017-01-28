//
//  SaveContactObject.h
//  CountryHillElementary
//
//  Created by Daksha on 9/7/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveContactObject : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *favourite;
@property (nonatomic, copy) NSString *phone;
+ (SaveContactObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
-(void)saveToUserDefault;
+(instancetype)getFromUserDefault;
+(void)removeFromUserDefault;

@end
