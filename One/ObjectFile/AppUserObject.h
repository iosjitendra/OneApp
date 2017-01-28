//
//  AppUserObject.h
//  
//
//  Created by Shreesh Garg on 09/09/14.
//___COPYRIGHT___
//

#import <Foundation/Foundation.h>

@class LocationObject;

@interface AppUserObject : NSObject 

{
   


}

@property (nonatomic, assign) BOOL activated;//appLogicId
@property (nonatomic, copy) NSString *appLogicId;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *apiToken;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *appSourceName;
@property (nonatomic, copy) NSString *buckies;
@property (nonatomic, copy) NSString *buckwormMerchantId;
@property (nonatomic, copy) NSNumber *buckwormOfferDonation;
@property (nonatomic, strong) id buyTheStuffAndSave;
@property (nonatomic, assign) BOOL cardSavedOnBraintree;
@property (nonatomic, strong) id causeId;
@property (nonatomic, copy) NSString *causeWebsite;
@property (nonatomic, copy) NSString *causesLogo;
@property (nonatomic, copy) NSString *childrenInSchool;
@property (nonatomic, strong) id city;
@property (nonatomic, copy) NSString *currentAlwaysOn;
@property (nonatomic, strong) id currentlyTeachingGrades;
@property (nonatomic, strong) id deviceId;
@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, copy) NSNumber *discountFlag;
@property (nonatomic, strong) id dob;
@property (nonatomic, copy) NSString *donateToChoice;
@property (nonatomic, copy) NSNumber *donationChangeCount;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *expectedRedeemOffer;
@property (nonatomic, copy) NSString *first;
@property (nonatomic, copy) NSString *firstLoginEver;
@property (nonatomic, copy) NSString *firstAlwaysOnCauseType;
@property (nonatomic, strong) id grade;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSNumber *accessId;
@property (nonatomic, strong) id invitationCode;
@property (nonatomic, copy) NSString *isCardAdded;
@property (nonatomic, copy) NSNumber *isCauseLogoActive;
@property (nonatomic, copy) NSNumber *isSqoot;
@property (nonatomic, copy) NSString *isInvited;
@property (nonatomic, strong) id justHereToCheckItOut;
@property (nonatomic, strong) id lastName;
@property (nonatomic, copy) NSNumber *npCauseId;
@property (nonatomic, copy) NSString *offerPurchases;
@property (nonatomic, copy) NSString *phoneNo;
@property (nonatomic, copy) NSString *resgistrationDate;
@property (nonatomic, strong) id saveAndHelpCause;
@property (nonatomic, strong) id saveMoney;
@property (nonatomic, strong) id schoolID;
@property (nonatomic, strong) id seeIfParentsCanSave;
@property (nonatomic, strong) id seeWhatItsAbout;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, strong) id shareOffers;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) id street;
@property (nonatomic, copy) NSString *profileImage;
@property (nonatomic, copy) NSString *updatedAt;
@property (nonatomic, copy) NSNumber *upgradeStatus;
@property (nonatomic, strong) id useEDAndLearnearn;
@property (nonatomic, copy) NSString *userRole;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) id usingBwToPurchaseSchoolSuppliesAndAlwaysOn;
@property (nonatomic, strong) id usingBwToRaiseFunds;
@property (nonatomic, copy) NSNumber *verified;
@property (nonatomic, strong) id zipcode;

+ (AppUserObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
-(void)saveToUserDefault;
+(instancetype)getFromUserDefault;
+(void)removeFromUserDefault;
@end


