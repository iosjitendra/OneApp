#import <Foundation/Foundation.h>

@interface UsersDetails : NSObject {

    NSString *email;
    NSString *first;
    NSString *lastName;
    NSString *profileImage;

}

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *first;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *profileImage;

+ (UsersDetails *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

//-(void)saveToUserDefault;
//+(instancetype)getFromUserDefault;
//+(void)removeFromUserDefault;
@end
