//
//  CameraViewController.m
//  Nine00SecondsSDKExample
//
//  Created by Mikhail Grushin on 24.12.14.
//  Copyright (c) 2014 DENIVIP Group. All rights reserved.
//

#import "DVGCameraViewController.h"
#import "Nine00SecondsSDK.h"
#import "MBProgressHUD.h"
#import "ECSServiceClass.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "ECSBaseViewController.h"
@interface DVGCameraViewController () <NHSBroadcastManagerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *recButton;
@property (strong, nonatomic) IBOutlet UILabel *sentLabel;
@property (strong, nonatomic) IBOutlet UILabel *uploadClock;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewLive;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewGoLive;

@property (nonatomic, strong) NHSBroadcastManager *broadcastManager;
@property (nonatomic, strong) UIView *previewView;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (nonatomic, strong) NHSStream *stream;
@property (nonatomic, strong) NSTimer *uploadTimer;
@property (nonatomic, retain) NSString * contactId;
@property (nonatomic, retain) NSString * groupId;
@end



@implementation DVGCameraViewController
-(id)initWithContactId:(NSString *)userId withgroupId:(NSString *)groupId
{
    
    self = [self initWithNibName:@"DVGCameraViewController" bundle:nil];
    self.contactId = userId;
    self.groupId=groupId;
    
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Camera";
  
    
    self.broadcastManager = [NHSBroadcastManager sharedManager];
    self.broadcastManager.qualityPreset = NHSStreamingQualityPreset640HighBitrate;
    self.broadcastManager.delegate = self;
    self.previewView = [self.broadcastManager createPreviewViewWithRect:self.view.bounds];
    [self.view insertSubview:self.previewView belowSubview:self.recButton];
    
    self.imgViewGoLive.hidden=NO;
    self.imgViewLive.hidden=YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFocus:)];
    [self.previewView addGestureRecognizer:recognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.broadcastManager startPreview];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.previewView.frame = self.view.bounds;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.broadcastManager stopPreview:NO];
    self.broadcastManager.delegate = nil;
    
    [self.uploadTimer invalidate];
    self.uploadTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.broadcastManager stopPreview:YES];
    [self.uploadTimer invalidate];
    self.uploadTimer = nil;
}

#pragma mark - Broadcasting actions
- (IBAction)toggleFilter:(id)sender {
    static int scotcher = 0;
    NSArray* validFilters = @[
                          @[@"No filter",@(NHSStreamingFilterNoFilter), [NSNull null]],
                          @[@"Sepia",@(NHSStreamingFilterSepia), [NSNull null]],
                          @[@"Black`n`White",@(NHSStreamingFilterSaturation), [NSNull null]],
//                          @[@"Colorized",@(NHSStreamingFilterColorLookup), @{@"image":[UIImage imageNamed:@"lookup_amatorka.png"]}],
                          @[@"Blur",@(NHSStreamingFilterBlur), @{@"blurRadiusAsFractionOfImageWidth":@(0.02)}],
                          @[@"Vignette",@(NHSStreamingFilterVignette), @{@"vignetteStart":@(0.3), @"vignetteEnd":@(0.75)}],
                          @[@"Pixellate",@(NHSStreamingFilterPixellate), @{@"fractionalWidthOfAPixel":@(0.02)}]
                          ];
    scotcher = (scotcher+1)%[validFilters count];
    NHSStreamingFilter filter = [[[validFilters objectAtIndex:scotcher] objectAtIndex:1] intValue];
    NSDictionary* params = [[validFilters objectAtIndex:scotcher] objectAtIndex:2];
    [self.filterButton setTitle:[[validFilters objectAtIndex:scotcher] objectAtIndex:0] forState:UIControlStateNormal];
    [self.broadcastManager setupCameraFilter:filter withParams:(id)params == [NSNull null]?nil:params];
}

- (void)startBroadcast {
    self.sentLabel.text = @"KB sent : 0";
    self.uploadClock.text = @"Starting...";
  
    
   
    [[NHSBroadcastManager sharedManager] startBroadcasting];
     self.imgViewLive.hidden=NO;
    self.imgViewGoLive.hidden=YES;
}

- (void)stopBroadcast {
    
    [[NHSBroadcastManager sharedManager] stopBroadcasting];
    self.imgViewLive.hidden=YES;
    self.imgViewGoLive.hidden=NO;
}

#pragma mark - Private interface

- (BOOL)isLandscape
{
    // При форсированном переключении ориентации size class не совпадает с interfaceOrientation.
    
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
    if ([self respondsToSelector:@selector(traitCollection)]) { // iOS 8
        isLandscape = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    }
    
    return isLandscape;
}

- (UIInterfaceOrientation)cameraInterfaceOrientation
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation;
    if (UIDeviceOrientationIsValidInterfaceOrientation(deviceOrientation)) {
        switch (deviceOrientation) {
            case UIDeviceOrientationLandscapeRight:
                interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
                break;
                
            case UIDeviceOrientationLandscapeLeft:
                interfaceOrientation = UIInterfaceOrientationLandscapeRight;
                break;
                
            default:
                interfaceOrientation = (UIInterfaceOrientation)deviceOrientation;
                break;
        }
    }
    else {
        interfaceOrientation = ([self isLandscape] && !UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? UIInterfaceOrientationLandscapeRight : self.interfaceOrientation);
    }
    
    return interfaceOrientation;
}

#pragma mark - Actions

- (IBAction)tapRec:(id)sender {
    if (self.recButton.isSelected) {
        [self stopBroadcast];
    } else {
        [self startBroadcast];
    }
}

- (void)uploadTimerAction {
    if (self.uploadClock.alpha) {
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:self.stream.createdAt];
        if(time > 0){
            int seconds = ((int)time)%60;
            int minutes = time/60;
            //int milliseconds = (int)((time - minutes - seconds)*100);
            
            self.uploadClock.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        }
    }
    
    self.sentLabel.text = [NSString stringWithFormat:@"KB sent : %.0f", self.broadcastManager.currentStreamBytesSent/1000.f];
}

- (void)tapToFocus:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint tapPoint = [recognizer locationInView:self.previewView];
        [[NHSBroadcastManager sharedManager] showFocusAreaAt:tapPoint withPreview:self.previewView];
    }
}

#pragma mark - Broadcast delegate

- (void)broadcastManager:(NHSBroadcastManager *)manager didStartBroadcastWithStream:(NHSStream *)stream {
    if (stream) {
        NSLog(@"Started streaming: Stream %@", stream.streamID);
        [self serviceGetStreaming:stream.streamID];
        self.recButton.selected = YES;
        self.stream = stream;

        self.uploadTimer = [NSTimer timerWithTimeInterval:.1f target:self selector:@selector(uploadTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.uploadTimer forMode:NSDefaultRunLoopMode];
        
        [UIView animateWithDuration:.25f animations:^{
            self.sentLabel.alpha = 1.f;
            self.uploadClock.alpha = 1.f;
        }];
    }
    
}

- (void)broadcastManager:(NHSBroadcastManager *)manager didCreatePreviewImageForStreamWithID:(NSString *)streamID image:(UIImage *)previewImage {
    NSLog(@"Stream %@ created preview image %.0fx%.0f", streamID, previewImage.size.width, previewImage.size.height);
}

- (void)broadcastManager:(NHSBroadcastManager *)manager didUpdateLocationForStreamWithID:(NSString *)streamID withCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"Stream %@ updated it's location to %f,%f", streamID, coordinate.latitude, coordinate.longitude);
}

- (void)broadcastManagerDidFailToCreateStream:(NHSBroadcastManager *)manager withError:(NSError *)error {
    NSLog(@"Failed to create stream : %@", error);
}

- (void)broadcastManagerDidFailToStartRecording:(NHSBroadcastManager *)manager {
    NSLog(@"Failed to start recording");
}

- (void)broadcastManagerDidStopRecording:(NHSBroadcastManager *)manager {
    NSLog(@"Stopped recording");
    self.recButton.selected = NO;
    
    [UIView animateWithDuration:.25f animations:^{
        self.uploadClock.alpha = 0.f;
    }];
}



- (void)broadcastManager:(NHSBroadcastManager *)manager didStopBroadcastOfStream:(NHSStream *)stream {
    NSLog(@"Stopped broadcasting");
    
    [self.uploadTimer invalidate];
    [UIView animateWithDuration:.25f animations:^{
        self.sentLabel.alpha = 0.f;
    }];
}

- (UIInterfaceOrientation)broadcastManagerCameraInterfaceOrientation:(NHSBroadcastManager *)manager {
    return [self cameraInterfaceOrientation];
}
-(IBAction)onClickBack:(id)sender{
    [self stopBroadcast];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)startServiceToStreaming
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelectorInBackground:@selector(serviceGetStreaming) withObject:nil];
    
}
-(void)serviceGetStreaming :(NSString *)streamId
{
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/send-live-stream",SERVERURLPATH]];
    
    if (self.contactId) {
    
        [class addParam:self.contactId forKey:@"contact_id"];
 
    }else{
        [class addParam:self.groupId forKey:@"group_id"];
    }
     [class addParam:streamId forKey:@"stream_url"];
    [class setCallback:@selector(callBackServiceToStreaming:)];
    [class setController:self];
    [class runService];
}


-(void)callBackServiceToStreaming:(ECSResponse *)response
{
    
    
    NSDictionary * rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    NSLog(@"rootDictionary %@",rootDictionary);
  //  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(response.isValid)
    {
        
        if ([[rootDictionary objectForKey:@"errors"] isEqualToString:@"Stream url send to all linked user."]) {
            
            [ECSAlert showAlert:@"Your video is now streaming live!\n\nA link has also been emailed to your chosen viewers. "];
        }
        else if ([rootDictionary objectForKey:@"statusDescription"]){
            // [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];
          //  [ECSToast showToast:[rootDictionary objectForKey:@"statusDescription"] view:self.view];
            [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];
            //            [[[[iToast makeText:[rootDictionary objectForKey:@"statusDescription"]]
            //               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }else{
            //[ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
          //  [ECSToast showToast:[rootDictionary objectForKey:@"message"] view:self.view];
             [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
            //            [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
            //               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
        
        
    }
    if(!rootDictionary){
        [ECSAlert showAlert:response.stringValue];
        // [ECSToast showToast:response.stringValue view:self.view];
    }
}




@end
