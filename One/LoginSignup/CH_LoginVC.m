//
//  CH_LoginVC.m
//  CountryHillElementary
//
//  Created by Daksha Mac 3 on 26/07/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//

#import "CH_LoginVC.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "JJMaterialTextField.h"
#import "UIExtensions.h"
#import "UIAppExtensions.h"
#import "CH_SignupVC.h"
#import "ECSServiceClass.h"
#import "MBProgressHUD.h"
#import "AppUserObject.h"
#import "DS_SideMenuVC.h"
#import "CH_HomeVC.h"
#import "ECSHelper.h"
//#import "iToast.h"
#import "BC_ForgotPassword.h"
#import "ECSMessage.h"
#import "BC_WebPageVC.h"
#import "BC_InvitationScreen.h"
#import "ECSConfig.h"
#import "ALChatManager.h"
#import "ECSAppHelper.h"
#import <Applozic/ALDataNetworkConnection.h>
#import <Applozic/ALDBHandler.h>
#import <Applozic/ALContact.h>
#import "ALChannel.h"
#import "Applozic/ALChannelService.h"
#import "ALNewContactsViewController.h"
#import "ALMessagesViewController.h"
#import "MVYSideMenuOptions.h"
#import "MVYSideMenuController.h"
@interface CH_LoginVC ()
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContact;
@property(strong, nonatomic)  MVYSideMenuController *sideMenuController;
//@property (nonatomic, retain) UINavigationController * navigationController;
@property(strong,nonatomic)IBOutlet UILabel *lblName;
@property(strong,nonatomic)IBOutlet UIButton *btnGetStarted;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtUserName;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtPass;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtEmail;
@property(weak ,nonatomic)IBOutlet UIView *viewLogo;
@property(weak ,nonatomic)IBOutlet UIImageView *imgViewLogo;
@end

@implementation CH_LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.btnGetStarted.layer.cornerRadius = 0;
   
    self.btnGetStarted.clipsToBounds = YES;
    self.btnGetStarted.layer.borderWidth=0.0f;
    UIColor *color = [UIColor colorWithRed:184/255.0 green:166/255.0 blue:228/255.0 alpha:1];
    self.txtPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    
     self.txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: color}];
    UIFont *font1 = [UIFont fontWithName:@"Karla-Regular" size:16];
    self.txtPass.font=font1;
    self.txtUserName.font=font1;
    [self textFieldInitialization];

   
    self.lblName.text=@"One";
    [self.lblName setFontKalra:22];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidEndEditing:(JJMaterialTextfield *)textField{
    if (textField.text.length==0) {
        [textField showError];
    }else{
        [textField hideError];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view)
        [textField resignFirstResponder];
    else
        [view becomeFirstResponder];
    return YES;
    
}


-(void)setTextFieldImages{
    
    UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 19)];
    [userImage setImage:[UIImage imageNamed:@"drop-down-icon.png"]];
    
    
    
    
}


-(IBAction)onClickResendConfirmation:(id)sender{
    NSString *url=@"https://www.buckworm.com/resend-signup-confirmation.php";
   BC_WebPageVC  *contentScreen = [[BC_WebPageVC alloc]initWithURL:url andTitle:@"Resend Instructions"];
    //Resend confirmation//Didn't receive confermations instructions ?
   // [self.navigationController pushViewController:contentScreen animated:YES];
    [self presentViewController:contentScreen animated:YES completion:nil];
}


-(void)setTextFieldsPadding
{
    [self.txtUserName setRightPadding];
    
    [self.txtPass setRightPadding];
   
}

-(void)resignTextResponder
{
    
  
    [self.txtUserName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    
    [self.txtPass resignFirstResponder];
  
   
    
}

-(void)textFieldInitialization
{
    self.txtUserName.enableMaterialPlaceHolderForMoreDisplace = YES;
    self.txtUserName.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
   // self.txtUserName.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
     self.txtUserName.lineColor=[UIColor colorWithRed:184/255.0 green:166/255.0 blue:228/255.0 alpha:1];
    self.txtUserName.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
   // self.userName.lineColor=[UIColor purpleColor];
    
      _txtPass.enableMaterialPlaceHolderForMoreDisplace = YES;
    _txtPass.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    //_txtPass.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtPass.lineColor=[UIColor colorWithRed:184/255.0 green:166/255.0 blue:228/255.0 alpha:1];
   //  line.backgroundColor=
    _txtPass.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtPass.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtUserName.clearButtonMode = UITextFieldViewModeWhileEditing;
}
-(IBAction)onClickCreateAccount:(id)sender{
    
    BC_InvitationScreen *menuView =[[BC_InvitationScreen alloc]initWithNibName:@"BC_InvitationScreen" bundle:nil];
    
   // [self.navigationController pushViewController:menuView animated:NO];
     [self presentViewController:menuView animated:YES completion:nil];
//    [[ECSMessage sharedInstance] sendMailTo:@"info@buckworm.com" subject:@"Requesting access" body:@"Please generate a login for me to access the Country Hills app.  My email address is …" withController:self];
//    
}

-(void)startServiceToLogIn
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToLogin) withObject:nil];
    
    
}

-(void)serviceToLogin
{
    
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
 
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/login",SERVERURLPATH]];
    NSString *str=self.txtUserName.text;
    str = [str stringByReplacingOccurrencesOfString:@"@mailinator.com"
                                         withString:@""];
    [class addParam:self.txtUserName.text forKey:@"username"];
    [class addParam:self.txtUserName.text forKey:@"email"];
    [class addParam:self.txtPass.text forKey:@"password"];
    
//    [class addParam:@"ios" forKey:@"platform"];
//    [class addParam:@"Country Hills" forKey:@"source"];
//    [class addParam:@"regular" forKey:@"user_role"];
    [class setCallback:@selector(callBackServiceToGetLogin:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetLogin:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
            
        if ([[rootDictionary objectForKey:@"statusDescription"] isEqualToString:@"Success"]) {
            
            self.appUserObject = [AppUserObject instanceFromDictionary:[rootDictionary objectForKey:@"user"]];
            
            [self.appUserObject saveToUserDefault];
            ALUser * user = [[ALUser alloc] init];
            [user setUserId:self.appUserObject.appLogicId];
            [user setEmail:[self.txtUserName text]];
            [user setPassword:@""];
            [user setDisplayName:self.appUserObject.username];
            
            ALChatManager * chatManager = [[ALChatManager alloc] initWithApplicationKey:APPLOZIC_KEY];
            [chatManager registerUser:user];

            UIViewController *menuVC=[[DS_SideMenuVC alloc]initWithNibName:@"DS_SideMenuVC" bundle:nil];
            
            CH_HomeVC *accountScreen = [[CH_HomeVC alloc]initWithNibName:@"CH_HomeVC" bundle:nil];
            [ECSHelper setRootViewController:accountScreen withLeftController:menuVC];
            

            //[self.navigationController popToRootViewControllerAnimated:NO];
            [self.view removeFromSuperview];
        }else  if ([rootDictionary objectForKey:@"statusDescription"] )
        {
            
            [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];
            
        }else{
             [ECSAlert showAlert:[rootDictionary objectForKey:@"error"]];
        }
    
       
       
        
    }
    else {
        
         [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        
    }
    
}

-(IBAction)onClickGetStarted:(id)sender{
    
    if (self.txtUserName.text.length==0)
    {
        [ECSAlert showAlert:@"Please enter your credentials"];

    }
    else if (self.txtPass.text.length<=5)
    {
         [ECSAlert showAlert:@"Password is too short"];
    }else{
        [self startServiceToLogIn];
    }
    
}

- (IBAction)clickToLogin:(id)sender {
    
}

-(IBAction)clickBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)OnClickForgot:(id)sender{
    BC_ForgotPassword *accountScreen = [[BC_ForgotPassword alloc]initWithNibName:@"BC_ForgotPassword" bundle:nil];
               // [ECSHelper setRootViewController:accountScreen withLeftController:menuVC];
    [self.navigationController pushViewController:accountScreen animated:YES];
    //[self presentViewController:accountScreen animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    //self.popUpView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.scroll_addContact setContentSize:CGSizeMake(self.scroll_addContact.frame.size.width, 600)];
}
-(IBAction)onclickBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)startServicetoChangeAppLogicState
{
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(servicetoChangeAppLogicState) withObject:nil];
    
    
}

-(void)servicetoChangeAppLogicState
{
    
    
    /*
     
     www.buckworm.com/laravel/index.php/api/v1/chat-registered
     Param: is_chat_registered(should be 0 or 1)
     Method: post
     login : required
     */
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/chat-registered",SERVERURLPATH]];
    [class addParam:@"1" forKey:@"is_chat_registered"];
    [class setCallback:@selector(callBackServiceToChangeAppLogicState:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToChangeAppLogicState:(ECSResponse *)response
{
  //  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    
    NSLog(@"Response: %@", response.stringValue);
    
    // As we do not need to consider the response for thsi api
    
    if(response.isValid)
    {
      
    }
    
    else {
    
    }
    
}





@end
