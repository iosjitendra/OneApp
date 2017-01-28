#import <Foundation/Foundation.h>

@interface AllMessage : NSObject {

}

@property (nonatomic, copy) NSNumber *messageId;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, copy) NSNumber *senderId;
@property (nonatomic, copy) NSString *sentOn;
@property (nonatomic, copy) NSString *sourceApp;
@property (nonatomic, copy) NSString *status;

+ (AllMessage *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
