//
//  DS_OneLoginVC.m
//  One
//
//  Created by Daksha on 1/20/17.
//  Copyright © 2017 Daksha. All rights reserved.
//

#import "DS_OneLoginVC.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "MBProgressHUD.h"
#import "ECSServiceClass.h"
#import "CH_HomeVC.h"
#import "DS_SideMenuVC.h"
//#import "iToast.h"
#import "CH_SignupVC.h"
#import "ECSHelper.h"
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
#import "DS_OneForgotPassVC.h"
#import "UsersDetails.h"
@interface DS_OneLoginVC ()<UITextFieldDelegate>
{
    NSString *usernameSaved;
    UsersDetails  *object;
}
@property(weak,nonatomic)IBOutlet UITextField *textAccessCode;
@property(weak,nonatomic)IBOutlet UILabel *lblAccess;
//@property(weak,nonatomic)IBOutlet UILabel *lblAccessText;//
@property(strong,nonatomic)IBOutlet UIButton *btnNext;
@property(strong,nonatomic)IBOutlet UIButton *showPass;
@property(strong,nonatomic)IBOutlet UIButton *btnForgotPassword;
@property(weak,nonatomic)IBOutlet UIImageView *userProfileImg;
@property(strong,nonatomic)IBOutlet UIView *viewCofm;
@property(weak,nonatomic)IBOutlet UILabel *lblMsgText;//

@end

@implementation DS_OneLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.textAccessCode.delegate = self;
    self.btnNext.titleLabel.textColor=[UIColor lightGrayColor];
   self.textAccessCode.autocorrectionType = UITextAutocorrectionTypeNo;
    self.btnNext.enabled = NO;
    self.showPass.hidden=YES;
    self.btnForgotPassword.hidden=YES;
    self.textAccessCode.frame=CGRectMake(30, 80, 245, 40);
     [ self.textAccessCode becomeFirstResponder];
      self.viewCofm.hidden=YES;
         // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onClickBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickNext:(id)sender{
  
    
    if ([self.lblAccess.text isEqualToString:@"Email"]) {
    if ( [self.textAccessCode.text isEqualToString:@""]) {
         self.btnNext.enabled = NO;
        [ECSAlert showAlert:@"Please Enter Email Id"];
    }else{
        [self startServiceToGetUserDetail];
//        [self startServiceToGetAppInfo];
    }
    }
    else if ([self.lblAccess.text isEqualToString:@"Password"]){
        
        if ( [self.textAccessCode.text isEqualToString:@""]) {
            //self.btnNext.enabled = NO;
            [ECSAlert showAlert:@"Please Enter Password "];
        }
        else if ( self.btnNext.enabled==YES) {
            //[ECSAlert showAlert:@"Please Call Login Api"];
            [self startServiceToLogIn];
        }
        
        
    }
    
}


- (IBAction)ShowPass:(UIButton *)sender {
    if (self.textAccessCode.secureTextEntry == YES) {
        [ self.showPass setTitle:@"Hide" forState:(UIControlStateNormal)];
        
        self.textAccessCode.secureTextEntry = NO;
        
    }
    
    else
    {
        [ self.showPass setTitle:@"Show" forState:(UIControlStateNormal)];
        self.textAccessCode.secureTextEntry = YES;
    }
    
    
}


-(void)startServiceToGetUserDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetUserDetail) withObject:nil];
    
    
}

-(void)serviceToGetUserDetail
{
//https://www.buckworm.com/laravel/index.php/api/v1/get-user-data
//    
//Method: post
//    
//param: username
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/get-user-data",SERVERURLPATH]];
    [class addParam:self.textAccessCode.text forKey:@"username"];
    usernameSaved=self.textAccessCode.text;
   
    [class addParam:@"ios" forKey:@"device_type"];
    [class setCallback:@selector(callBackServiceGetUserDetail:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceGetUserDetail:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        if([[rootDictionary objectForKey:@"statusDescription"] isEqualToString:@"success"])
        {
            
            self.lblAccess.text=@"Password";
             self.textAccessCode.frame=CGRectMake(30, 80, 240, 40);
            self.textAccessCode.text=@"";
            self.textAccessCode.secureTextEntry = YES;
            self.showPass.hidden=NO;
            self.btnForgotPassword.hidden=NO;
            [self.btnNext setTitle:@"Login" forState:UIControlStateNormal];
            [self.btnNext setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            self.btnNext.enabled = NO;
            
          object=[UsersDetails instanceFromDictionary:[rootDictionary objectForKey:@"usersDetails"]];
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:object.profileImage forKey:@"usersDetails"];
           // [ECSUserDefault  saveObject:object ToUserDefaultForKey:@"usersDetail"];
            if(object.profileImage.length>0)
            [self.userProfileImg ecs_setImageWithURL:[NSURL URLWithString:object.profileImage] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 //[self.activityProfileImage stopAnimating];
             }];
            
        }
        else{
            [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        }
    }
    
    else
    {
        [ECSAlert showApiError:rootDictionary respString:response.stringValue error:response.error];
        
    }
    
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if (textField == self.textAccessCode) {
        [textField resignFirstResponder];

        if ([self.lblAccess.text isEqualToString:@"Email"]) {
            if ( [self.textAccessCode.text isEqualToString:@""]) {
                self.btnNext.enabled = NO;
                [ECSAlert showAlert:@"Please Enter Email Id"];
            }else{

                        [self startServiceToGetUserDetail];
               // [self startServiceToGetAppInfo];
            }
        }
        
        else if ([self.lblAccess.text isEqualToString:@"Password"]){
            if ( [self.textAccessCode.text isEqualToString:@""]) {
                //self.btnNext.enabled = NO;
                [ECSAlert showAlert:@"Please Enter Password "];
            }
            else if (self.btnNext.enabled==YES) {
                // [ECSAlert showAlert:@"Please Call Login Api here"];
                [self startServiceToLogIn];
            }
        }

    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textField.text];
//    //    [attributedString addAttribute:NSKernAttributeName
//    //                             value:@(22.86)
//    //                             range:NSMakeRange(0, self.textAccessCode.text.length)];
//    
//    self.textAccessCode.attributedText = attributedString;
//    
    if ( [self.textAccessCode.text isEqualToString:@""]) {
        [self.btnNext setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.btnNext.enabled = NO;
    }else{
        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        self.btnNext.enabled = YES;
    }
    
    return YES;
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
   
    [class addParam:usernameSaved forKey:@"username"];
    [class addParam:usernameSaved forKey:@"email"];
    [class addParam:self.textAccessCode.text forKey:@"password"];
    

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
           
            [user setPassword:@""];
            [user setDisplayName:self.appUserObject.username];
            
            ALChatManager * chatManager = [[ALChatManager alloc] initWithApplicationKey:APPLOZIC_KEY];
            [chatManager registerUser:user];
            
            UIViewController *menuVC=[[DS_SideMenuVC alloc]initWithNibName:@"DS_SideMenuVC" bundle:nil];
            
            CH_HomeVC *accountScreen = [[CH_HomeVC alloc]initWithNibName:@"CH_HomeVC" bundle:nil];
            [ECSHelper setRootViewController:accountScreen withLeftController:menuVC];
            
           
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

-(IBAction)onClickForgotPass:(id)sender{
    

    [self startServiceToForgotPassword];
}

-(void)startServiceToForgotPassword
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToForgotPassword) withObject:nil];
    
    
}

-(void)serviceToForgotPassword
{
    // http://www.buckworm.com/laravel/api/v1/reset/{username}
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    [class addHeader:APP_KEY_VAL forKey:APP_KEY];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/reset/%@",SERVERURLPATH,usernameSaved]];
    [class addParam:@"3" forKey:@"ISGPC"];
    
    
    [class addParam:@"oneresetpass://" forKey:@"redirect_uri"];
    [class addParam:@"Oneapp" forKey:@"source"];
    
    
    
    [class setCallback:@selector(callBackServiceToForgotPassword:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToForgotPassword:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        //A password reset link has been sent to your email.
        
        if ([[rootDictionary objectForKey:@"statusDescription"] isEqualToString:@"A password Reset Link is send to your Mail."]) {
           // [ECSAlert showAlert:@"A password reset link has been sent to your email."];
            self.viewCofm.hidden=NO;
              [ self.textAccessCode resignFirstResponder];
            NSString *messageTxt=[NSString stringWithFormat:@"We sent you an email to reset your password at  %@",usernameSaved];
            self.lblMsgText.text=messageTxt;
            [self.view addSubview:self.viewCofm];
            
        }else{
            [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];
        }
        if(self.navigationController==Nil)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else{
            //            BC_ContactScreenVC * contactVc= [[BC_ContactScreenVC alloc]initWithNibName:@"BC_ContactScreenVC" bundle:nil];
            //            [self.navigationController pushViewController:contactVc animated:YES];
        }
        
    }
    else {
        
        
        //        [[[[iToast makeText:[rootDictionary objectForKey:@"errors"]]
        //           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
    
}
-(IBAction)onClickConfBack:(id)sender{
    //
    self.viewCofm.hidden=YES;
    // [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onClickOk:(id)sender{
      self.viewCofm.hidden=YES;
   // [self.navigationController popViewControllerAnimated:YES];
}



@end
