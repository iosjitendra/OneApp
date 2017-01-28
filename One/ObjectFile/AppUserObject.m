//
//  AppUserObject.m
//  
//
//  Created by Shreesh Garg on 09/09/14.
//___COPYRIGHT___
//

#define kAppUserObject          @"kAppUserObject"

#import "AppUserObject.h"
#import "Extentions.h"
#import "ECSHelper.h"

@implementation AppUserObject

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {

        self.appLogicId=[decoder decodeObjectForKey:@"appLogicId"];
        self.activated =[decoder decodeObjectForKey:@"activated"];
        self.age =[decoder decodeObjectForKey:@"age"];
        self.apiToken =[decoder decodeObjectForKey:@"apiToken"];
        self.accessToken =[decoder decodeObjectForKey:@"access_token"];
        self.accessId =[decoder decodeObjectForKey:@"id"];
        self.appSourceName =[decoder decodeObjectForKey:@"appSourceName"];
        self.buckies =[decoder decodeObjectForKey:@"buckies"];
        self.buckwormMerchantId =[decoder decodeObjectForKey:@"buckwormMerchantId"];
        self.buckwormOfferDonation =[decoder decodeObjectForKey:@"buckwormOfferDonation"];
        self.buyTheStuffAndSave =[decoder decodeObjectForKey:@"buyTheStuffAndSave"];
        self.cardSavedOnBraintree =[decoder decodeObjectForKey:@"cardSavedOnBraintree"];
        self.causeId =[decoder decodeObjectForKey:@"causeId"];
        self.causeWebsite =[decoder decodeObjectForKey:@"causeWebsite"];
        self.causesLogo =[decoder decodeObjectForKey:@"causesLogo"];
        self.childrenInSchool =[decoder decodeObjectForKey:@"childrenInSchool"];
        self.city =[decoder decodeObjectForKey:@"city"];
        self.currentAlwaysOn =[decoder decodeObjectForKey:@"currentAlwaysOn"];
        self.currentlyTeachingGrades =[decoder decodeObjectForKey:@"currentlyTeachingGrades"];
        self.deviceId =[decoder decodeObjectForKey:@"deviceId"];
        self.deviceType =[decoder decodeObjectForKey:@"deviceType"];
        self.discountFlag =[decoder decodeObjectForKey:@"discountFlag"];
        self.dob =[decoder decodeObjectForKey:@"dob"];
        self.profileImage =[decoder decodeObjectForKey:@"profileImage"];
        self.donateToChoice =[decoder decodeObjectForKey:@"donateToChoice"];
        self.donationChangeCount =[decoder decodeObjectForKey:@"donationChangeCount"];
        self.email =[decoder decodeObjectForKey:@"email"];
        self.expectedRedeemOffer =[decoder decodeObjectForKey:@"expectedRedeemOffer"];
        self.first =[decoder decodeObjectForKey:@"first"];
        self.firstLoginEver =[decoder decodeObjectForKey:@"firstLoginEver"];
        self.firstAlwaysOnCauseType =[decoder decodeObjectForKey:@"firstAlwaysOnCauseType"];
        self.grade =[decoder decodeObjectForKey:@"grade"];
        self.userId =[decoder decodeObjectForKey:@"userId"];
        self.invitationCode =[decoder decodeObjectForKey:@"invitationCode"];
        self.isCardAdded =[decoder decodeObjectForKey:@"isCardAdded"];
        self.isCauseLogoActive =[decoder decodeObjectForKey:@"isCauseLogoActive"];
        self.isSqoot =[decoder decodeObjectForKey:@"isSqoot"];
        self.isInvited =[decoder decodeObjectForKey:@"isInvited"];
        self.justHereToCheckItOut =[decoder decodeObjectForKey:@"justHereToCheckItOut"];
        self.lastName =[decoder decodeObjectForKey:@"lastName"];
        self.npCauseId =[decoder decodeObjectForKey:@"npCauseId"];
        self.offerPurchases =[decoder decodeObjectForKey:@"offerPurchases"];
        self.phoneNo =[decoder decodeObjectForKey:@"phoneNo"];
        self.resgistrationDate =[decoder decodeObjectForKey:@"resgistrationDate"];
        self.saveAndHelpCause =[decoder decodeObjectForKey:@"saveAndHelpCause"];
        self.saveMoney =[decoder decodeObjectForKey:@"saveMoney"];
        self.schoolID =[decoder decodeObjectForKey:@"schoolID"];
        self.seeIfParentsCanSave =[decoder decodeObjectForKey:@"seeIfParentsCanSave"];
        self.seeWhatItsAbout =[decoder decodeObjectForKey:@"seeWhatItsAbout"];
        self.sex =[decoder decodeObjectForKey:@"sex"];
        self.shareOffers =[decoder decodeObjectForKey:@"shareOffers"];
        self.state =[decoder decodeObjectForKey:@"state"];
        self.street =[decoder decodeObjectForKey:@"street"];
        self.updatedAt =[decoder decodeObjectForKey:@"updatedAt"];
        self.upgradeStatus =[decoder decodeObjectForKey:@"upgradeStatus"];
        self.useEDAndLearnearn =[decoder decodeObjectForKey:@"useEDAndLearnearn"];
        self.userRole =[decoder decodeObjectForKey:@"userRole"];
        self.userType =[decoder decodeObjectForKey:@"userType"];
        self.username =[decoder decodeObjectForKey:@"username"];
        self.usingBwToPurchaseSchoolSuppliesAndAlwaysOn =[decoder decodeObjectForKey:@"usingBwToPurchaseSchoolSuppliesAndAlwaysOn"];
        self.usingBwToRaiseFunds =[decoder decodeObjectForKey:@"usingBwToRaiseFunds"];
        self.verified =[decoder decodeObjectForKey:@"verified"];
        self.zipcode =[decoder decodeObjectForKey:@"zipcode"];

        
       

        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //appLogicId
    [encoder encodeObject:self.appLogicId forKey:@"appLogicId"];
    [encoder encodeBool:self.activated forKey:@"activated"];
    [encoder encodeObject:self.age forKey:@"age"];
    [encoder encodeObject:self.apiToken forKey:@"apiToken"];
    
    
    [encoder encodeObject:self.accessToken forKey:@"access_token"];
    [encoder encodeObject:self.accessId forKey:@"id"];
    [encoder encodeObject:self.appSourceName forKey:@"source"];
    [encoder encodeObject:self.buckies forKey:@"buckies"];
    [encoder encodeObject:self.buckwormMerchantId forKey:@"buckwormMerchantId"];
    [encoder encodeObject:self.buckwormOfferDonation forKey:@"buckwormOfferDonation"];
    [encoder encodeObject:self.buyTheStuffAndSave forKey:@"buyTheStuffAndSave"];
    [encoder encodeBool:self.cardSavedOnBraintree forKey:@"cardSavedOnBraintree"];
    [encoder encodeObject:self.causeId forKey:@"causeId"];
    [encoder encodeObject:self.causeWebsite forKey:@"causeWebsite"];
    [encoder encodeObject:self.causesLogo forKey:@"causesLogo"];
    [encoder encodeObject:self.childrenInSchool forKey:@"childrenInSchool"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.currentAlwaysOn forKey:@"currentAlwaysOn"];
    [encoder encodeObject:self.currentlyTeachingGrades forKey:@"currentlyTeachingGrades"];
    [encoder encodeObject:self.deviceId forKey:@"deviceId"];
    [encoder encodeObject:self.deviceType forKey:@"deviceType"];
    [encoder encodeObject:self.discountFlag forKey:@"discountFlag"];
    [encoder encodeObject:self.dob forKey:@"dob"];
    [encoder encodeObject:self.profileImage forKey:@"profileImage"];
    
    [encoder encodeObject:self.donateToChoice forKey:@"donateToChoice"];
    [encoder encodeObject:self.donationChangeCount forKey:@"donationChangeCount"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.expectedRedeemOffer forKey:@"expectedRedeemOffer"];
    [encoder encodeObject:self.first forKey:@"first"];
    [encoder encodeObject:self.firstLoginEver forKey:@"firstLoginEver"];
    [encoder encodeObject:self.firstAlwaysOnCauseType forKey:@"firstAlwaysOnCauseType"];
    [encoder encodeObject:self.grade forKey:@"grade"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.invitationCode forKey:@"invitationCode"];
    [encoder encodeObject:self.isCardAdded forKey:@"isCardAdded"];
    [encoder encodeObject:self.isCauseLogoActive forKey:@"isCauseLogoActive"];
    [encoder encodeObject:self.isSqoot forKey:@"isSqoot"];
    [encoder encodeObject:self.isInvited forKey:@"isInvited"];
    [encoder encodeObject:self.justHereToCheckItOut forKey:@"justHereToCheckItOut"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.npCauseId forKey:@"npCauseId"];
    [encoder encodeObject:self.offerPurchases forKey:@"offerPurchases"];
    [encoder encodeObject:self.phoneNo forKey:@"phoneNo"];
    [encoder encodeObject:self.resgistrationDate forKey:@"resgistrationDate"];
    
    [encoder encodeObject:self.saveAndHelpCause forKey:@"saveAndHelpCause"];
    [encoder encodeObject:self.saveMoney forKey:@"saveMoney"];
    [encoder encodeObject:self.schoolID forKey:@"schoolID"];
    [encoder encodeObject:self.seeIfParentsCanSave forKey:@"seeIfParentsCanSave"];
    [encoder encodeObject:self.seeWhatItsAbout forKey:@"seeWhatItsAbout"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.shareOffers forKey:@"shareOffers"];
    [encoder encodeObject:self.state forKey:@"state"];
    [encoder encodeObject:self.street forKey:@"street"];
    [encoder encodeObject:self.upgradeStatus forKey:@"upgradeStatus"];
    [encoder encodeObject:self.useEDAndLearnearn forKey:@"useEDAndLearnearn"];
    [encoder encodeObject:self.userRole forKey:@"userRole"];
    [encoder encodeObject:self.userType forKey:@"userType"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.usingBwToPurchaseSchoolSuppliesAndAlwaysOn forKey:@"usingBwToPurchaseSchoolSuppliesAndAlwaysOn"];
    [encoder encodeObject:self.usingBwToRaiseFunds forKey:@"usingBwToRaiseFunds"];
    [encoder encodeObject:self.verified forKey:@"verified"];
    [encoder encodeObject:self.zipcode forKey:@"zipcode"];

    
    


}



+ (AppUserObject *)instanceFromDictionary:(NSDictionary *)aDictionary {

    AppUserObject *instance =  [[AppUserObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.activated = [(NSNumber *)[aDictionary objectForKey:@"activated"] boolValue];
    self.age = [aDictionary nonNullObjectForKey:@"Age"];
    self.appLogicId=[aDictionary nonNullNumberForKey:@"appLogicId"];
    self.apiToken = [aDictionary objectForKey:@"api_token"];
    
    self.accessToken =[aDictionary objectForKey:@"access_token"];
    self.accessId =[aDictionary objectForKey:@"id"];
    
    self.appSourceName = [aDictionary objectForKey:@"source"];
    self.buckies = [aDictionary objectForKey:@"buckies"];
    self.buckwormMerchantId = [aDictionary objectForKey:@"buckworm_merchant_id"];
    self.buckwormOfferDonation = [aDictionary nonNullNumberForKey:@"Buckworm_offer_donation"];
    self.buyTheStuffAndSave = [aDictionary objectForKey:@"buy_the_stuff_and_save"];
    self.cardSavedOnBraintree = [(NSNumber *)[aDictionary objectForKey:@"card_saved_on_braintree"] boolValue];
    self.causeId = [aDictionary objectForKey:@"cause_id"];
    self.causeWebsite = [aDictionary objectForKey:@"cause_website"];
    self.causesLogo = [aDictionary objectForKey:@"causes_logo"];
    self.childrenInSchool = [aDictionary objectForKey:@"children_in_school"];
    self.city = [aDictionary objectForKey:@"city"];
    self.currentAlwaysOn = [aDictionary objectForKey:@"current_always_on"];
    self.currentlyTeachingGrades = [aDictionary objectForKey:@"Currently_teaching_grades"];
    self.deviceId = [aDictionary objectForKey:@"device_id"];
    self.deviceType = [aDictionary objectForKey:@"device_type"];
    self.discountFlag = [aDictionary objectForKey:@"discount_flag"];
    self.dob = [aDictionary objectForKey:@"dob"];
    self.profileImage = [aDictionary objectForKey:@"profileImage"];
    self.donateToChoice = [aDictionary objectForKey:@"donate_to_choice"];
    self.donationChangeCount = [aDictionary objectForKey:@"donation_change_count"];
    self.email = [aDictionary objectForKey:@"email"];
    self.expectedRedeemOffer = [aDictionary objectForKey:@"expected_redeem_offer"];
    self.first = [aDictionary nonNullObjectForKey:@"first"];
    self.firstLoginEver = [aDictionary objectForKey:@"first_login_ever"];
    self.firstAlwaysOnCauseType = [aDictionary objectForKey:@"firstAlwaysOnCauseType"];
    self.grade = [aDictionary objectForKey:@"grade"];
    self.userId = [aDictionary objectForKey:@"id"];
    self.invitationCode = [aDictionary objectForKey:@"invitation_code"];
    self.isCardAdded = [aDictionary objectForKey:@"is_card_added"];
    self.isCauseLogoActive = [aDictionary objectForKey:@"is_cause_logo_active"];
    self.isSqoot = [aDictionary objectForKey:@"is_sqoot"];
    self.isInvited = [aDictionary objectForKey:@"isInvited"];
    self.justHereToCheckItOut = [aDictionary objectForKey:@"just_here_to_check_it_out"];
    self.lastName = [aDictionary nonNullObjectForKey:@"last_name"];
    self.npCauseId = [aDictionary objectForKey:@"np_cause_id"];
    self.offerPurchases = [aDictionary objectForKey:@"Offer_purchases"];
    self.phoneNo = [aDictionary nonNullObjectForKey:@"phone_no"];
    self.resgistrationDate = [aDictionary objectForKey:@"resgistration_date"];
    self.saveAndHelpCause = [aDictionary objectForKey:@"save_and_help_cause"];
    self.saveMoney = [aDictionary objectForKey:@"save_money"];
    self.schoolID = [aDictionary objectForKey:@"schoolID"];
    self.seeIfParentsCanSave = [aDictionary objectForKey:@"see_if_parents_can_save"];
    self.seeWhatItsAbout = [aDictionary objectForKey:@"see_what_its_about"];
    self.sex = [aDictionary objectForKey:@"sex"];
    self.shareOffers = [aDictionary objectForKey:@"share_offers"];
    self.state = [aDictionary objectForKey:@"state"];
    self.street = [aDictionary objectForKey:@"street"];
    self.updatedAt = [aDictionary objectForKey:@"updated_at"];
    self.upgradeStatus = [aDictionary objectForKey:@"upgrade_status"];
    self.useEDAndLearnearn = [aDictionary objectForKey:@"use_ED_and_learnearn"];
    self.userRole = [aDictionary objectForKey:@"user_role"];
    self.userType = [aDictionary objectForKey:@"user_type"];
    self.username = [aDictionary objectForKey:@"username"];
    self.usingBwToPurchaseSchoolSuppliesAndAlwaysOn = [aDictionary objectForKey:@"using_bw_to_purchase_school_supplies_and_always_on"];
    self.usingBwToRaiseFunds = [aDictionary objectForKey:@"using_bw_to_raise_funds"];
    self.verified = [aDictionary objectForKey:@"verified"];
    self.zipcode = [aDictionary objectForKey:@"zipcode"];

    

    
    
}


-(void)saveToUserDefault
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [ECSUserDefault saveObject:data ToUserDefaultForKey:kAppUserObject];
}
+(instancetype)getFromUserDefault
{
    NSData * data = [ECSUserDefault getObjectFromUserDefaultForKey:kAppUserObject];
    return[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+(void)removeFromUserDefault
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kAppUserObject];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
