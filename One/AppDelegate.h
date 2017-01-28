//
//  AppDelegate.h
//  One
//
//  Created by Daksha on 1/10/17.
//  Copyright © 2017 Daksha. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CH_HomeVC.h"
#import <MapKit/MapKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import <CoreLocation/CoreLocation.h>
@class MVYSideMenuController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

-(void)getCurrentLocation:(UIViewController *)controller withCallback:(SEL)callBack;

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic)  MVYSideMenuController *sideMenuController;
@property (strong, nonatomic) id observer;

@property (nonatomic, retain) NSString * appUserCity;
@property (nonatomic, retain) NSString * appUserState;
@property (nonatomic, strong) AVAudioPlayer *musicPlayer1;

@property (nonatomic, retain) UINavigationController * navigationController;
@property (strong,nonatomic)  CH_HomeVC *ceterViewController;


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocationPoint;
@property (nonatomic, retain) NSString * currentCity;
@end

