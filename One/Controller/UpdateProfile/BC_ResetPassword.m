//
//  BC_NewContactVC.m
//  BergerCounty
//
//  Created by Daksha Mac 3 on 18/05/16.
//  Copyright © 2016 Daksha Systems & services Pvt. Ltd. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BC_ResetPassword.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "AppUserObject.h"
#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SAMTextView.h"
#import "BC_ProfileVC.h"
#import "JJMaterialTextField.h"
#import "ECSServiceClass.h"
//#import "iToast.h"
#import "CHE_EditImageVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface BC_ResetPassword ()<UITextFieldDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;

@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtPassword;
@property (strong, nonatomic) IBOutlet JJMaterialTextfield *txtResetPassword;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll_addContact;
@property (strong, nonatomic) IBOutlet UIButton *btnUserImag;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (nonatomic, retain) NSString * prefilledUsername;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
- (IBAction)clickToback:(id)sender;

- (IBAction)clickToResetPassword:(id)sender;
- (IBAction)clickToUploadImage:(id)sender;

@property (weak, nonatomic) IBOutlet JJMaterialTextfield *currentPass;


@property (weak, nonatomic) IBOutlet UIView *viewCurrentPass;

@property (weak, nonatomic) IBOutlet UIView *viewNewPass;


@property (weak, nonatomic) IBOutlet UIView *viewConfPass;

@end


@implementation BC_ResetPassword
//@synthesize username;


-(void)viewDidAppear:(BOOL)animated
{
    if(self.username1.length>0)
    {
        [self.viewCurrentPass setHidden:YES];
        [self.viewNewPass setFrame:CGRectMake(self.viewNewPass.frame.origin.x, self.viewNewPass.frame.origin.y - self.viewCurrentPass.frame.size.height, self.viewNewPass.frame.size.width, self.viewNewPass.frame.size.height)];
        [self.viewConfPass setFrame:CGRectMake(self.viewConfPass.frame.origin.x, self.viewConfPass.frame.origin.y - self.viewCurrentPass.frame.size.height, self.viewConfPass.frame.size.width, self.viewConfPass.frame.size.height)];
        
        [self.scroll_addContact setContentSize:CGSizeMake(self.scroll_addContact.frame.size.width, 600)];
        self.imgUserProfile.hidden=YES;
         self.btnEdit.hidden=YES;
        self.btnUserImag.hidden=YES;
    }else{
        self.imgUserProfile.hidden=NO;
        self.btnEdit.hidden=NO;
        self.btnUserImag.hidden=NO;
    }

}



- (void)viewDidLoad {
    [super viewDidLoad];
   
     self.btnSignUp.layer.borderWidth = 0.0;
     //self.btnSignUp.layer.borderColor = UIColor.blueColor().CGColor
    
   // [self settingTopView:self.viewTop onController:self andTitle:@"Reset Password"];
    
    self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.width / 2;
    self.imgUserProfile.clipsToBounds = YES;
    
    
    self.btnUserImag.layer.cornerRadius = self.btnUserImag.frame.size.height/2;
    self.btnUserImag.clipsToBounds = YES;
    
    // border
    [[UIColor colorWithRed:0.5f green:0.2f blue:0.7f alpha:1.0f] CGColor];
    [self.btnUserImag.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.btnUserImag.layer setBorderWidth:0.0f];
    
    // drop shadow
    [self.btnUserImag.layer setShadowColor:[UIColor whiteColor].CGColor];
    [self.btnUserImag.layer setShadowOpacity:0.0];
    [self.btnUserImag.layer setShadowRadius:0.0];
    [self.btnUserImag.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    
    
    
    //[self.activityProfileImage startAnimating];
    NSLog(@"self.appUserObject.profileImage %@",self.appUserObject.profileImage);
      if (self.appUserObject.profileImage ==(id)[NSNull null] ||[self.appUserObject.profileImage isEqualToString:@""]) {
        // self.btnEdit.hidden=YES;
        [self.btnEdit setButtonTitle:@"Upload"];
    }else{
        
        self.btnEdit.hidden=NO;
        [self.btnEdit setButtonTitle:@"edit"];
        [self.imgUserProfile ecs_setImageWithURL:[NSURL URLWithString:self.appUserObject.profileImage] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             // [self.activityProfileImage stopAnimating];
         }];

    }
    
      UIColor *color = [UIColor colorWithRed:184/255.0 green:166/255.0 blue:228/255.0 alpha:1];
   
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtResetPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm New Password" attributes:@{NSForegroundColorAttributeName: color}];
    
     self.currentPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Current Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    
//    UIFont *font1 = [UIFont fontWithName:@"Karla-Regular" size:12];
//    self.txtPassword.font=font1;
//    self.txtResetPassword.font=font1;
//    self.currentPass.font=font1;

    [self textFieldInitialization];
//    [self setTextFieldImages];
//    [self setTextFieldsPadding];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotificationProfile"
                                               object:nil];
    NSLog(@"username %@",self.username1);
    if(self.username1.length)
    {
        [self.viewCurrentPass setHidden:YES];
        [self.viewNewPass setFrame:CGRectMake(self.viewNewPass.frame.origin.x, self.viewNewPass.frame.origin.y - self.viewCurrentPass.frame.size.height, self.viewNewPass.frame.size.width, self.viewNewPass.frame.size.height)];
        [self.viewConfPass setFrame:CGRectMake(self.viewConfPass.frame.origin.x, self.viewConfPass.frame.origin.y - self.viewCurrentPass.frame.size.height, self.viewConfPass.frame.size.width, self.viewConfPass.frame.size.height)];
        
        [self.scroll_addContact setContentSize:CGSizeMake(self.scroll_addContact.frame.size.width, 600)];
        self.imgUserProfile.hidden=YES;
        self.btnEdit.hidden=YES;
        self.btnUserImag.hidden=YES;
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithUsername:(NSString *)usernamel withToken:(NSString *)token
{
    
    self = [self initWithNibName:@"BC_ResetPassword" bundle:nil];
//    self.prefilledUsername = usernamel;
//    self.username=usernamel;
//    self.token=token;
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    [self.btnEdit setButtonTitle:@"edit"];
    if (notification.object) {
        self.imgUserProfile.image=notification.object;
    }
    
    
}


-(void)textFieldInitialization
{
    _txtResetPassword.enableMaterialPlaceHolder = YES;
    _txtResetPassword.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtResetPassword.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtResetPassword.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    
    
    _currentPass.enableMaterialPlaceHolder = YES;
    _currentPass.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _currentPass.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _currentPass.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    _txtPassword.enableMaterialPlaceHolder = YES;
    _txtPassword.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    _txtPassword.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    _txtPassword.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    
    
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

-(void)setTextFieldsPadding
{
    [self.txtPassword setRightPadding];
    [self.currentPass setRightPadding];

    [self.txtResetPassword setRightPadding];
 
}

-(void)resignTextResponder
{
    
    [self.txtPassword resignFirstResponder];
    [self.currentPass resignFirstResponder];
    [self.txtResetPassword resignFirstResponder];

    
}

- (IBAction)clickToResetPassword:(id)sender {
    
    [self resignTextResponder];
    
    if (self.txtPassword.text.length<=6)
    {
        [ECSAlert showAlert:@"Password is too short"];
//        [[[[iToast makeText:@"Password is too short"]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

    }
    else if (self.txtResetPassword.text.length==0)
    {
        [ECSAlert showAlert:@"Password is too short"];
//        [[[[iToast makeText:@"Password is too short"]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
    
   // [self validateEmail:self.txtEmail.text]
    else if (![self isValidPassword:self.txtPassword.text])
    {
        [ECSAlert showAlert:@"Please enter your new password"];
    }
     else if (![self.txtResetPassword.text isEqualToString: self.txtPassword.text])
    {
       [ECSAlert showAlert:@"Password does not match"];
//        [[[[iToast makeText:@"Password do not match"]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    }
     else{
    [self startServiceToUpdatePassword];
    }
}
-(void)startServiceToUpdatePassword
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToUpdatePassword) withObject:nil];
    
    
}

-(void)serviceToUpdatePassword
{
    //https://www.buckworm.com/laravel/index.php/api/v1/addGroupMember
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
   
    //[class addHeader:APP_KEY_VAL forKey:APP_KEY];params: name,emails, password, user_type, username all are required
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    if (self.username1) {
         [class setServiceMethod:POST];
        
        [class setServiceURL:[NSString stringWithFormat:@"%@v1/%@",SERVERURLPATH,@"ResetNewPassword"]];
        // [class setServiceURL:[NSString stringWithFormat:@"https://www.buckworm.com/laravel/index.php/api/v1/ResetNewPassword"]];
        [class addParam:self.username1 forKey:@"username"];
        [class addParam:self.token forKey:@"token"];
        [class addParam:self.txtPassword.text forKey:@"newpassword"];
    }else
    {
         [class setServiceMethod:PUT];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/users/%@",SERVERURLPATH,self.appUserObject.userId]];
    [class addParam:self.txtPassword.text forKey:@"password"];
    [class addParam:self.currentPass.text forKey:@"current_password"];
    }
    [class setCallback:@selector(callBackServiceToGetUpdatePassword:)];
    [class setController:self];
    [class runService];
}

-(void)callBackServiceToGetUpdatePassword:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
      //  ;
        if (self.username1) {
            
            if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Password Reset Successfully."]) {
              
              UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"Password reset successful!"
                                                        message:@""
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
       
        alertView1.tag=2;
        [alertView1 show];
            }
        }else{
            
            
            if ([[rootDictionary objectForKey:@"statusDescription"] isEqualToString:@"Profile successfully updated!"]) {
                
                 [ECSAlert showAlert:@"Updated"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                 [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];
               

            }
            

            
                }
        }
    else {
        
//        [[[[iToast makeText:[rootDictionary objectForKey:@"errors"]]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
       
    }
    
}


//-(void)startServiceToResetPassword
//{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [self performSelectorInBackground:@selector(serviceToResetPassword) withObject:nil];
//    
//    
//}
//
//-(void)serviceToForgotPassword
//{
//    //URL: http://www.buckworm.com/laravel/api/v1/ResetNewPassword
////param:   'username' , token ,password
//
//    
//    ECSServiceClass * class = [[ECSServiceClass alloc]init];
//    [class setServiceMethod:POST];
//    [class addHeader:APP_KEY_VAL forKey:APP_KEY];
//    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
//    [class setServiceURL:[NSString stringWithFormat:@"%@v1/ResetNewPassword",SERVERURLPATH]];
//    [class addParam:self.txtPassword.text forKey:@"newpassword"];
//    [class addParam:self.txtPassword.text forKey:@"username"];
//    [class addParam:self.txtPassword.text forKey:@"token"];
//    [class setCallback:@selector(callBackServiceToForgotPassword:)];
//    [class setController:self];
//    [class runService];
//}
//
//-(void)callBackServiceToForgotPassword:(ECSResponse *)response
//{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
//    if(response.isValid)
//    {
//        [ECSAlert showAlert:[rootDictionary objectForKey:@"statusDescription"]];
//        if(self.navigationController==Nil)
//        {
//            [self dismissViewControllerAnimated:YES completion:^{
//                
//            }];
//        } else{
//            //            BC_ContactScreenVC * contactVc= [[BC_ContactScreenVC alloc]initWithNibName:@"BC_ContactScreenVC" bundle:nil];
//            //            [self.navigationController pushViewController:contactVc animated:YES];
//        }
//        
//    }
//    else {
//        
//        [ECSAlert showAlert:[rootDictionary objectForKey:@"errors"]];
//    }
//    
//}




-(BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}



-(BOOL)isValidPassword:(NSString *)passwordString
{
    int numberofCharacters = 0;
    BOOL lowerCaseLetter,upperCaseLetter,digit,specialCharacter = 0;
    if([self.txtPassword.text length] >= 6)
    {
        for (int i = 0; i < [self.txtPassword.text length]; i++)
        {
            unichar c = [self.txtPassword.text characterAtIndex:i];
            if(!lowerCaseLetter)
            {
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
           
        }
        
        if( digit && lowerCaseLetter )
        {
            
        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                            message:@"Please Ensure that you have at least one character and one digit "
//                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
            
//            [[[[iToast makeText:@"Please Ensure that you have at least one character and one digit "]
//               setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];

            
        }
    
        
}
    return YES;
}

- (IBAction)clickToback:(id)sender {
    
//    BC_ProfileVC * contactVc= [[BC_ProfileVC alloc]initWithNibName:@"BC_ProfileVC" bundle:nil];
//    
//    NSMutableArray * arrayViewController = self.navigationController.viewControllers.mutableCopy;
//    [arrayViewController removeObject:self];
//    
//    
//    [UIView beginAnimations: @"View Flip" context: nil];
//    [UIView setAnimationDuration: 1.0];
//    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView: self.navigationController.view cache: NO];
//    
//     [arrayViewController addObject:contactVc];
//    [self.navigationController setViewControllers:arrayViewController];
//  //  [self.navigationController pushViewController:contactVc animated:YES];
//    [UIView commitAnimations];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clickToUploadImage:(id)sender {
    
    
    [self resignTextResponder];
    if (self.btnEdit.hidden==YES) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image from"
                                                                 delegate:(id<UIActionSheetDelegate>)self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Choose Photo", @"Take Photo", nil];
        
        [actionSheet showInView:self.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image from"
                                                                 delegate:(id<UIActionSheetDelegate>)self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Delete Photo"
                                                        otherButtonTitles:@"Choose Photo", @"Take Photo", nil];
        
        [actionSheet showInView:self.view];
        
    }
}


//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    //NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
//    if (self.btnEdit.hidden==YES){
//        if(buttonIndex==0)
//        {
//            
//            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            imagePickerController.delegate = self;
//            [self presentViewController:imagePickerController animated:YES completion:nil];
//        }
//        else if(buttonIndex==1)
//        {
//            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//            imagePickerController.delegate = self;
//            [self presentViewController:imagePickerController animated:YES completion:nil];
//            
//        }
//        
//    }else{
//        if (buttonIndex==0) {
//            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to delete?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Ok" ,nil];
//            alert.tag=101;
//            [alert show];
//            
//        }
//        else if(buttonIndex==1)
//        {
//            
//            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            imagePickerController.delegate = self;
//            [self presentViewController:imagePickerController animated:YES completion:nil];
//        }
//        else if(buttonIndex==2)
//        {
//            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//            imagePickerController.delegate = self;
//            [self presentViewController:imagePickerController animated:YES completion:nil];
//            
//        }
//    }
//}
//
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

    
    
    if (alertView.tag == 101)
    {
        if (buttonIndex == 0){
            
        }else if(buttonIndex == 1){
            NSLog(@"self.appUserObject.profileImage %@",self.appUserObject.profileImage);
            if ([self.appUserObject.profileImage isEqualToString:@""]) {
                //self.btnEdit.hidden=YES;
                [self.btnEdit setButtonTitle:@"Upload"];
                
                NSString *nothingString = [NSString  stringWithFormat:@"add-photo.png"];
                
                
                self.imgUserProfile.image=[UIImage imageNamed:nothingString];
                //self.imgUserProfile.frame=CGRectMake(110, 14, 101, 101);
                self.imgUserProfile.backgroundColor=[UIColor whiteColor];
                
                
            }else{
                self.btnEdit.hidden=YES;
                [self startServiceDeleteUserProfileImage];
            }
        }
        //Do something
    }
    else
    {
        //Do something else
    }
}
-(void)startServiceDeleteUserProfileImage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToDeleteUserProfileImage) withObject:nil];
    
    
}

-(void)serviceToDeleteUserProfileImage
{
    //http://www.buckworm.com/laravel/index.php/api/v1/removeUserProfilePic/{userId}
    
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:GET];
    [class addHeader:self.appUserObject.apiToken forKey:AUTH_TOKEN];
    [class setServiceURL:[NSString stringWithFormat:@"%@v1/removeUserProfilePic/user/%@",SERVERURLPATH,self.appUserObject.userId]];
    [class addParam:@"ios" forKey:@"device_type"];
    // [class addParam:@"user" forKey:@"type"];
    [class setCallback:@selector(callBackServiceToDeleteUserProfileImage:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToDeleteUserProfileImage:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        
        // [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        if ([[rootDictionary objectForKey:@"message"] isEqualToString:@"Image removed successfully."]) {
            [ECSAlert showAlert:@"Deleted!"];
            self.btnEdit .hidden=NO;
            [self.btnEdit setButtonTitle:@"Upload"];
            self.imgUserProfile.image=nil;
            NSString *nothingString = [NSString  stringWithFormat:@"add-photo.png"];
            self.imgUserProfile.image=[UIImage imageNamed:nothingString];
            self.imgUserProfile.backgroundColor=[UIColor whiteColor];
        }else{
            self.imgUserProfile.image=nil;
            [self.btnEdit setButtonTitle:@"Upload"];
            // self.imgUserProfile.image = [UIImage imageNamed:@"add-photo.png"];
            [self.imgUserProfile setImage:[UIImage imageNamed:@"add-photo.png"]];
            [ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
        }
        
        
    }
    else {
        
        //[ECSAlert showAlert:[rootDictionary objectForKey:@"message"]];
//        [[[[iToast makeText:[rootDictionary objectForKey:@"message"]]
//           setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        // [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    
    self.btnEdit.hidden=NO;
    self.imgUserProfile.image=image;
    [self.btnUserImag setImage:image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        //self.isImageUploadRequired = YES;
    }];
}



-(IBAction)editProfileImage:(id)sender{
    if ([self.btnEdit.titleLabel.text isEqualToString:@"Upload"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image from"
                                                                 delegate:(id<UIActionSheetDelegate>)self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Library", @"Camera",@"Last Photo Taken", nil];
        
        [actionSheet showInView:self.view];
    }else{
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image from"
                                                                 delegate:(id<UIActionSheetDelegate>)self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Delete "
                                                        otherButtonTitles:@"Resize", @"Choose New", nil];
        
        [actionSheet showInView:self.view];
        
        
    }
    
    
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if ([self.btnEdit.titleLabel.text isEqualToString:@"Upload"]){
        if(buttonIndex==0)
        {
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else if(buttonIndex==1){
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else if(buttonIndex==2)
        {
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                         usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                             if (nil != group) {
                                                 // be sure to filter the group so you only get photos
                                                 [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                                 
                                                 if (group.numberOfAssets > 0) {
                                                     [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:group.numberOfAssets - 1]
                                                                             options:0
                                                                          usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                                              if (nil != result) {
                                                                                  //                                                                                  ALAssetRepresentation *repr = [result defaultRepresentation];
                                                                                  //                                                                                  // this is the most recent saved photo
                                                                                  //                                                                                  UIImage *img = [UIImage imageWithCGImage:[repr fullResolutionImage]];
                                                                                  ALAssetRepresentation *rep = [result defaultRepresentation];
                                                                                  UIImage *img = [UIImage
                                                                                                  imageWithCGImage:[rep fullScreenImage]
                                                                                                  scale:[rep scale]
                                                                                                  orientation:UIImageOrientationUp];
                                                                                  // UIImage *img = [UIImage imageWithCGImage:[rep fullResolutionImage]];
                                                                                  
                                                                                  self.btnEdit.hidden=NO;
                                                                                  self.imgUserProfile.image=img;
//                                                                                  self.isImageUploadRequired = YES;
//                                                                                  CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
//                                                                                  contentScreen.selectedImage=self.imgUserProfile.image;
//                                                                                  [self.navigationController pushViewController:contentScreen animated:YES];
//                                                                                  *stop = YES;
                                                                              }
                                                                          }];
                                                 }
                                             }
                                             
                                             *stop = NO;
                                         } failureBlock:^(NSError *error) {
                                             NSLog(@"error: %@", error);
                                         }];
        }
        
    }
    
    else{
        if (buttonIndex==0) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to delete?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Ok" ,nil];
            alert.tag=101;
            [alert show];
            
        }
        else if(buttonIndex==1)
        {
            
            //        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //        imagePickerController.delegate = self;
            //        [self presentViewController:imagePickerController animated:YES completion:nil];
            
//            CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
//            contentScreen.selectedImage=self.imgUserProfile.image;
//            [self.navigationController pushViewController:contentScreen animated:YES];
            
            
        }
        else if(buttonIndex==2)
        {
            //        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            //        imagePickerController.delegate = self;
            //        [self presentViewController:imagePickerController animated:YES completion:nil];
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
            
        }
    }
}
-(void)editProfileImagedirectioly{
    
    
    
//    CHE_EditImageVC *contentScreen = [[CHE_EditImageVC alloc]initWithNibName:@"CHE_EditImageVC" bundle:nil];
//    contentScreen.selectedImage=self.imgUserProfile.image;
//    [self.navigationController pushViewController:contentScreen animated:YES];
    
    
}



@end
