#import "ConnectionObject.h"

@implementation ConnectionObject

@synthesize groupName = groupName;
@synthesize isFav = isFav;
@synthesize personCity = personCity;
@synthesize personId = personId;
@synthesize personImage = personImage;
@synthesize personName = personName;


+ (ConnectionObject *)instanceFromDictionary:(NSDictionary *)aDictionary {

    ConnectionObject *instance = [[ConnectionObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.groupName = [aDictionary objectForKey:@"group_name"];
    self.isFav = [aDictionary objectForKey:@"isFav"];
    self.personCity = [aDictionary objectForKey:@"person_city"];
    self.personId = [aDictionary objectForKey:@"person_id"];
    self.personImage = [aDictionary objectForKey:@"person_image"];
    self.personName = [aDictionary objectForKey:@"person_name"];

}

@end

