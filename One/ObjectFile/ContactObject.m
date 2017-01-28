#import "ContactObject.h"
#import "Extentions.h"

@implementation ContactObject
+ (ContactObject *)instanceFromDictionary:(NSDictionary *)aDictionary {

    ContactObject *instance = [[ContactObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.contactId = [aDictionary nonNullObjectForKey:@"contact_id"];
    self.email = [aDictionary nonNullObjectForKey:@"email"];
    self.firstName = [aDictionary nonNullObjectForKey:@"first_name"];
    self.groupId = [aDictionary nonNullObjectForKey:@"groupId"];
    self.groupLogo = [aDictionary nonNullObjectForKey:@"groupLogo"];
    self.groupName = [aDictionary nonNullObjectForKey:@"groupName"];
    self.image = [aDictionary nonNullObjectForKey:@"image"];
    self.isFav = [aDictionary nonNullObjectForKey:@"isFav"];
    self.lastName = [aDictionary nonNullObjectForKey:@"last_name"];
    self.appLogicId = [aDictionary nonNullNumberForKey:@"appLogicId"];
    self.phoneNo = [aDictionary nonNullObjectForKey:@"phone_no"];
    
    //@property (nonatomic, copy) NSNumber *is_chat_registered;


}


@end
