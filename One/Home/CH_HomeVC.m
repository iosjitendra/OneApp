//
//  CH_HomeVC.m
//  CountryHillElementary
//
//  Created by Daksha Mac 3 on 21/07/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "CH_HomeVC.h"
//#import "CH_HomeTableCell.h"
#import "MVYSideMenuController.h"
#import "DS_SideMenuVC.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ECSServiceClass.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "BC_WebPageVC.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "CH_ChatScreen.h"
#import "ECSAppHelper.h"
#import "UIView+Toast.h"
#import "AppUserObject.h"
#import "AllMessage.h"
#import "CH_SoonVC.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
//#import "CH_DemoVC.h"

//#import "CH_ConnectVc.h"
#import "ECSHelper.h"
#import "DS_LaunchScreen.h"

@interface CH_HomeVC ()
{
    
    BOOL ischecked;
    CGSize myStringSize;
    AVAudioPlayer *audioPlayer;
}


@property (strong, nonatomic) IBOutlet UIView *viewHelp;


@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (strong, nonatomic) IBOutlet UIView *viewMore;
@property (strong, nonatomic) IBOutlet UIView *viewChat;
@property (strong, nonatomic) IBOutlet UIView *viewItunes;

@property (strong, nonatomic) IBOutlet UIView *viewHighleted;

@property(strong,nonatomic)IBOutlet UIImageView *overlayUp;
@property(strong,nonatomic)IBOutlet UIImageView *overlayMid;
@property(strong,nonatomic)IBOutlet UIImageView *overlayDown;
@property(strong,nonatomic)IBOutlet UIImageView *imgTutOne;

@property (strong, nonatomic) IBOutlet UIView *viewHighletedSecond;
@property (strong, nonatomic) IBOutlet UIView *viewHighletedThird;
@property (strong, nonatomic) IBOutlet UIView *viewHighletedFour;
@property (strong, nonatomic) IBOutlet UIView *viewHighletedFifth;

@property (strong, nonatomic) IBOutlet UIView *viewOverlayUp;
@property (strong, nonatomic) IBOutlet UIView *viewOverlayDown;

@property (strong, nonatomic) IBOutlet UILabel *lblhilightedMsg;
@property (strong, nonatomic) IBOutlet UIButton *btnGotit;
@property (strong, nonatomic) IBOutlet UILabel *lblGotit;

@property(strong,nonatomic)IBOutlet UIButton *button;
@property(strong,nonatomic)IBOutlet UIButton *clickMore;
@property(strong,nonatomic)IBOutlet UITableView *tblHome;
@property (nonatomic, retain) NSDictionary * currentObservation;
@property (weak, nonatomic) IBOutlet UILabel *lblTemprature;

@property (weak, nonatomic) IBOutlet UILabel *lblTemp;

@property (weak, nonatomic) IBOutlet UILabel *lblWeather;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherAlertText;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet UILabel *lblalert;
@property (weak, nonatomic) IBOutlet UILabel *lblalertFull;
@property (nonatomic, retain) AllMessage * messText;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContact;
@property (strong, nonatomic) IBOutlet UIView *viewTuteBuckwormApp;

- (IBAction)clickToOpenBuckwormApp:(id)sender;


@end

@implementation CH_HomeVC

- (void)viewDidLoad {
    
    //v3
    [super viewDidLoad];
    
    if(self.appUserObject==nil){
       UIViewController *loginView = [[DS_LaunchScreen alloc]initWithNibName:@"DS_LaunchScreen" bundle:nil];
        
       // _amazonIntro.delegate = self;
        [self.navigationController pushViewController:loginView animated:NO];
       // [self.view addSubview:loginView.view];

    }
  //Coral Springs Youth Soccer
    NSString *homeMsg=@"Tap here for the app menu! Easily access important links and SAVE MONEY at restaurants, department stores and local businesses with your app's very cool discounts technology!";
    self.lblhilightedMsg.text=homeMsg;
    
    self.viewHighleted.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"DontShowForHome"];
    if ([myString isEqualToString:@"DontShowAgain"]) {
        NSLog(@"dont show the tutorial");
        // [self.view addSubview:self.viewHighleted];
    }else{
        
        [self.view addSubview:self.viewHighleted];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodHome:)];
     UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodHome:)];
     UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodHome:)];
     UITapGestureRecognizer *tapRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodHome:)];
     UITapGestureRecognizer *tapRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodHome:)];
     UITapGestureRecognizer *tapRecognizer5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodHome:)];
     UITapGestureRecognizer *tapRecognizer6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodHome:)];
     UITapGestureRecognizer *tapRecognizer7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethodHome:)];
    [self.viewHighleted addGestureRecognizer:tapRecognizer];
    [self.viewHighletedSecond addGestureRecognizer:tapRecognizer1];
    [self.viewHighletedThird addGestureRecognizer:tapRecognizer2];
    [self.viewHighletedFour addGestureRecognizer:tapRecognizer3];
    [self.viewTuteBuckwormApp addGestureRecognizer:tapRecognizer7];
    [self.viewHighletedFifth addGestureRecognizer:tapRecognizer4];
    [self.viewOverlayDown addGestureRecognizer:tapRecognizer5];
   // [self.viewOverlayUp addGestureRecognizer:tapRecognizer6];
   
        [self settingTopView:self.viewTop onController:self andTitle:@"One" andImg:@"More.png"];
    
   
    self.tblHome.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tblHome.separatorColor = [UIColor clearColor];
    self.lblWeather.hidden=YES;
    self.lblTemprature.hidden=YES;
    self.lblTemp.hidden=YES;
    self.clickMore.hidden=NO;
    self.viewMore.hidden=YES;
    self.clickMore.hidden=YES;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onApplyAction) name:@"ON_ADD_A_F" object:nil];
    
    
    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    [delegate getCurrentLocation:(UIViewController *)self withCallback:@selector(startServiceToGetWeather)];
    
    UIExtensions *extenions = [UIExtensions sharedInstance];
    extenions.parentController = self;
    
    if (self.appUserObject.userId) {
       // [self startServiceToGetMessage];
    }else{
        //self.lblalert.frame=CGRectMake(10, 10, 208, 86);
        self.lblalert.text=[NSString stringWithFormat:@"%@",@"No alert!"];
        self.lblalert.textAlignment = NSTextAlignmentCenter;
    }
     //[[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



-(IBAction)checkboxButton:(id)sender
{
    
    UIButton *check = (UIButton*)sender;
    if(ischecked == NO){
        ischecked=YES;//dontshowagainchecked
        [check setImage:[UIImage imageNamed:@"dontshowagainchecked.png"] forState:UIControlStateNormal];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"DontShowAgain" forKey:@"DontShowForHome"];
        
    }
    else{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"ShowAgain" forKey:@"DontShowForHome"];
        ischecked=NO;
        [check setImage:[UIImage imageNamed:@"dontshowagain.png"] forState:UIControlStateNormal];
    }
}

-(void)gestureHandlerMethodHome:(UITapGestureRecognizer*)sender {
    
    self.viewHighleted.hidden=YES;
     self.viewHighletedSecond.hidden=YES;
     self.viewHighletedThird.hidden=YES;
     self.viewHighletedFour.hidden=YES;
     self.viewHighletedFifth.hidden=YES;
   //  self.viewOverlayUp.hidden=YES;
     self.viewOverlayDown.hidden=YES;
     self.viewTuteBuckwormApp.hidden=YES;
    
   
}

-(IBAction)clickGotIt:(id)sender{
     self.viewHighleted.hidden=YES;

    //self.viewOverlayUp.frame=CGRectMake(0, 0, self.view.frame.size.width, 75);
    self.viewHighletedSecond.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self viewTransitionRight:self.viewHighleted to:self.viewHighletedSecond];
  //  [self.view addSubview:self.viewOverlayUp];
    [self.view addSubview:self.viewHighletedSecond];
    
    

}
-(void)viewTransitionRight :(UIView *)baseView to:(UIView *) newView{
    [UIView transitionFromView:baseView
                        toView:newView
                      duration:2
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished){
                        [self.viewHighleted removeFromSuperview];
                    }];

}
-(void)viewTransitionLeft :(UIView *)baseView to:(UIView *) newView{
    [UIView transitionFromView:baseView
                        toView:newView
                      duration:2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished){
                        [self.viewHighleted removeFromSuperview];
                    }];
    
}
-(void)viewTransitionTop :(UIView *)baseView to:(UIView *) newView{
    [UIView transitionFromView:baseView
                        toView:newView
                      duration:2
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    completion:^(BOOL finished){
                        [self.viewHighleted removeFromSuperview];
                    }];
    
}

-(void)viewTransitionBottom :(UIView *)baseView to:(UIView *) newView{
    [UIView transitionFromView:baseView
                        toView:newView
                      duration:2
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    completion:^(BOOL finished){
                        [self.viewHighleted removeFromSuperview];
                    }];
    
}
//-(IBAction)flipFromBottom:(id)sender{
//    [self doTransitionWithType:UIViewAnimationOptionTransitionFlipFromBottom];
//    
//}

-(IBAction)clickGotItSecond:(id)sender{
     self.viewHighletedSecond.hidden=YES;
    //self.viewOverlayUp.frame=CGRectMake(0, 0, self.view.frame.size.width, 170);
    self.viewHighletedThird.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
   [self viewTransitionLeft:self.viewHighletedSecond to:self.viewHighletedThird];
   // [self.view addSubview:self.viewOverlayUp];
    [self.view addSubview:self.viewHighletedThird];

   
   }

-(IBAction)clickGotItThird:(id)sender{
    self.viewHighletedThird.hidden=YES;
    self.viewHighletedFour.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  //  self.viewOverlayUp.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     [self viewTransitionTop: self.viewHighletedThird to:self.viewHighletedFour];
   // [self.view addSubview:self.viewOverlayUp];
    [self.view addSubview:self.viewHighletedFour];
    

    
}
-(IBAction)clickGotItFour:(id)sender{
    
    
    self.viewOverlayUp.hidden=YES;
    self.viewHighletedFour.hidden=YES;
    self.viewTuteBuckwormApp.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSLog(@"screenSize %f",screenSize.height);
//    if (screenSize.height==736) {
//          self.viewHighletedFifth.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-185);
//    }
    //[self scrollToBottom];
    [self viewTransitionBottom: self.viewHighletedFour to:self.viewTuteBuckwormApp];
    [self.view addSubview:self.viewTuteBuckwormApp];

}
-(IBAction)clickGotItfifth:(id)sender{
    self.viewHighletedFifth.hidden=YES;
   
    //  self.viewHighletedSecond.hidden=YES;
    
}
- (void)scrollToBottom1
{
    [self.scroll_addContact setContentOffset:CGPointMake(0, 95)];

}

- (void)scrollToBottom
{
    
    
    CGPoint bottomOffset = CGPointMake(0, self.scroll_addContact.contentSize.height - self.scroll_addContact.bounds.size.height);
    [self.scroll_addContact setContentOffset:bottomOffset animated:NO];
    
}

//-(IBAction)clickDismiss:(id)sender{
//    
//    
//}
-(void)onApplyAction{
   
    self.appUserObject = [AppUserObject getFromUserDefault];
   
    if (self.appUserObject.userId) {
        [self startServiceToGetMessage];
    }else{
      //  self.lblalert.frame=CGRectMake(5, 10, 208, 86);
        self.lblalert.text=[NSString stringWithFormat:@"%@",@"No alert"];
         self.lblalert.textAlignment = NSTextAlignmentCenter;
         self.clickMore.hidden=YES;
    }
    


    
}

-(IBAction)clickMore:(id)sender{
    
    self.viewMore.frame=CGRectMake(5, 90, self.view.frame.size.width-10, myStringSize.height+50);
    self.viewMore.hidden=NO;
    [self.scroll_addContact addSubview:self.viewMore];
    NSLog(@"myStringSize %f",myStringSize.height);
    if (myStringSize.height>86) {
        self.viewChat.frame=CGRectMake(5, 146+myStringSize.height, self.view.frame.size.width-10, 346);
        self.viewMore.hidden=NO;
        [self.scroll_addContact addSubview:self.self.viewChat];
    }
    [self.scroll_addContact setContentSize:CGSizeMake(self.scroll_addContact.frame.size.width, 720+myStringSize.height)];
}
-(IBAction)clickCancel:(id)sender{
    self.viewMore.hidden=YES;
     self.viewChat.frame=CGRectMake(5, 206, self.view.frame.size.width-10, 346);
    [self.scroll_addContact setContentSize:CGSizeMake(self.scroll_addContact.frame.size.width-10, 720)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startServiceToGetWeather
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelectorInBackground:@selector(serviceToGetWeather) withObject:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
 
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.appUserObject.userId) {
        [self startServiceToGetMessage];
    }else{
        self.lblalert.text=@"No alert!";
    }

    
}
-(void)viewDidAppear:(BOOL)animated
{
//    if (self.appUserObject.userId) {
//        [self startServiceToGetMessage];
//    }else{
//        self.lblalert.text=@"Login to view alerts!";
//    }

    [self.scroll_addContact setContentSize:CGSizeMake(self.scroll_addContact.frame.size.width, 750)];
}



-(void)serviceToGetWeather
{
    //http://api.wunderground.com/api/2a552f770f025f99/conditions/q/CA/Chicago.json
    //http://api.wunderground.com/api/Your_Key/conditions/q/CA/San_Francisco.json
    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
   [class setServiceURL:[NSString stringWithFormat:@"http://api.wunderground.com/api/2a552f770f025f99/conditions/q/%@/%@.json",delegate.appUserState, delegate.appUserCity]];
//     [class setServiceURL:[NSString stringWithFormat:@"http://api.wunderground.com/api/2a552f770f025f99/conditions/q/CA/San_Francisco.json"]];
    [class setController:self];
    
    [class setCallback:@selector(callBackServiceToGetWeather:)];
    [class runService];
    
    
}


-(void)callBackServiceToGetWeather:(ECSResponse *)response

{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary * rootDictionary = [NSJSONSerialization JSONObjectWithData: response.data options:0 error: nil];
    NSDictionary * errorDict = [[rootDictionary objectForKey:@"response"]objectForKey:@"error"];
    
    if([[errorDict objectForKey:@"description"] isEqualToString:@"No cities match your search query"])
    {
        
       // [ECSAlert showAlert:[errorDict objectForKey:@"description"]];
       // self.lblWeatherAlertText.text=@"Weather details are not available for this location. Please try again later.";
        
        NSString *message = @"Weather details are not available for this location. Please try again later.";
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:message];
        NSRange  subStringRange = [message rangeOfString:@"try again"];
        
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:subStringRange];
        [string addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:subStringRange];
        [self.lblWeatherAlertText setAttributedText:string];
        self.lblWeatherAlertText.userInteractionEnabled = YES;
        [self.lblWeatherAlertText addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMore1:)]];
        

    }
    else
    {
        
        self.currentObservation = [rootDictionary objectForKey:@"current_observation"];
        if(self.currentObservation)
        {
            self.lblWeatherAlertText.hidden=YES;
            self.lblWeather.hidden=NO;
            self.lblTemprature.hidden=NO;
            self.lblTemp.hidden=NO;
            NSString* myNewString=[NSString stringWithFormat:@"%ld",[[self.currentObservation objectForKey:@"temp_f"]integerValue]];
            [self.lblTemprature setText:[NSString stringWithFormat:@"%@\u00b0",myNewString]];
            self.lblTemprature.text = [self.lblTemprature.text stringByAppendingString:@"F"];
            
            
            [self.lblWeather setText:[self.currentObservation objectForKey:@"weather"]];
            [self.lblCityName setText:[[self.currentObservation objectForKey:@"display_location"]objectForKey:@"city"]];
            NSMutableAttributedString *BtnString = [[NSMutableAttributedString alloc] initWithString:[[self.currentObservation objectForKey:@"display_location"]objectForKey:@"city"]];
//
            [BtnString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [BtnString length])];
            
            [self.lblCityName setAttributedText:BtnString];
            [self.weatherImage ecs_setImageWithURL:[NSURL URLWithString:[self.currentObservation objectForKey:@"icon_url"]] placeholderImage:nil];

        }
        else
        {
            //[ECSAlert showAlert:@"Sorry, but we are not able to show the current observations for your city"];
        
        }
        
        
        
    }
    
    
}


-(IBAction)onClickMore1:(id)sender{
    [self startServiceToGetWeather];
}


-(void)startServiceToGetMessage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetMessage) withObject:nil];
    
    
}

-(void)serviceToGetMessage
{
    
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    
    // http://www.buckworm.com/laravel/index.php/api/v1/getInAppMessage/{userId}

    [class setServiceURL:[NSString stringWithFormat:@"%@v1/getInAppMessage/%@",SERVERURLPATH,self.appUserObject.accessId]];
   
    NSLog(@"self.appUserObject.userId %@",self.appUserObject.accessId);
    [class addParam:@"ios" forKey:@"device_type"];
   
    [class setCallback:@selector(callBackServiceToGetMessage:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetMessage:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {

        NSArray * notification=[rootDictionary objectForKey:@"AllMessage"];
        int i=0;
            for (NSDictionary * dictionary in notification)
            {
                if( i<1) {
                AllMessage  *object=[AllMessage instanceFromDictionary:dictionary];
               
                    self.lblalert.text=object.messageText;
                    NSLog(@"text %@",object.messageText);
                    self.lblalertFull.text=object.messageText;
                   
                    self.lblalert.textAlignment = NSTextAlignmentLeft;
                   self.lblalertFull.textAlignment = NSTextAlignmentLeft;
                    self.lblalertFull.lineBreakMode = NSLineBreakByWordWrapping;
                    self.lblalertFull.numberOfLines = 0;
                    CGSize maximumSize = CGSizeMake(300, 9999);
                   i++;
                    UIFont *myFont = [UIFont fontWithName:@"Karla-Regular" size:15];
                    myStringSize = [self.lblalert.text sizeWithFont:myFont
                                               constrainedToSize:maximumSize
                                                   lineBreakMode:self.lblalert.lineBreakMode];
                    
                    NSLog(@"myStringSize %f",myStringSize.height);
//                    if (myStringSize.height>185) {
//                self.viewChat.frame=CGRectMake(5, 206+myStringSize.height, self.view.frame.size.width, 260);
//                    }
                    
                    
                    self.lblalertFull.adjustsFontSizeToFitWidth = NO;
                    [self.lblalertFull sizeToFit];
                    if (self.lblalert.text.length>=140) {
                        self.clickMore.hidden=NO;
                    }
                    if ([self.lblalert.text isEqualToString:@"No alerts!"]) {
                        self.lblalert.textAlignment = NSTextAlignmentCenter;
                    }
                   
            }
            }
        }
   
    
           //        for (NSDictionary * dictionary in notification)
//        {
//            AllMessage  *object=[AllMessage instanceFromDictionary:dictionary];
//           self.lblalert.text=object.messageText;
//        }
      
       
    else {
        
       // [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        
    }
    if ( [self.lblalert.text isEqualToString:@""]){
        self.lblalert.text=@"No alerts!";
         self.lblalert.textAlignment = NSTextAlignmentCenter;
    }
}



- (IBAction)clickToCityWeather:(id)sender {
    
    
    NSString *url =[NSString stringWithFormat:@"%@",[self.currentObservation objectForKey:@"ob_url"]];
    BC_WebPageVC *contentScreen = [[BC_WebPageVC alloc]initWithURL:url andTitle:@"Weather"];
    [self.navigationController pushViewController:contentScreen animated:YES];
}

- (IBAction)clickToChatTunes:(id)sender {
    CH_SoonVC *contentScreen = [[CH_SoonVC alloc]initWithNibName:@"CH_SoonVC" bundle:nil];
    [self.navigationController pushViewController:contentScreen animated:YES];
    
   }




-(void)openSideMenuButtonClicked:(UIButton *)sender{
    
    [self clickToOpenMenu:sender];
    
}

- (IBAction)clickToOpenMenu:(id)sender {
    
    
    MVYSideMenuController *sideMenuController = [self sideMenuController];
    //    DS_SideMenuVC * vc = (DS_SideMenuVC *)sideMenuController.menuViewController;
    //  //  [vc ReloadTable:nameArrayList];
    
    if (sideMenuController) {
        [sideMenuController openMenu];
    }
    [sideMenuController openMenu];
    
  
}

- (IBAction)clickToOpenSideMenu:(id)sender {
    
    
    MVYSideMenuController *sideMenuController = [self sideMenuController];
    //    DS_SideMenuVC * vc = (DS_SideMenuVC *)sideMenuController.menuViewController;
    //  //  [vc ReloadTable:nameArrayList];
    
    if (sideMenuController) {
        [sideMenuController openMenu];
    }
    [sideMenuController openMenu];
    
    
}

-(IBAction)onClickChatButton:(id)sender{
    
   
    CH_ChatScreen *contentScreen = [[CH_ChatScreen alloc]initWithNibName:@"CH_ChatScreen" bundle:nil];
    [self.navigationController pushViewController:contentScreen animated:YES];
   
    
}

- (IBAction)clickToOpenBuckwormApp:(id)sender {
    
    [ECSAppHelper openBuckwormApp:self];
}
- (IBAction)clickToGotItBuckwormTute:(id)sender {
    
    self.viewOverlayUp.hidden=YES;
    self.viewTuteBuckwormApp.hidden=YES;
    self.viewHighletedFifth.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSLog(@"screenSize %f",screenSize.height);
    if (screenSize.height==736) {
        self.viewHighletedFifth.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-185);
    }
    if (screenSize.height<=568){
        [self scrollToBottom1];
    }
    [self viewTransitionBottom: self.viewTuteBuckwormApp to:self.viewHighletedFifth];
    [self.view addSubview:self.viewHighletedFifth];
    
    
    
    
}


- (IBAction)clickToShowBuckwormHelp:(id)sender {
     [self.viewHelp setHidden:NO];
    [self.viewHelp setFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
    [self.view addSubview:self.viewHelp];
   
}


- (IBAction)clickToCancelBukwormHelp:(id)sender {
    
     [self.viewHelp setHidden:YES];
}



@end
