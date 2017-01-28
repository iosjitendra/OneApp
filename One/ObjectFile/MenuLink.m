#import "MenuLink.h"

@implementation MenuLink
+ (MenuLink *)instanceFromDictionary:(NSDictionary *)aDictionary {

    MenuLink *instance = [[MenuLink alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.image = [aDictionary objectForKey:@"image"];
    self.label = [aDictionary objectForKey:@"label"];
    self.url = [aDictionary objectForKey:@"url"];

}


@end
