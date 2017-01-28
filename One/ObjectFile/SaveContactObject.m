//
//  SaveContactObject.m
//  CountryHillElementary
//
//  Created by Daksha on 9/7/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//
#define kSaveContactObject          @"kSaveContactObject"
#import "SaveContactObject.h"
#import "Extentions.h"
#import "ECSHelper.h"
@implementation SaveContactObject


- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
        
      
        self.firstName =[decoder decodeObjectForKey:@"firstName"];
        self.lastName =[decoder decodeObjectForKey:@"lastName"];
        self.email =[decoder decodeObjectForKey:@"email"];
        self.favourite =[decoder decodeObjectForKey:@"favourite"];
        self.phone =[decoder decodeObjectForKey:@"phone"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
   
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.favourite forKey:@"favourite"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    
}



+ (SaveContactObject *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    SaveContactObject *instance =  [[SaveContactObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
  
    self.firstName = [aDictionary nonNullObjectForKey:@"firstName"];
    self.lastName = [aDictionary objectForKey:@"lastName"];
    self.email = [aDictionary objectForKey:@"email"];
    self.favourite = [aDictionary objectForKey:@"favourite"];
    self.phone = [aDictionary objectForKey:@"phone"];
    
    
}


-(void)saveToUserDefault
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [ECSUserDefault saveObject:data ToUserDefaultForKey:kSaveContactObject];
}
+(instancetype)getFromUserDefault
{
    NSData * data = [ECSUserDefault getObjectFromUserDefaultForKey:kSaveContactObject];
    return[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+(void)removeFromUserDefault
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kSaveContactObject];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
