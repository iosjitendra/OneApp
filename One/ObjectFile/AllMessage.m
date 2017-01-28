#import "AllMessage.h"

@implementation AllMessage
+ (AllMessage *)instanceFromDictionary:(NSDictionary *)aDictionary {

    AllMessage *instance = [[AllMessage alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.messageId = [aDictionary objectForKey:@"messageId"];
    self.messageText = [aDictionary objectForKey:@"messageText"];
    self.senderId = [aDictionary objectForKey:@"senderId"];
    self.sentOn = [aDictionary objectForKey:@"sentOn"];
    self.sourceApp = [aDictionary objectForKey:@"sourceApp"];
    self.status = [aDictionary objectForKey:@"status"];

}


@end
