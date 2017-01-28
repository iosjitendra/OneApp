#import "UsersDetails.h"
#import "ECSHelper.h"
@implementation UsersDetails
+ (UsersDetails *)instanceFromDictionary:(NSDictionary *)aDictionary {

    UsersDetails *instance = [[UsersDetails alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.email = [aDictionary objectForKey:@"email"];
    self.first = [aDictionary objectForKey:@"first"];
    self.lastName = [aDictionary objectForKey:@"last_name"];
    self.profileImage = [aDictionary objectForKey:@"profileImage"];

}


//-(void)saveToUserDefault
//{
//    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
//    [ECSUserDefault saveObject:data ToUserDefaultForKey:@"userDetail"];
//}
//+(instancetype)getFromUserDefault
//{
//    NSData * data = [ECSUserDefault getObjectFromUserDefaultForKey:@"userDetail"];
//    return[NSKeyedUnarchiver unarchiveObjectWithData:data];
//}
//
//+(void)removeFromUserDefault
//{
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userDetail"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//}

@end
