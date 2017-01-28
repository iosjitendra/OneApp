#import <Foundation/Foundation.h>

@interface AppData : NSObject {

    NSString *appFullName;
    NSString *appHeaderColorcode;
    NSString *applogicKey;
    NSString *appName;
    NSString *appSecondaryColorCode;
    NSString *invitationCode;
    NSArray *menuLinks;
    NSString *sourceParam;
    NSString *urlScheme;

}

@property (nonatomic, copy) NSString *appFullName;
@property (nonatomic, copy) NSString *appHeaderColorcode;
@property (nonatomic, copy) NSString *applogicKey;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appSecondaryColorCode;
@property (nonatomic, copy) NSString *invitationCode;
@property (nonatomic, copy) NSArray *menuLinks;
@property (nonatomic, copy) NSString *sourceParam;
@property (nonatomic, copy) NSString *urlScheme;

+ (AppData *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
