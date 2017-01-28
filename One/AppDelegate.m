//
//  AppDelegate.m
//  One
//
//  Created by Daksha on 1/10/17.
//  Copyright © 2017 Daksha. All rights reserved.
//

#import "AppDelegate.h"
#import "MVYSideMenuController.h"
#import <CoreLocation/CoreLocation.h>
#import "ECSHelper.h"
#import "CH_HomeVC.h"
#import "DS_SideMenuVC.h"
#import <AddressBook/AddressBook.h>
#import "DS_LaunchScreen.h"
#import "ALUserDefaultsHandler.h"
#import "ALRegisterUserClientService.h"
#import "ALPushNotificationService.h"
#import "ALAppLocalNotifications.h"
#import "AppUserObject.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "BC_ResetPassword.h"
#import "BC_ConferenceVC.h"
#import "DS_OneForgotPassVC.h"
@interface AppDelegate ()
@property (nonatomic, retain) UIViewController * baseController;
@property (nonatomic, retain) UIViewController * splashScreenViewController;
@property (nonatomic, retain) NSString * launchUrl;
@property (assign) SEL callback;
@end

@implementation AppDelegate
@synthesize locationManager;
@synthesize currentLocationPoint;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
    self.launchUrl = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
    UIViewController *contentVC=[[CH_HomeVC alloc]initWithNibName:@"CH_HomeVC" bundle:nil];
    
    UIViewController *menuVC=[[DS_SideMenuVC alloc]initWithNibName:@"DS_SideMenuVC" bundle:nil];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];
    [contentNavigationController setNavigationBarHidden:YES];
    MVYSideMenuOptions *options = [[MVYSideMenuOptions alloc] init];
    options.contentViewScale = 1.0;
    options.contentViewOpacity = 0.05;
    options.shadowOpacity = 0.0;
    self.sideMenuController = [[MVYSideMenuController alloc] initWithMenuViewController:menuVC
                                                                  contentViewController:contentNavigationController
                                                                                options:options];
    self.sideMenuController.menuFrame = CGRectMake(0, 0, 290.0, self.window.bounds.size.height);
    
    
    
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.sideMenuController];
    sleep(0.05);

    [self.window setRootViewController:self.navigationController];
    
    //self.navigationController.navigationBar.hidden=YES;
    self.window.rootViewController = self.navigationController;
     [self.navigationController setNavigationBarHidden:YES];
    
    [self.window  makeKeyAndVisible];
    
    double delayInSeconds = 1.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.distanceFilter = 100;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    });
    
    [[Crashlytics sharedInstance] setDebugMode:YES];
    [Fabric with:@[[Crashlytics class]]];
    
    
    
    ALAppLocalNotifications *localNotification = [ALAppLocalNotifications appLocalNotificationHandler];
    [localNotification dataConnectionNotificationHandler];
    
    // Override point for customization after application launch.
    NSLog(@"launchOptions: %@", launchOptions);
    if (launchOptions != nil) {
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil) {
            NSLog(@"Launched from push notification: %@", dictionary);
            ALPushNotificationService *pushNotificationService = [[ALPushNotificationService alloc] init];
            BOOL applozicProcessed = [pushNotificationService processPushNotification:dictionary updateUI:[NSNumber numberWithInt:APP_STATE_INACTIVE]];
            
            //IF not a appplozic notification, process it
            if (!applozicProcessed) {
                //Note: notification for app
            }
        }
    }
    
    
    
    
    

    return YES;
}
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PausePlayerObserverKey" object:receivedEvent];
    
}
-(void)getCurrentLocation:(UIViewController *)controller withCallback:(SEL)callBack
{
    self.baseController = controller;
    self.callback = callBack;
    
    if (nil == self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = (id<CLLocationManagerDelegate>)self;
        self.locationManager.delegate=self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 500;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];// meters
        
    }
    else
        [self performSelector:@selector(locationManagerUpdatedWithLocation:) withObject:self.locationManager.location afterDelay:0];
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    // self.currentLocation = location;
    [self performSelector:@selector(locationManagerUpdatedWithLocation:) withObject:location afterDelay:0];
    
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // self.currentLocation = newLocation;
    [self performSelector:@selector(locationManagerUpdatedWithLocation:) withObject:newLocation afterDelay:0];
}





-(void)locationManagerUpdatedWithLocation:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             //addressDictionary
             self.appUserCity = [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
             self.appUserState = [placemark administrativeArea];
             [self.baseController performSelector:self.callback withObject:nil afterDelay:0];
             [self.locationManager stopUpdatingLocation];
             
         }
         else
         {
             [ECSAlert showAlert:@"We are not able to find your location"];
         }
     }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    if (self.launchUrl) {
        [self moveToResetPasswordScreen:self.launchUrl];
        self.launchUrl = nil;
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

-(void)moveToResetPasswordScreen:(NSString *)urlString
{
    
    NSString *oneViewLiveStream=@"oneViewLiveStream";
    
    NSString *resetPassword = @"oneresetpass";
    
    NSString *oneJoinConf=@"onejoinconference";
    NSLog(@"urlString %@",urlString);
    
    if([urlString rangeOfString:oneJoinConf.lowercaseString].location !=NSNotFound)
    {
        urlString = [urlString stringByReplacingOccurrencesOfString:oneJoinConf withString:@""];
        NSMutableDictionary * argumnetDict = [[NSMutableDictionary alloc]init];
        NSArray *queryElements = [urlString componentsSeparatedByString:@"&"];
        
        for (NSString *element in queryElements) {
            NSArray *keyVal = [element componentsSeparatedByString:@"="];
            
            if (keyVal.count>0) {
                NSString *variableKey = [keyVal objectAtIndex:0];
                NSString   *value = (keyVal.count == 2) ? [keyVal lastObject] : nil;
                
                
                [argumnetDict setObject:value forKey:variableKey];
            }
            
            
        }
        
        NSString *userID=[argumnetDict valueForKey:@"contactId"];
        
        NSString *roomNo=[argumnetDict valueForKey:@"room"];
        
        BC_ConferenceVC *contentVC=[[BC_ConferenceVC alloc]initWithUsername:userID withRoomNumber:roomNo];
        [self.navigationController pushViewController:contentVC animated:NO];
        
    }

    if([urlString rangeOfString:oneViewLiveStream.lowercaseString].location !=NSNotFound)
    {
       // urlString = [urlString stringByReplacingOccurrencesOfString:resetpassDrag withString:@""];
        NSMutableDictionary * argumnetDict = [[NSMutableDictionary alloc]init];
        NSArray *queryElements = [urlString componentsSeparatedByString:@"&"];
        
        for (NSString *element in queryElements) {
            NSArray *keyVal = [element componentsSeparatedByString:@"="];
            
            if (keyVal.count>0) {
                NSString *variableKey = [keyVal objectAtIndex:0];
                NSString   *value = (keyVal.count == 2) ? [keyVal lastObject] : nil;
                
                //                 token = (keyVal.count == 2) ? [keyVal lastObject] : nil;
                //                                NSLog(@"variableKey %@",variableKey);
                //                                 NSLog(@"value %@",userName);
                //                NSLog(@"token %@",token);
                [argumnetDict setObject:value forKey:variableKey];
            }
            
            
        }
        NSLog(@"argumnetDict %@",argumnetDict);
        NSString *streamId=[argumnetDict valueForKey:@"oneviewlivestream://?stream_url"];
        
//        DS_PlayStreamVC *contentVC=[[DS_PlayStreamVC alloc]initWithNibName:@"DS_PlayStreamVC" bundle:nil];
//        
//        // contentVC.ChpStreamId=streamId;
//        
//        [self.navigationController pushViewController:contentVC animated:NO];
    }
    
    if([urlString rangeOfString:resetPassword.lowercaseString].location !=NSNotFound)
    {
        urlString = [urlString stringByReplacingOccurrencesOfString:resetPassword withString:@""];
        NSMutableDictionary * argumnetDict = [[NSMutableDictionary alloc]init];
        NSArray *queryElements = [urlString componentsSeparatedByString:@"&"];
        
        for (NSString *element in queryElements) {
            NSArray *keyVal = [element componentsSeparatedByString:@"="];
            
            if (keyVal.count>0) {
                NSString *variableKey = [keyVal objectAtIndex:0];
                NSString   *value = (keyVal.count == 2) ? [keyVal lastObject] : nil;
                
                
                [argumnetDict setObject:value forKey:variableKey];
            }
            
            
        }
        NSLog(@"argumnetDict %@",argumnetDict);
        NSString *username=[argumnetDict valueForKey:@"://?username"];
        
        NSString *token=[argumnetDict valueForKey:@"token"];
        
//        BC_ResetPassword *contentVC=[[BC_ResetPassword alloc]initWithNibName:@"BC_ResetPassword" bundle:nil];
//        
//        contentVC.username1=username;
//        contentVC.token=token;
//        [self.navigationController pushViewController:contentVC animated:NO];
        
            DS_OneForgotPassVC * contactVc= [[DS_OneForgotPassVC alloc]initWithNibName:@"DS_OneForgotPassVC" bundle:nil];
      //      contactVc.userData=object;
           contactVc.username1=username;
           contactVc.token=token;
            [self.navigationController pushViewController:contactVc animated:NO];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Controller is here" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
    //    return YES;
    
    [self moveToResetPasswordScreen:url.absoluteString];
    return YES;
    
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)
deviceToken {
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSString *apnDeviceToken = hexToken;
    NSLog(@"apnDeviceToken: %@", hexToken);
    
    //TO AVOID Multiple call to server check if previous apns token is same as recent one,
    // If its different then call Applozic server.
    
    if (![[ALUserDefaultsHandler getApnDeviceToken] isEqualToString:apnDeviceToken]) {
        ALRegisterUserClientService *registerUserClientService = [[ALRegisterUserClientService alloc] init];
        [registerUserClientService updateApnDeviceTokenWithCompletion
         :apnDeviceToken withCompletion:^(ALRegistrationResponse
                                          *rResponse, NSError *error) {
             
             if (error) {
                 NSLog(@"%@",error);
                 return;
             }
             NSLog(@"Registration response from server:%@", rResponse);
         }];
    }
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"Received notification Completion: %@", userInfo);
    ALPushNotificationService *pushNotificationService = [[ALPushNotificationService alloc] init];
    [pushNotificationService notificationArrivedToApplication:application withDictionary:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    ALRegisterUserClientService *registerUserClientService = [[ALRegisterUserClientService alloc] init];
    [registerUserClientService disconnect];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APP_ENTER_IN_BACKGROUND" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    ALRegisterUserClientService *registerUserClientService = [[ALRegisterUserClientService alloc] init];
    [registerUserClientService connect];
    [ALPushNotificationService applicationEntersForeground];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APP_ENTER_IN_FOREGROUND" object:nil];
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)dictionary {
    
    NSLog(@"Received notification WithoutCompletion: %@", dictionary);
    ALPushNotificationService *pushNotificationService = [[ALPushNotificationService alloc] init];
    [pushNotificationService notificationArrivedToApplication:application withDictionary:dictionary];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[ALDBHandler sharedInstance] saveContext];
}






@end
