#import <Foundation/Foundation.h>

@interface ContactObject : NSObject {

}

@property (nonatomic, copy) NSNumber *contactId;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSNumber *groupId;
@property (nonatomic, copy) NSString *groupLogo;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *isFav;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *phoneNo;
@property (nonatomic, copy) NSString *appLogicId;

//@property (nonatomic, copy) NSNumber *is_chat_registered;

//appLogicId

+ (ContactObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
