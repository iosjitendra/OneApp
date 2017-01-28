//
//  DVGFeatureListTableViewController.m
//  CountryHillElementary
//
//  Created by Daksha on 11/24/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "DVGFeatureListTableViewController.h"
#import "DVGStreamsMapViewController.h"
#import "DVGCameraViewController.h"
#import "DVGStreamSelectionViewController.h"
@import CoreLocation;

@interface DVGFeatureListTableViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;

@end

@implementation DVGFeatureListTableViewController

- (void)loadView {
    //[super loadView];
    
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mapSegue"]) {
        DVGStreamsMapViewController *mapVC = (DVGStreamsMapViewController *)segue.destinationViewController;
        mapVC.initialCoordinates = self.userLocation;
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(IBAction)onClickBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickBroadcastCamera:(id)sender{
    DVGCameraViewController *contentScreen = [[DVGCameraViewController alloc]initWithNibName:@"DVGCameraViewController" bundle:nil];
    [self.navigationController pushViewController:contentScreen animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickBroadcastList:(id)sender{
    
    // [self.navigationController popViewControllerAnimated:YES];//DVGStreamSelectionViewController
    
    DVGStreamSelectionViewController *contentScreen = [[DVGStreamSelectionViewController alloc]initWithNibName:@"DVGStreamSelectionViewController" bundle:nil];
    [self.navigationController pushViewController:contentScreen animated:YES];
    
}

@end
