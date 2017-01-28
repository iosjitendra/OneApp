#import <Foundation/Foundation.h>

@interface GroupObject : NSObject {

}

@property (nonatomic, copy) NSArray *contacts;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSNumber *groupObjectId;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *lastUpdatedOn;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *appLogicId;

+ (GroupObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
