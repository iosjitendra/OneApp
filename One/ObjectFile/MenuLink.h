#import <Foundation/Foundation.h>

@interface MenuLink : NSObject {

    NSString *image;
    NSString *label;
    NSString *url;

}

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *url;

+ (MenuLink *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
