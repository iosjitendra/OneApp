//
//  ListActivityVC.m
//  CountryHillElementary
//
//  Created by Daksha on 11/24/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "ListActivityVC.h"
#import "DVGStreamsMapViewController.h"
#import "DVGCameraViewController.h"
#import "DVGStreamSelectionViewController.h"
@import CoreLocation;
@interface ListActivityVC ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;
@property (nonatomic, retain) NSString * contactId;
@property (nonatomic, retain) NSString * groupId;
@end

@implementation ListActivityVC
-(id)initWithContactId:(NSString *)userId withgroupId:(NSString *)groupId
{
    
    self = [self initWithNibName:@"ListActivityVC" bundle:nil];
    self.contactId = userId;
    self.groupId=groupId;
    
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
        if ([CLLocationManager locationServicesEnabled]) {
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined &&
                [CLLocationManager instancesRespondToSelector:@selector(requestWhenInUseAuthorization)]) {
                self.locationManager = [[CLLocationManager alloc] init];
                self.locationManager.delegate = self;
                [self.locationManager requestWhenInUseAuthorization];
            } else {
                self.locationManager = [[CLLocationManager alloc] init];
                self.locationManager.delegate = self;
                [self.locationManager startUpdatingLocation];
            }
        }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onClickBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickBroadcastCamera:(id)sender{
    DVGCameraViewController *contentScreen = [[DVGCameraViewController alloc]initWithContactId:self.contactId withgroupId:self.groupId];
    [self.navigationController pushViewController:contentScreen animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickBroadcastList:(id)sender{
    
    // [self.navigationController popViewControllerAnimated:YES];//DVGStreamSelectionViewController
    
    DVGStreamSelectionViewController *contentScreen = [[DVGStreamSelectionViewController alloc]initWithNibName:@"DVGStreamSelectionViewController" bundle:nil];
    [self.navigationController pushViewController:contentScreen animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
