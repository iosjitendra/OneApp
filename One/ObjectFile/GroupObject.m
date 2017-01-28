#import "GroupObject.h"

#import "ContactObject.h"

@implementation GroupObject
+ (GroupObject *)instanceFromDictionary:(NSDictionary *)aDictionary {

    GroupObject *instance = [[GroupObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }


    NSArray *receivedContacts = [aDictionary objectForKey:@"contacts"];
    if ([receivedContacts isKindOfClass:[NSArray class]]) {

        NSMutableArray *populatedContacts = [NSMutableArray arrayWithCapacity:[receivedContacts count]];
        for (NSDictionary *item in receivedContacts) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [populatedContacts addObject:[ContactObject instanceFromDictionary:item]];
            }
        }

        self.contacts = populatedContacts;

    }
    self.createdAt = [aDictionary objectForKey:@"created_at"];
    self.groupObjectId = [aDictionary objectForKey:@"id"];
    self.appLogicId = [aDictionary objectForKey:@"appLogicId"];

    self.image = [aDictionary objectForKey:@"image"];
    self.lastUpdatedOn = [aDictionary objectForKey:@"LastUpdatedOn"];
    self.name = [aDictionary objectForKey:@"name"];

}


@end
