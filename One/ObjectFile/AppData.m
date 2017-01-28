#import "AppData.h"

#import "MenuLink.h"

@implementation AppData
+ (AppData *)instanceFromDictionary:(NSDictionary *)aDictionary {

    AppData *instance = [[AppData alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.appFullName = [aDictionary objectForKey:@"AppFullName"];
    self.appHeaderColorcode = [aDictionary objectForKey:@"appHeaderColorcode"];
    self.applogicKey = [aDictionary objectForKey:@"applogicKey"];
    self.appName = [aDictionary objectForKey:@"appName"];
    self.appSecondaryColorCode = [aDictionary objectForKey:@"appSecondaryColorCode"];
    self.invitationCode = [aDictionary objectForKey:@"invitationCode"];

    NSArray *receivedMenuLinks = [aDictionary objectForKey:@"menuLinks"];
    if ([receivedMenuLinks isKindOfClass:[NSArray class]]) {

        NSMutableArray *populatedMenuLinks = [NSMutableArray arrayWithCapacity:[receivedMenuLinks count]];
        for (NSDictionary *item in receivedMenuLinks) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [populatedMenuLinks addObject:[MenuLink instanceFromDictionary:item]];
            }
        }

        self.menuLinks = populatedMenuLinks;

    }
    self.sourceParam = [aDictionary objectForKey:@"source_param"];
    self.urlScheme = [aDictionary objectForKey:@"urlScheme"];

}


@end
