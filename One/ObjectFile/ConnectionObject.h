#import <Foundation/Foundation.h>

@interface ConnectionObject : NSObject {

    NSString *groupName;
    NSNumber *isFav;
    NSString *personCity;
    NSString *personId;
    NSString *personImage;
    NSString *personName;

}

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSNumber *isFav;
@property (nonatomic, copy) NSString *personCity;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *personImage;
@property (nonatomic, copy) NSString *personName;

+ (ConnectionObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end

